package shared

import (
	"bytes"
	"fmt"
	"math"
	"math/rand"
	"os"
	"reflect"
	"sort"
	"testing"
)

// toyDataset arma a mano un Dataset de n estudiantes con los 180 cursos
// (curso i -> núcleo i/60, bit i%60) y sin prerrequisitos.
func toyDataset(n int) *Dataset {
	d := &Dataset{}
	for c := 0; c < NumCores*CoursesPerCore; c++ {
		d.CourseNames = append(d.CourseNames, fmt.Sprintf("C_%03d", c))
		d.CourseCore = append(d.CourseCore, c/CoursesPerCore)
		d.CourseBit = append(d.CourseBit, uint(c%CoursesPerCore))
		d.Prereqs = append(d.Prereqs, [MaxPrereqs]int{NoPrereq, NoPrereq})
	}
	for i := 0; i < n; i++ {
		d.Students = append(d.Students, Student{ID: ID(i)})
		d.StudentNames = append(d.StudentNames, fmt.Sprintf("S_%03d", i))
	}
	return d
}

func (d *Dataset) approve(s ID, courses ...int) {
	for _, c := range courses {
		d.Students[s].Cores[d.CourseCore[c]].Completed |= 1 << d.CourseBit[c]
	}
}

func TestJaccardStudentsMatchesJaccard(t *testing.T) {
	d := toyDataset(2)
	d.approve(0, 0, 1, 70, 130)
	d.approve(1, 1, 2, 70, 179)
	a, b := &d.Students[0], &d.Students[1]
	want, _ := Jaccard(
		[]uint64{a.Cores[0].Completed, a.Cores[1].Completed, a.Cores[2].Completed},
		[]uint64{b.Cores[0].Completed, b.Cores[1].Completed, b.Cores[2].Completed})
	if got := JaccardStudents(a, b); got != want || got != 2.0/6.0 {
		t.Fatalf("JaccardStudents = %v, Jaccard = %v, quiero 1/3", got, want)
	}
}

func TestTopNeighborsTiesAndOrder(t *testing.T) {
	d := toyDataset(6)
	d.approve(0, 0, 1) // objetivo
	d.approve(1, 0)    // 0.5
	d.approve(2, 0, 1) // 1.0
	d.approve(3, 0)    // 0.5 (empata con 1, pero índice mayor)
	d.approve(4, 100)  // 0
	// estudiante 5 sin cursos: 0

	got := d.TopNeighbors(0, 3)
	want := []Neighbor{{2, 1}, {1, 0.5}, {3, 0.5}}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("vecinos = %v, quiero %v", got, want)
	}
}

func TestTopNeighborsAllZeroPicksLowestIndexes(t *testing.T) {
	d := toyDataset(10) // nadie aprobó nada: Jaccard 0 con todos
	got := d.TopNeighbors(0, 3)
	want := []Neighbor{{1, 0}, {2, 0}, {3, 0}}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("vecinos = %v, quiero %v", got, want)
	}
	// el objetivo nunca es su propio vecino
	if got := d.TopNeighbors(2, 3); got[0].ID != 0 || got[1].ID != 1 || got[2].ID != 3 {
		t.Fatalf("vecinos de 2 = %v", got)
	}
}

func TestTopNeighborsKLargerThanPopulation(t *testing.T) {
	d := toyDataset(3)
	if got := d.TopNeighbors(0, NumNeighbors); len(got) != 2 {
		t.Fatalf("con 3 estudiantes y K=5 quiero 2 vecinos, hubo %d", len(got))
	}
	if got := toyDataset(1).TopNeighbors(0, NumNeighbors); len(got) != 0 {
		t.Fatalf("un solo estudiante no tiene vecinos, hubo %d", len(got))
	}
}

// randomDataset llena estudiantes con cursos aprobados aleatorios (semilla fija)
// y prerrequisitos aleatorios que respetan un DAG (prerrequisito < curso).
func randomDataset(seed int64, students int) *Dataset {
	rng := rand.New(rand.NewSource(seed))
	d := toyDataset(students)
	for c := 1; c < len(d.Prereqs); c++ {
		for j := 0; j < MaxPrereqs; j++ {
			if rng.Intn(3) == 0 && c%CoursesPerCore != 0 {
				d.Prereqs[c][j] = c - 1 - rng.Intn(c%CoursesPerCore)
			}
		}
		if d.Prereqs[c][0] == d.Prereqs[c][1] {
			d.Prereqs[c][1] = NoPrereq
		}
	}
	for s := range d.Students {
		for core := 0; core < NumCores; core++ {
			st := &d.Students[s]
			st.Cores[core].Affinity = float64(rng.Intn(4)) / 4 // pocos valores -> muchos empates
			st.Cores[core].Skill = float64(rng.Intn(4)) / 4
		}
		for k := rng.Intn(40); k > 0; k-- {
			d.approve(ID(s), rng.Intn(len(d.CourseNames)))
		}
	}
	return d
}

