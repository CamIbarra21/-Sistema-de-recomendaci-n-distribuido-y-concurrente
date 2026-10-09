package shared

// Neighbor es un estudiante similar al objetivo.
type Neighbor struct {
	ID         ID
	Similarity float64
}

// TopNeighbors devuelve los k estudiantes más similares a target (sin incluirlo),
// ordenados de mayor a menor similitud.
//
// Regla de desempate (única, igual en ambos modos): a igual similitud va primero
// el de menor índice. En lugar de ordenar los N-1 candidatos (O(N log N)) se
// mantiene una lista ordenada de tamaño k con inserción (O(N·k)). Como se recorre
// en orden creciente de índice, un candidato empatado nunca desplaza a uno
// anterior, así que el resultado es idéntico al de ordenar todo con desempate.
func (d *Dataset) TopNeighbors(target ID, k int) []Neighbor {
	top := make([]Neighbor, 0, k)
	if k <= 0 {
		return top
	}
	me := &d.Students[target]

	for i := range d.Students {
		if ID(i) == target {
			continue
		}
		sim := JaccardStudents(me, &d.Students[i])
		if len(top) == k && sim <= top[k-1].Similarity {
			continue
		}

		// posición: después de todos los que tienen similitud >= sim
		pos := len(top)
		for pos > 0 && top[pos-1].Similarity < sim {
			pos--
		}
		if len(top) < k {
			top = append(top, Neighbor{})
		}
		copy(top[pos+1:], top[pos:len(top)-1])
		top[pos] = Neighbor{ID: ID(i), Similarity: sim}
	}
	return top
}
