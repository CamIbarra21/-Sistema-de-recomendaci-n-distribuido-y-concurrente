package shared

// Recommendation es un curso recomendado con su puntaje.
type Recommendation struct {
	Course int // índice denso del curso
	Score  float64
}

// MeetsPrereqs indica si el estudiante ya aprobó todos los prerrequisitos del curso.
// Funciona también si un prerrequisito es de otro núcleo.
func (d *Dataset) MeetsPrereqs(s ID, course int) bool {
	for _, p := range d.Prereqs[course] {
		if p != NoPrereq && !d.Approved(s, p) {
			return false
		}
	}
	return true
}

// Candidates devuelve, en orden creciente de índice, los cursos que el
// estudiante no ha aprobado y cuyos prerrequisitos ya cumple.
func (d *Dataset) Candidates(s ID) []int {
	var out []int
	for c := range d.CourseNames {
		if !d.Approved(s, c) && d.MeetsPrereqs(s, c) {
			out = append(out, c)
		}
	}
	return out
}

// Score calcula 0.25*afinidad + 0.25*habilidad + 0.50*(vecinos que aprobaron / K).
// El orden de las operaciones es fijo (afinidad + habilidad + colaborativo) para
// que ambos modos den bits idénticos. El divisor es siempre NumNeighbors, como
// en el pseudocódigo, aunque haya menos vecinos.
func (d *Dataset) Score(s ID, course int, neighbors []Neighbor) float64 {
	core := &d.Students[s].Cores[d.CourseCore[course]]

	approved := 0
	for _, n := range neighbors {
		if d.Approved(n.ID, course) {
			approved++
		}
	}

	affinity := core.Affinity * WeightAffinity
	skill := core.Skill * WeightSkill
	collab := float64(approved) / float64(NumNeighbors) * WeightCollaboration
	return affinity + skill + collab
}

// Recommend devuelve hasta NumRecommendations cursos para el estudiante, de
// mayor a menor puntaje. Desempate: menor índice de curso primero. Usa la
// misma inserción top-k que TopNeighbors, en lugar de ordenar todos los candidatos.
// Es de solo lectura sobre el Dataset, por lo que es seguro llamarla en paralelo.
func (d *Dataset) Recommend(s ID) []Recommendation {
	neighbors := d.TopNeighbors(s, NumNeighbors)
	top := make([]Recommendation, 0, NumRecommendations)

	for _, c := range d.Candidates(s) {
		score := d.Score(s, c, neighbors)
		if len(top) == NumRecommendations && score <= top[NumRecommendations-1].Score {
			continue
		}

		pos := len(top)
		for pos > 0 && top[pos-1].Score < score {
			pos--
		}
		if len(top) < NumRecommendations {
			top = append(top, Recommendation{})
		}
		copy(top[pos+1:], top[pos:len(top)-1])
		top[pos] = Recommendation{Course: c, Score: score}
	}
	return top
}