// referenceRecommend sigue el pseudocódigo al pie de la letra: ordena TODAS
// las similitudes y TODOS los candidatos (orden estable, desempate por índice).
func referenceRecommend(d *Dataset, s ID) []Recommendation {
	var sims []Neighbor
	for i := range d.Students {
		if ID(i) != s {
			sims = append(sims, Neighbor{ID(i), JaccardStudents(&d.Students[s], &d.Students[i])})
		}
	}
	sort.SliceStable(sims, func(i, j int) bool { return sims[i].Similarity > sims[j].Similarity })
	if len(sims) > NumNeighbors {
		sims = sims[:NumNeighbors]
	}

	var scored []Recommendation
	for _, c := range d.Candidates(s) {
		scored = append(scored, Recommendation{c, d.Score(s, c, sims)})
	}
	sort.SliceStable(scored, func(i, j int) bool { return scored[i].Score > scored[j].Score })
	if len(scored) > NumRecommendations {
		scored = scored[:NumRecommendations]
	}
	return scored
}

func TestRecommendMatchesFullSortReference(t *testing.T) {
	for seed := int64(1); seed <= 5; seed++ {
		d := randomDataset(seed, 120)
		for s := range d.Students {
			got, want := d.Recommend(ID(s)), referenceRecommend(d, ID(s))
			if len(got) == 0 && len(want) == 0 {
				continue
			}
			if !reflect.DeepEqual(got, want) {
				t.Fatalf("seed %d estudiante %d: top-k %v != orden completo %v", seed, s, got, want)
			}
		}
	}
}

func TestMeetsPrereqs(t *testing.T) {
	d := toyDataset(1)
	d.Prereqs[2] = [MaxPrereqs]int{0, 1}
	d.Prereqs[60] = [MaxPrereqs]int{0, NoPrereq} // prerrequisito de otro núcleo
	d.Prereqs[3] = [MaxPrereqs]int{NoPrereq, 2}  // la posición 0 vacía no cuenta

	if !d.MeetsPrereqs(0, 0) {
		t.Error("un curso sin prerrequisitos siempre se cumple")
	}
	if d.MeetsPrereqs(0, 2) {
		t.Error("faltan ambos prerrequisitos")
	}
	d.approve(0, 0)
	if d.MeetsPrereqs(0, 2) {
		t.Error("falta el segundo prerrequisito")
	}
	if !d.MeetsPrereqs(0, 60) {
		t.Error("el prerrequisito cruzado ya está aprobado")
	}
	d.approve(0, 1)
	if !d.MeetsPrereqs(0, 2) {
		t.Error("ambos prerrequisitos aprobados")
	}
	if d.MeetsPrereqs(0, 3) {
		t.Error("falta el curso 2")
	}
}

func TestCandidates(t *testing.T) {
	d := toyDataset(1)
	d.Prereqs[1] = [MaxPrereqs]int{0, NoPrereq}
	d.approve(0, 5)
	got := d.Candidates(0)
	if len(got) != 180-1-1 { // sin el aprobado (5) y sin el curso 1 (falta el 0)
		t.Fatalf("candidatos = %d, quiero 178", len(got))
	}
	for _, c := range got {
		if c == 5 || c == 1 {
			t.Fatalf("el curso %d no debería ser candidato", c)
		}
	}
	d.approve(0, 0)
	if got := d.Candidates(0); got[0] != 1 {
		t.Fatalf("con el 0 aprobado el 1 debe ser candidato; primer candidato = %d", got[0])
	}
}

func TestScore(t *testing.T) {
	d := toyDataset(4)
	d.Students[0].Cores[CoreReading] = Core{Affinity: 0.4, Skill: 0.8}
	course := 70 // Lectura
	d.approve(1, course)
	d.approve(2, course)
	neighbors := []Neighbor{{1, 1}, {2, 1}, {3, 0}}

	// 0.25*0.4 + 0.25*0.8 + 0.5*(2/5) = 0.1 + 0.2 + 0.2
	if got := d.Score(0, course, neighbors); math.Abs(got-0.5) > 1e-12 {
		t.Fatalf("puntaje = %v, quiero 0.5", got)
	}
	// sin vecinos que aprobaron solo cuentan afinidad y habilidad
	if got := d.Score(0, 71, neighbors); math.Abs(got-0.3) > 1e-12 {
		t.Fatalf("puntaje sin vecinos = %v, quiero 0.3", got)
	}
}

