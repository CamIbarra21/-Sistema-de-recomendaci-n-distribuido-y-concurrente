package shared

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// fixture es un dataset mínimo válido (180 cursos, 3 estudiantes) cuyas
// partes se pueden alterar antes de escribirlo a disco.
type fixture struct {
	courses      []string // "id,nucleo"
	edges        []string // "pre,curso"
	students     []string
	interactions []string // "student,course,aprobado"
}

func newFixture() *fixture {
	f := &fixture{}
	prefix := []string{"MAT", "LEC", "CIE"}
	names := []string{"Matematica", "Lectura", "Ciencias"}
	for c := 0; c < NumCores; c++ {
		for i := 0; i < CoursesPerCore; i++ {
			f.courses = append(f.courses, fmt.Sprintf("%s_%04d,%s", prefix[c], c*CoursesPerCore+i, names[c]))
		}
	}
	f.edges = []string{"MAT_0000,MAT_0001", "MAT_0001,MAT_0002", "MAT_0000,MAT_0002"}
	f.students = []string{
		"STU_000000,0.1,0.2,0.3,0.4,0.5,0.6",
		"STU_000001,1,0,0.5,0.5,0.5,0.5",
		"STU_000002,0.3,0.3,0.3,0.3,0.3,0.3",
	}
	f.interactions = []string{
		"STU_000000,MAT_0000,0", // intento 1 reprobado
		"STU_000000,MAT_0000,1", // intento 2 aprobado
		"STU_000000,LEC_0060,1", // primer curso de Lectura -> bit 0
		"STU_000000,CIE_0179,1", // último de Ciencias -> bit 59
		"STU_000001,MAT_0001,0",
	}
	return f
}

func (f *fixture) write(t *testing.T) string {
	t.Helper()
	dir := t.TempDir()
	put := func(name, header string, lines []string) {
		body := header + "\n" + strings.Join(lines, "\n") + "\n"
		if err := os.WriteFile(filepath.Join(dir, name), []byte(body), 0o644); err != nil {
			t.Fatal(err)
		}
	}
	put("cursos.csv", "course_id,nucleo", f.courses)
	put("dag_prerequisitos.csv", "prerequisito_id,course_id", f.edges)
	put("estudiantes.csv", "student_id,afinidad_matematica,afinidad_lectura,afinidad_ciencias,habilidad_matematica,habilidad_lectura,habilidad_ciencias", f.students)
	put("interacciones.csv", "student_id,course_id,aprobado", f.interactions)
	return dir
}

func TestLoadDatasetOK(t *testing.T) {
	d, err := LoadDataset(newFixture().write(t))
	if err != nil {
		t.Fatal(err)
	}
	if d.NumStudents() != 3 || d.NumCourses() != 180 || d.NumEdges != 3 || d.NumInteractions != 5 {
		t.Fatalf("conteos inesperados: %d est, %d cursos, %d aristas, %d inter",
			d.NumStudents(), d.NumCourses(), d.NumEdges, d.NumInteractions)
	}
	if d.Prereqs[2] != [MaxPrereqs]int{1, 0} && d.Prereqs[2] != [MaxPrereqs]int{0, 1} {
		t.Errorf("prerrequisitos de MAT_0002 = %v", d.Prereqs[2])
	}
	if d.Prereqs[0] != [MaxPrereqs]int{NoPrereq, NoPrereq} {
		t.Errorf("MAT_0000 no debería tener prerrequisitos: %v", d.Prereqs[0])
	}
	s := d.Students[0]
	if s.Cores[CoreMath].Completed != 1 {
		t.Errorf("Math completed = %b, quiero 1 (aprobó en el intento 2)", s.Cores[CoreMath].Completed)
	}
	if s.Cores[CoreReading].Completed != 1 {
		t.Errorf("Reading completed = %b, quiero 1 (índice local 0)", s.Cores[CoreReading].Completed)
	}
	if s.Cores[CoreScience].Completed != 1<<59 {
		t.Errorf("Science completed = %b, quiero bit 59", s.Cores[CoreScience].Completed)
	}
	if s.Cores[CoreScience].Affinity != 0.3 || s.Cores[CoreScience].Skill != 0.6 {
		t.Errorf("afinidad/habilidad ciencias = %v/%v", s.Cores[CoreScience].Affinity, s.Cores[CoreScience].Skill)
	}
	if !d.Approved(0, 0) || d.Approved(1, 1) {
		t.Error("Approved incorrecto")
	}
	if d.TotalApproved() != 3 {
		t.Errorf("TotalApproved = %d, quiero 3", d.TotalApproved())
	}
	if d.StudentNames[2] != "STU_000002" || d.Students[2].ID != 2 {
		t.Error("índice denso incorrecto")
	}
}

