package shared

import (
	"sync"
	"testing"
)

func TestMarkApprovedBasics(t *testing.T) {
	l := NewLiveDataset(toyDataset(2))

	isNew, err := l.MarkApproved(0, 70)
	if err != nil || !isNew {
		t.Fatalf("primera vez: isNew=%v err=%v", isNew, err)
	}
	if isNew, _ := l.MarkApproved(0, 70); isNew {
		t.Error("marcar dos veces el mismo curso no es nuevo la segunda vez")
	}
	if !l.base.Approved(0, 70) || l.base.Approved(1, 70) {
		t.Error("el curso debe quedar aprobado solo para el estudiante 0")
	}

	for _, c := range []struct {
		s ID
		c int
	}{{5, 0}, {-1, 0}, {0, 180}, {0, -1}} {
		if _, err := l.MarkApproved(c.s, c.c); err == nil {
			t.Errorf("MarkApproved(%d, %d) debería dar error", c.s, c.c)
		}
	}
}

func TestSnapshotIsolatedAndRecommendUsesProgress(t *testing.T) {
	l := NewLiveDataset(toyDataset(3))
	before := l.Snapshot()
	l.MarkApproved(0, 0)

	if before.Approved(0, 0) {
		t.Error("una foto previa no debe cambiar con actualizaciones posteriores")
	}
	for _, r := range l.Recommend(0) {
		if r.Course == 0 {
			t.Error("el curso recién aprobado no debe recomendarse")
		}
	}
}

// Muchos escritores sobre los mismos estudiantes y lectores simultáneos.
// Con -race detecta cualquier acceso sin sincronizar; al final no se debe
// haber perdido ninguna actualización.
func TestConcurrentProgressNoLostUpdates(t *testing.T) {
	const students, writers = 4, 8
	l := NewLiveDataset(toyDataset(students))
	courses := []int{3, 20, 59, 61, 100, 130, 179, 5} // varios núcleos, un curso por escritor

	var wg sync.WaitGroup
	for w := 0; w < writers; w++ {
		wg.Add(1)
		go func(course int) {
			defer wg.Done()
			for s := 0; s < students; s++ {
				if _, err := l.MarkApproved(ID(s), course); err != nil {
					t.Error(err)
				}
			}
		}(courses[w])
	}
	for r := 0; r < 4; r++ { // lectores mientras se escribe
		wg.Add(1)
		go func(s ID) {
			defer wg.Done()
			for i := 0; i < 20; i++ {
				l.Recommend(s)
			}
		}(ID(r))
	}
	wg.Wait()

	final := l.Snapshot()
	for s := 0; s < students; s++ {
		for _, c := range courses {
			if !final.Approved(ID(s), c) {
				t.Fatalf("se perdió la actualización del estudiante %d, curso %d", s, c)
			}
		}
	}
	if got := final.TotalApproved(); got != students*writers {
		t.Fatalf("total aprobado = %d, quiero %d", got, students*writers)
	}
}
