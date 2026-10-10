// Comando interactivo: ingresa un student_id y muestra sus recomendaciones.
//
//	go run ./consulta                  (pregunta el ID en un bucle)
//	go run ./consulta -student 123     (una sola consulta; acepta 123 o STU_000123)
package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"

	"recommendation/shared"
)

var coreLabel = [shared.NumCores]string{"Matemática", "Lectura", "Ciencias"}

func main() {
	dataDir := flag.String("data", "../dataset/data", "carpeta de los CSV")
	student := flag.String("student", "", "estudiante a consultar (si se omite, se pregunta)")
	flag.Parse()

	d, err := shared.LoadDataset(*dataDir)
	if err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
	index := make(map[string]shared.ID, d.NumStudents())
	for i, name := range d.StudentNames {
		index[name] = shared.ID(i)
	}

	if *student != "" {
		if !show(d, index, *student) {
			os.Exit(1)
		}
		return
	}

	fmt.Printf("%d estudiantes cargados (de STU_000000 a %s).\n", d.NumStudents(), d.StudentNames[d.NumStudents()-1])
	in := bufio.NewScanner(os.Stdin)
	for {
		fmt.Print("\nstudent_id (número o STU_xxxxxx, vacío para salir): ")
		if !in.Scan() || strings.TrimSpace(in.Text()) == "" {
			return
		}
		show(d, index, in.Text())
	}
}

// resolve acepta "STU_000123" o simplemente "123".
func resolve(d *shared.Dataset, index map[string]shared.ID, text string) (shared.ID, bool) {
	text = strings.ToUpper(strings.TrimSpace(text))
	if id, ok := index[text]; ok {
		return id, true
	}
	if n, err := strconv.Atoi(text); err == nil && n >= 0 && n < d.NumStudents() {
		return shared.ID(n), true
	}
	return 0, false
}

func show(d *shared.Dataset, index map[string]shared.ID, text string) bool {
	s, ok := resolve(d, index, text)
	if !ok {
		fmt.Printf("No existe el estudiante %q.\n", strings.TrimSpace(text))
		return false
	}

	st := &d.Students[s]
	fmt.Printf("\n== %s ==\n", d.StudentNames[s])
	for c := 0; c < shared.NumCores; c++ {
		fmt.Printf("  %-10s afinidad %.2f   habilidad %.2f\n", coreLabel[c], st.Cores[c].Affinity, st.Cores[c].Skill)
	}
	approved := 0
	for c := range d.CourseNames {
		if d.Approved(s, c) {
			approved++
		}
	}
	fmt.Printf("  Cursos aprobados: %d de %d\n", approved, d.NumCourses())

	neighbors := d.TopNeighbors(s, shared.NumNeighbors)
	fmt.Printf("\nVecinos más parecidos (similitud de Jaccard):\n")
	for _, n := range neighbors {
		fmt.Printf("  %s  %.3f\n", d.StudentNames[n.ID], n.Similarity)
	}

	recs := d.Recommend(s)
	if len(recs) == 0 {
		fmt.Println("\nSin cursos para recomendar (no hay candidatos).")
		return true
	}
	fmt.Printf("\nRecomendaciones:\n")
	for i, r := range recs {
		byNeighbors := 0
		for _, n := range neighbors {
			if d.Approved(n.ID, r.Course) {
				byNeighbors++
			}
		}
		fmt.Printf("  %d. %s (%s)  puntaje %.4f  | aprobado por %d de %d vecinos\n",
			i+1, d.CourseNames[r.Course], coreLabel[d.CourseCore[r.Course]], r.Score, byNeighbors, len(neighbors))
	}
	return true
}
