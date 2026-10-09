// Comando que mide speedup y eficiencia del modo concurrente frente al secuencial
// y escribe benchmarks/resultados_speedup.md.
//
//	go run ./benchmark -hardware "CPU / RAM / SO"
package main

import (
	"flag"
	"fmt"
	"math"
	"os"
	"path/filepath"
	"runtime"
	"sort"
	"strings"
	"time"

	"recommendation/concurrent"
	"recommendation/sequential"
	"recommendation/shared"
)

type runner func() []shared.Result

type series struct {
	name    string
	workers int
	times   []float64 // segundos
}

type stats struct{ median, mean, std, min, max float64 }

func compute(xs []float64) stats {
	s := append([]float64(nil), xs...)
	sort.Float64s(s)
	n := len(s)
	st := stats{min: s[0], max: s[n-1]}
	if n%2 == 1 {
		st.median = s[n/2]
	} else {
		st.median = (s[n/2-1] + s[n/2]) / 2
	}
	for _, x := range s {
		st.mean += x
	}
	st.mean /= float64(n)
	for _, x := range s {
		st.std += (x - st.mean) * (x - st.mean)
	}
	if n > 1 {
		st.std = math.Sqrt(st.std / float64(n-1))
	}
	return st
}

// workerCounts devuelve 1, 2, 4, 8... y NumCPU.
func workerCounts() []int {
	var ws []int
	for w := 1; w < runtime.NumCPU(); w *= 2 {
		ws = append(ws, w)
	}
	return append(ws, runtime.NumCPU())
}

func timeIt(f runner) (time.Duration, []shared.Result) {
	runtime.GC() // que el GC de la corrida anterior no cuente en esta
	start := time.Now()
	res := f()
	return time.Since(start), res
}

func main() {
	dataDir := flag.String("data", "../dataset/data", "carpeta de los CSV")
	reps := flag.Int("reps", 10, "repeticiones medidas (además de 1 de calentamiento)")
	outPath := flag.String("out", "../benchmarks/resultados_speedup.md", "archivo de salida")
	hardware := flag.String("hardware", "(sin especificar)", "descripción del hardware")
	flag.Parse()

	d, err := shared.LoadDataset(*dataDir)
	if err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}

	seq := &series{name: "secuencial", workers: 1}
	runs := map[*series]runner{seq: func() []shared.Result { return sequential.Run(d) }}
	all := []*series{seq}
	for _, variant := range []struct {
		name string
		run  func(*shared.Dataset, int) []shared.Result
	}{{"canal", concurrent.Run}, {"prealloc", concurrent.RunPrealloc}} {
		for _, w := range workerCounts() {
			s := &series{name: variant.name, workers: w}
			run, w := variant.run, w
			runs[s] = func() []shared.Result { return run(d, w) }
			all = append(all, s)
		}
	}

	// calentamiento (1 corrida de cada una) y verificación de resultados idénticos
	_, want := timeIt(runs[seq])
	for _, s := range all[1:] {
		if _, got := timeIt(runs[s]); !shared.EqualResults(want, got) {
			fmt.Fprintf(os.Stderr, "error: %s con %d workers difiere del secuencial\n", s.name, s.workers)
			os.Exit(1)
		}
	}

	// las repeticiones se intercalan entre configuraciones para repartir
	// por igual cualquier deriva térmica o de carga del sistema
	for r := 1; r <= *reps; r++ {
		fmt.Printf("repetición %d/%d\n", r, *reps)
		for _, s := range all {
			t, _ := timeIt(runs[s])
			s.times = append(s.times, t.Seconds())
		}
	}

	report(*outPath, *hardware, *reps, d, seq, all[1:])
	fmt.Println("escrito:", *outPath)
}

func report(path, hardware string, reps int, d *shared.Dataset, seq *series, conc []*series) {
	var b strings.Builder
	st := compute(seq.times)

	fmt.Fprintf(&b, "# Resultados de speedup\n\n")
	fmt.Fprintf(&b, "Generado con `go run ./benchmark` el %s.\n\n", time.Now().Format("2006-01-02 15:04"))
	fmt.Fprintf(&b, "## Entorno\n\n- Hardware: %s\n- Go: %s (%s/%s), `runtime.NumCPU()` = %d\n", hardware, runtime.Version(), runtime.GOOS, runtime.GOARCH, runtime.NumCPU())
	fmt.Fprintf(&b, "- Datos: %d estudiantes, %d cursos, K=%d vecinos, %d recomendaciones\n", d.NumStudents(), d.NumCourses(), shared.NumNeighbors, shared.NumRecommendations)
	fmt.Fprintf(&b, "- Método: 1 corrida de calentamiento + %d repeticiones por configuración, intercaladas. El tiempo mide solo la fase de recomendación (sin la carga de CSV); incluye ordenar los resultados. Antes de medir se verificó que todas las configuraciones dan resultados idénticos al secuencial.\n", reps)
	fmt.Fprintf(&b, "- **speedup = T_sec / T_conc** y **eficiencia = speedup / workers**, ambos con la **mediana**. `f` es la fracción serial estimada con la métrica de Karp-Flatt: f = (1/S − 1/p) / (1 − 1/p).\n\n")

	fmt.Fprintf(&b, "## Secuencial\n\n| mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) |\n|---|---|---|---|---|\n")
	fmt.Fprintf(&b, "| %.3f | %.3f | %.3f | %.3f | %.3f |\n\n", st.median, st.mean, st.std, st.min, st.max)

	for _, variant := range []struct{ name, title string }{
		{"canal", "Concurrente: productor / workers / recolector (canal de resultados)"},
		{"prealloc", "Concurrente: variante con slice pre-asignado (sin canal de resultados)"},
	} {
		fmt.Fprintf(&b, "## %s\n\n| workers | mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) | speedup | eficiencia | f |\n|---|---|---|---|---|---|---|---|---|\n", variant.title)
		for _, s := range conc {
			if s.name != variant.name {
				continue
			}
			c := compute(s.times)
			sp := st.median / c.median
			f := "—"
			if s.workers > 1 {
				f = fmt.Sprintf("%.3f", (1/sp-1/float64(s.workers))/(1-1/float64(s.workers)))
			}
			fmt.Fprintf(&b, "| %d | %.3f | %.3f | %.3f | %.3f | %.3f | %.2fx | %.2f | %s |\n",
				s.workers, c.median, c.mean, c.std, c.min, c.max, sp, sp/float64(s.workers), f)
		}
		b.WriteString("\n")
	}

	if disc, err := os.ReadFile(filepath.Join(filepath.Dir(path), "discusion.md")); err == nil {
		b.Write(disc)
	}
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
	if err := os.WriteFile(path, []byte(b.String()), 0o644); err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
}
