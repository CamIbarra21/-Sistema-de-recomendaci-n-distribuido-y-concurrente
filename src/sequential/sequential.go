// Package sequential es el modo lineal de referencia: un estudiante tras otro.
package sequential

import "recommendation/shared"

// Run recomienda para todos los estudiantes en orden. La lista ya sale ordenada por estudiante.
func Run(d *shared.Dataset) []shared.Result {
	results := make([]shared.Result, d.NumStudents())
	for s := range results {
		results[s] = shared.Result{Student: shared.ID(s), Recs: d.Recommend(shared.ID(s))}
	}
	return results
}
