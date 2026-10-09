package shared

import "math/bits"

// Dataset es la estructura en memoria que usa el algoritmo. Tras LoadDataset
// nadie la modifica, así que se puede leer desde varias goroutines sin locks.
// Todo se indexa con índices densos (orden de aparición en los CSV).
type Dataset struct {
	Students     []Student // índice = ID denso del estudiante
	StudentNames []string  // ID denso -> "STU_000000"
	CourseNames  []string  // ID denso -> "MAT_0000"

	CourseCore []int             // núcleo (0..2) de cada curso
	CourseBit  []uint            // posición del curso dentro de su núcleo (0..59)
	Prereqs    [][MaxPrereqs]int // prerrequisitos (índice de curso) o NoPrereq

	NumEdges        int // aristas de prerrequisito
	NumInteractions int // filas leídas de interacciones.csv
}

func (d *Dataset) NumStudents() int { return len(d.Students) }
func (d *Dataset) NumCourses() int  { return len(d.CourseNames) }

// Approved indica si el estudiante aprobó el curso.
func (d *Dataset) Approved(s ID, course int) bool {
	return d.Students[s].Cores[d.CourseCore[course]].Completed>>d.CourseBit[course]&1 == 1
}

// TotalApproved cuenta los pares (estudiante, curso) aprobados.
func (d *Dataset) TotalApproved() int {
	total := 0
	for i := range d.Students {
		for c := range d.Students[i].Cores {
			total += bits.OnesCount64(d.Students[i].Cores[c].Completed)
		}
	}
	return total
}