func TestLoadDatasetErrors(t *testing.T) {
	cases := []struct {
		name   string
		mutate func(f *fixture)
		want   string
	}{
		{"más de 2 prerrequisitos", func(f *fixture) { f.edges = append(f.edges, "MAT_0003,MAT_0002") }, "más de 2 prerrequisitos"},
		{"ciclo", func(f *fixture) { f.edges = append(f.edges, "MAT_0002,MAT_0000") }, "ciclo"},
		{"auto-prerrequisito", func(f *fixture) { f.edges = append(f.edges, "MAT_0005,MAT_0005") }, "sí mismo"},
		{"arista duplicada", func(f *fixture) { f.edges = append(f.edges, "MAT_0000,MAT_0001") }, "duplicada"},
		{"prerrequisito inexistente", func(f *fixture) { f.edges = append(f.edges, "XXX_0001,MAT_0004") }, "inexistente"},
		{"núcleo con 59 cursos", func(f *fixture) { f.courses = f.courses[:len(f.courses)-1] }, "se esperaban 60"},
		{"núcleo desconocido", func(f *fixture) { f.courses[0] = "MAT_0000,Historia" }, "núcleo desconocido"},
		{"curso duplicado", func(f *fixture) { f.courses[1] = f.courses[0] }, "duplicado"},
		{"estudiante duplicado", func(f *fixture) { f.students[1] = f.students[0] }, "duplicado"},
		{"afinidad fuera de rango", func(f *fixture) { f.students[0] = "STU_000000,1.5,0,0,0,0,0" }, "fuera de [0,1]"},
		{"interacción con estudiante inexistente", func(f *fixture) { f.interactions = append(f.interactions, "STU_999999,MAT_0000,1") }, "estudiante inexistente"},
		{"interacción con curso inexistente", func(f *fixture) { f.interactions = append(f.interactions, "STU_000000,MAT_9999,1") }, "curso inexistente"},
		{"aprobado inválido", func(f *fixture) { f.interactions = append(f.interactions, "STU_000000,MAT_0000,2") }, "aprobado inválido"},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			f := newFixture()
			tc.mutate(f)
			_, err := LoadDataset(f.write(t))
			if err == nil || !strings.Contains(err.Error(), tc.want) {
				t.Fatalf("error = %v, quiero que contenga %q", err, tc.want)
			}
		})
	}
}

func TestLoadDatasetMissingFile(t *testing.T) {
	if _, err := LoadDataset(t.TempDir()); err == nil {
		t.Fatal("quería error con carpeta vacía")
	}
}

func TestBoolToBitmask(t *testing.T) {
	m, err := BoolToBitmask([]bool{true, false, true})
	if err != nil || m != 0b101 {
		t.Fatalf("mask = %b, err = %v", m, err)
	}
	if _, err := BoolToBitmask(make([]bool, CoursesPerCore+1)); err == nil {
		t.Fatal("quería error con más de 60 cursos")
	}
	if _, err := BoolToBitmask(make([]bool, CoursesPerCore)); err != nil {
		t.Fatalf("60 cursos deberían ser válidos: %v", err)
	}
}

func TestJaccard(t *testing.T) {
	got, err := Jaccard([]uint64{0b0111, 0}, []uint64{0b0011, 0b1})
	if err != nil || got != 2.0/4.0 {
		t.Fatalf("jaccard = %v, err = %v, quiero 0.5", got, err)
	}
	if got, _ := Jaccard([]uint64{0}, []uint64{0}); got != 0 {
		t.Fatalf("vacío debe dar 0, dio %v", got)
	}
	if _, err := Jaccard([]uint64{0}, []uint64{0, 0}); err == nil {
		t.Fatal("quería error por tamaños distintos")
	}
}
