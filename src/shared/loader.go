package shared

import (
	"encoding/csv"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strconv"
)

// readCSV lee un CSV fila por fila (sin ReadAll) y entrega solo las columnas
// pedidas, en el orden de cols. El slice que recibe fn se reutiliza.
func readCSV(path string, cols []string, fn func(row []string) error) error {
	name := filepath.Base(path)
	f, err := os.Open(path)
	if err != nil {
		return err
	}
	defer f.Close()

	r := csv.NewReader(f)
	r.ReuseRecord = true

	header, err := r.Read()
	if err != nil {
		return fmt.Errorf("%s: cabecera: %w", name, err)
	}
	pos := make([]int, len(cols))
	for i, col := range cols {
		pos[i] = -1
		for j, h := range header {
			if h == col {
				pos[i] = j
			}
		}
		if pos[i] < 0 {
			return fmt.Errorf("%s: falta la columna %q", name, col)
		}
	}

	row := make([]string, len(cols))
	for line := 2; ; line++ {
		rec, err := r.Read()
		if err == io.EOF {
			return nil
		}
		if err != nil {
			return fmt.Errorf("%s: %w", name, err)
		}
		for i, p := range pos {
			row[i] = rec[p]
		}
		if err := fn(row); err != nil {
			return fmt.Errorf("%s línea %d: %w", name, line, err)
		}
	}
}

// LoadDataset carga y valida los 4 CSV de la carpeta dir.
func LoadDataset(dir string) (*Dataset, error) {
	d := &Dataset{}
	courseIdx, err := d.loadCourses(filepath.Join(dir, "cursos.csv"))
	if err != nil {
		return nil, err
	}
	if err := d.loadPrereqs(filepath.Join(dir, "dag_prerequisitos.csv"), courseIdx); err != nil {
		return nil, err
	}
	studentIdx, err := d.loadStudents(filepath.Join(dir, "estudiantes.csv"))
	if err != nil {
		return nil, err
	}
	if err := d.loadInteractions(filepath.Join(dir, "interacciones.csv"), studentIdx, courseIdx); err != nil {
		return nil, err
	}
	return d, nil
}

func (d *Dataset) loadCourses(path string) (map[string]int, error) {
	idx := make(map[string]int)
	var perCore [NumCores]uint

	err := readCSV(path, []string{"course_id", "nucleo"}, func(row []string) error {
		core, ok := CoreNames[row[1]]
		if !ok {
			return fmt.Errorf("núcleo desconocido %q", row[1])
		}
		if _, dup := idx[row[0]]; dup {
			return fmt.Errorf("curso duplicado %q", row[0])
		}
		idx[row[0]] = len(d.CourseNames)
		d.CourseNames = append(d.CourseNames, row[0])
		d.CourseCore = append(d.CourseCore, core)
		d.CourseBit = append(d.CourseBit, perCore[core])
		perCore[core]++
		return nil
	})
	if err != nil {
		return nil, err
	}
	for c, n := range perCore {
		if n != CoursesPerCore {
			return nil, fmt.Errorf("cursos.csv: el núcleo %d tiene %d cursos, se esperaban %d", c, n, CoursesPerCore)
		}
	}
	return idx, nil
}

func (d *Dataset) loadPrereqs(path string, courseIdx map[string]int) error {
	d.Prereqs = make([][MaxPrereqs]int, d.NumCourses())
	for i := range d.Prereqs {
		for j := range d.Prereqs[i] {
			d.Prereqs[i][j] = NoPrereq
		}
	}

	err := readCSV(path, []string{"prerequisito_id", "course_id"}, func(row []string) error {
		pre, ok := courseIdx[row[0]]
		if !ok {
			return fmt.Errorf("prerrequisito inexistente %q", row[0])
		}
		c, ok := courseIdx[row[1]]
		if !ok {
			return fmt.Errorf("curso inexistente %q", row[1])
		}
		if pre == c {
			return fmt.Errorf("el curso %q es prerrequisito de sí mismo", row[1])
		}
		for j, p := range d.Prereqs[c] {
			if p == pre {
				return fmt.Errorf("arista duplicada %q -> %q", row[0], row[1])
			}
			if p == NoPrereq {
				d.Prereqs[c][j] = pre
				d.NumEdges++
				return nil
			}
		}
		return fmt.Errorf("el curso %q tiene más de %d prerrequisitos", row[1], MaxPrereqs)
	})
	if err != nil {
		return err
	}
	return d.checkAcyclic()
}

