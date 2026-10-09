// Package concurrent reparte el trabajo entre goroutines. El algoritmo en sí
// es shared.Recommend; aquí solo cambia cómo se reparte y se recolecta.
//
// El Dataset es de solo lectura durante la recomendación, así que no hace falta
// ningún mutex: la única sincronización son los canales y el WaitGroup.
package concurrent

import (
	"sync"

	"recommendation/shared"
)

// Run usa el patrón productor / workers / recolector del pseudocódigo.
// Devuelve los resultados ordenados por estudiante (el recolector los recibe
// en orden no determinista).
func Run(d *shared.Dataset, workers int) []shared.Result {
	if workers < 1 {
		workers = 1
	}
	pending := make(chan shared.ID)
	resultsCh := make(chan shared.Result)

	// productor: close(pending) avisa el fin, no hace falta centinela
	go func() {
		for s := 0; s < d.NumStudents(); s++ {
			pending <- shared.ID(s)
		}
		close(pending)
	}()

	var wg sync.WaitGroup
	wg.Add(workers)
	for w := 0; w < workers; w++ {
		go func() {
			defer wg.Done()
			for s := range pending {
				resultsCh <- shared.Result{Student: s, Recs: d.Recommend(s)}
			}
		}()
	}

	// se cierra el canal cuando terminan todos los workers; así el recolector
	// puede leer mientras tanto y no hay deadlock
	go func() {
		wg.Wait()
		close(resultsCh)
	}()

	results := make([]shared.Result, 0, d.NumStudents())
	for r := range resultsCh {
		results = append(results, r)
	}
	shared.SortResults(results)
	return results
}

// RunPrealloc es la variante sin canal de resultados: cada worker escribe en
// su posición de un slice pre-asignado. Las posiciones son distintas, así que
// no hay carrera ni hace falta ordenar después.
func RunPrealloc(d *shared.Dataset, workers int) []shared.Result {
	if workers < 1 {
		workers = 1
	}
	results := make([]shared.Result, d.NumStudents())
	pending := make(chan shared.ID)

	go func() {
		for s := range results {
			pending <- shared.ID(s)
		}
		close(pending)
	}()

	var wg sync.WaitGroup
	wg.Add(workers)
	for w := 0; w < workers; w++ {
		go func() {
			defer wg.Done()
			for s := range pending {
				results[s] = shared.Result{Student: s, Recs: d.Recommend(s)}
			}
		}()
	}
	wg.Wait()
	return results
}