func TestRecommendEdgeCases(t *testing.T) {
	// estudiante sin cursos aprobados y sin vecinos con cursos: se recomienda
	// por afinidad/habilidad; con todo empatado gana el menor índice de curso
	d := toyDataset(3)
	got := d.Recommend(0)
	if len(got) != 3 || got[0].Course != 0 || got[1].Course != 1 || got[2].Course != 2 {
		t.Fatalf("recomendaciones = %v, quiero cursos 0,1,2", got)
	}

	// menos de 3 candidatos: se devuelven los que haya
	d = toyDataset(2)
	for c := 2; c < 180; c++ {
		d.approve(0, c)
	}
	got = d.Recommend(0)
	if len(got) != 2 || got[0].Course != 0 || got[1].Course != 1 {
		t.Fatalf("recomendaciones = %v, quiero solo los cursos 0 y 1", got)
	}

	// sin candidatos
	d.approve(0, 0, 1)
	if got := d.Recommend(0); len(got) != 0 {
		t.Fatalf("sin candidatos debe devolver vacío, devolvió %v", got)
	}

	// una sola persona (K >= N-1): no hay vecinos pero igual recomienda
	if got := toyDataset(1).Recommend(0); len(got) != 3 {
		t.Fatalf("con 1 estudiante debe recomendar igual, devolvió %v", got)
	}
}

func TestRecommendOrdersByScoreThenIndex(t *testing.T) {
	d := toyDataset(3)
	d.approve(0, 0) // objetivo, núcleo Matemática
	d.approve(1, 0, 50)
	d.approve(2, 0, 50, 51) // vecinos: 50 lo aprobaron ambos, 51 uno solo
	got := d.Recommend(0)
	want := []int{50, 51, 1}
	for i, c := range want {
		if got[i].Course != c {
			t.Fatalf("recomendaciones = %v, quiero cursos %v", got, want)
		}
	}
}

func TestWriteCSVAndSort(t *testing.T) {
	d := toyDataset(3)
	rs := []Result{
		{2, []Recommendation{{5, 0.5}}},
		{0, []Recommendation{{1, 0.75}, {2, 0.25}, {3, 0.125}}},
		{1, nil},
	}
	SortResults(rs)
	if rs[0].Student != 0 || rs[2].Student != 2 {
		t.Fatalf("no ordenó: %v", rs)
	}

	var buf bytes.Buffer
	if err := d.WriteCSV(&buf, rs); err != nil {
		t.Fatal(err)
	}
	want := "student_id,rec1,rec2,rec3,score1,score2,score3\n" +
		"S_000,C_001,C_002,C_003,0.750000,0.250000,0.125000\n" +
		"S_001,,,,,,\n" +
		"S_002,C_005,,,0.500000,,\n"
	if buf.String() != want {
		t.Fatalf("CSV:\n%s\nquiero:\n%s", buf.String(), want)
	}
	if !EqualResults(rs, rs) || EqualResults(rs, rs[:2]) {
		t.Error("EqualResults incorrecto")
	}
}

// Prueba de humo sobre el dataset real: invariantes, no valores exactos.
func TestRealDatasetSmoke(t *testing.T) {
	const dir = "../../dataset/data"
	if _, err := os.Stat(dir); err != nil {
		t.Skip("dataset real no disponible")
	}
	d, err := LoadDataset(dir)
	if err != nil {
		t.Fatal(err)
	}
	for s := 0; s < 100; s++ {
		recs := d.Recommend(ID(s))
		if len(recs) != NumRecommendations {
			t.Fatalf("estudiante %d: %d recomendaciones", s, len(recs))
		}
		for i, r := range recs {
			if d.Approved(ID(s), r.Course) || !d.MeetsPrereqs(ID(s), r.Course) {
				t.Fatalf("estudiante %d: curso %s inválido", s, d.CourseNames[r.Course])
			}
			if i > 0 && recs[i-1].Score < r.Score {
				t.Fatalf("estudiante %d: no está ordenado", s)
			}
		}
	}
}
