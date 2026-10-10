package shared

import (
	"fmt"
	"sync"
)

// LiveDataset permite marcar cursos como aprobados MIENTRAS otras goroutines
// piden recomendaciones. Está fuera del camino de medición: los modos secuencial
// y concurrente usan el Dataset inmutable, sin ningún lock.
//
// Técnica elegida: un sync.RWMutex por estudiante (bloqueo de grano fino).
//   - Escribir el progreso de un estudiante (MarkApproved) toma su lock de escritura;
//     solo bloquea a ese estudiante, no a los demás.
//   - Leer (Snapshot) toma el lock de lectura, así que muchas lecturas simultáneas
//     no se bloquean entre sí; solo esperan si hay una escritura en curso sobre ese
//     mismo estudiante. Esto sirve para el patrón de "lecturas masivas".
//
// Se descartó un lock global (serializaría todas las lecturas) y atomic con CAS
// (más complejo y sin ventaja medible aquí); el mutex por estudiante es simple
// y fácil de verificar formalmente (ver promela/src/progreso.pml).
type LiveDataset struct {
	base *Dataset
	mu   []sync.RWMutex // mu[s] protege base.Students[s].Cores[*].Completed
}

// NewLiveDataset envuelve un Dataset. A partir de aquí el Dataset original no debe
// usarse directamente: su progreso solo debe leerse y modificarse a través de LiveDataset.
func NewLiveDataset(d *Dataset) *LiveDataset {
	return &LiveDataset{base: d, mu: make([]sync.RWMutex, d.NumStudents())}
}

// MarkApproved marca el curso como aprobado. Devuelve true si el curso era nuevo
// para ese estudiante. Es seguro llamarla desde varias goroutines a la vez.
func (l *LiveDataset) MarkApproved(s ID, course int) (bool, error) {
	if int(s) < 0 || int(s) >= len(l.mu) {
		return false, fmt.Errorf("progreso: estudiante %d fuera de rango", s)
	}
	if course < 0 || course >= l.base.NumCourses() {
		return false, fmt.Errorf("progreso: curso %d fuera de rango", course)
	}

	l.mu[s].Lock()
	defer l.mu[s].Unlock()
	core := &l.base.Students[s].Cores[l.base.CourseCore[course]]
	bit := uint64(1) << l.base.CourseBit[course]
	isNew := core.Completed&bit == 0
	core.Completed |= bit
	return isNew, nil
}

// Snapshot copia el estado actual en un Dataset inmutable (comparte con el original
// las partes que nunca cambian). La copia de cada estudiante es consistente; entre
// estudiantes distintos no es una foto atómica, lo cual es suficiente para recomendar.
func (l *LiveDataset) Snapshot() *Dataset {
	snap := *l.base // copia superficial: nombres, núcleos, bits y prerrequisitos son de solo lectura
	snap.Students = make([]Student, len(l.base.Students))
	for i := range l.base.Students {
		l.mu[i].RLock()
		snap.Students[i] = l.base.Students[i]
		l.mu[i].RUnlock()
	}
	return &snap
}

// Recommend recomienda sobre una foto del estado actual, usando exactamente el
// mismo algoritmo que los demás modos (Dataset.Recommend).
func (l *LiveDataset) Recommend(s ID) []Recommendation {
	return l.Snapshot().Recommend(s)
}