// checkAcyclic verifica que el DAG de prerrequisitos no tenga ciclos (Kahn).
func (d *Dataset) checkAcyclic() error {
	n := d.NumCourses()
	children := make([][]int, n)
	pending := make([]int, n) // prerrequisitos aún sin procesar
	for c, ps := range d.Prereqs {
		for _, p := range ps {
			if p != NoPrereq {
				children[p] = append(children[p], c)
				pending[c]++
			}
		}
	}
	queue := make([]int, 0, n)
	for c := range pending {
		if pending[c] == 0 {
			queue = append(queue, c)
		}
	}
	done := 0
	for len(queue) > 0 {
		c := queue[0]
		queue = queue[1:]
		done++
		for _, ch := range children[c] {
			if pending[ch]--; pending[ch] == 0 {
				queue = append(queue, ch)
			}
		}
	}
	if done != n {
		return errors.New("dag_prerequisitos.csv: el grafo de prerrequisitos tiene un ciclo")
	}
	return nil
}

func (d *Dataset) loadStudents(path string) (map[string]ID, error) {
	idx := make(map[string]ID)
	cols := []string{"student_id",
		"afinidad_matematica", "afinidad_lectura", "afinidad_ciencias",
		"habilidad_matematica", "habilidad_lectura", "habilidad_ciencias"}

	err := readCSV(path, cols, func(row []string) error {
		if _, dup := idx[row[0]]; dup {
			return fmt.Errorf("estudiante duplicado %q", row[0])
		}
		s := Student{ID: ID(len(d.Students))}
		for c := 0; c < NumCores; c++ {
			aff, err := parseUnit(row[1+c])
			if err != nil {
				return err
			}
			skill, err := parseUnit(row[1+NumCores+c])
			if err != nil {
				return err
			}
			s.Cores[c].Affinity, s.Cores[c].Skill = aff, skill
		}
		idx[row[0]] = s.ID
		d.Students = append(d.Students, s)
		d.StudentNames = append(d.StudentNames, row[0])
		return nil
	})
	return idx, err
}

// parseUnit lee un float que debe estar en [0,1].
func parseUnit(s string) (float64, error) {
	v, err := strconv.ParseFloat(s, 64)
	if err != nil {
		return 0, err
	}
	if v < 0 || v > 1 {
		return 0, fmt.Errorf("valor %v fuera de [0,1]", v)
	}
	return v, nil
}

// loadInteractions marca como aprobado todo (estudiante, curso) con al menos
// una fila aprobado=1, sin importar el intento.
func (d *Dataset) loadInteractions(path string, studentIdx map[string]ID, courseIdx map[string]int) error {
	return readCSV(path, []string{"student_id", "course_id", "aprobado"}, func(row []string) error {
		s, ok := studentIdx[row[0]]
		if !ok {
			return fmt.Errorf("estudiante inexistente %q", row[0])
		}
		c, ok := courseIdx[row[1]]
		if !ok {
			return fmt.Errorf("curso inexistente %q", row[1])
		}
		d.NumInteractions++
		switch row[2] {
		case "1":
			core := &d.Students[s].Cores[d.CourseCore[c]]
			core.Completed |= 1 << d.CourseBit[c]
		case "0":
		default:
			return fmt.Errorf("valor de aprobado inválido %q", row[2])
		}
		return nil
	})
}
