//go:build race

package concurrent

// Con el detector de carreras todo corre ~10x más lento: se usa un subconjunto.
const raceEnabled = true
