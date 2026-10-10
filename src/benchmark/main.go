// Comando que mide speedup, eficiencia y uso de recursos del modo concurrente
// frente al secuencial y escribe benchmarks/resultados_speedup.md (y los gráficos).
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

// sample es una medición de una corrida.
type sample struct {
	wall   float64 // segundos
	cpu    float64 // segundos de CPU del proceso (usuario + kernel)
	alloc  float64 // MiB asignados durante la corrida
	gcs    float64 // ciclos de GC durante la corrida
	sysMiB float64 // memoria total obtenida del SO al terminar
}

type series struct {
	name    string
	workers int
	times   []float64 // segundos (tiempo real)
	cpus    []float64
	allocs  []float64
	gcs     []float64
	sys     []float64
}

func (s *series) add(m sample) {
	s.times = append(s.times, m.wall)
	s.cpus = append(s.cpus, m.cpu)
	s.allocs = append(s.allocs, m.alloc)
	s.gcs = append(s.gcs, m.gcs)
	s.sys = append(s.sys, m.sysMiB)
}

type stats struct{ median, mean, trimmed, std, min, max float64 }

// compute calcula las estadísticas de una serie. La media recortada descarta el 10% de
// las mediciones en cada extremo (al menos 1 por lado si hay 5 o más); con menos de 5
// no se recorta y coincide con la media.
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

	trim := 0
	if n >= 5 {
		trim = max(1, n/10)
	}
	for _, x := range s[trim : n-trim] {
		st.trimmed += x
	}
	st.trimmed /= float64(n - 2*trim)
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

const mib = 1 << 20

func measure(f runner) (sample, []shared.Result) {
	runtime.GC() // que el GC de la corrida anterior no cuente en esta
	var m0, m1 runtime.MemStats
	runtime.ReadMemStats(&m0)
	cpu0 := cpuTime()
	start := time.Now()
	res := f()
	wall := time.Since(start)
	cpu := cpuTime() - cpu0
	runtime.ReadMemStats(&m1)
	return sample{
		wall:   wall.Seconds(),
		cpu:    cpu.Seconds(),
		alloc:  float64(m1.TotalAlloc-m0.TotalAlloc) / mib,
		gcs:    float64(m1.NumGC - m0.NumGC),
		sysMiB: float64(m1.Sys) / mib,
	}, res
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
	_, want := measure(runs[seq])
	for _, s := range all[1:] {
		if _, got := measure(runs[s]); !shared.EqualResults(want, got) {
			fmt.Fprintf(os.Stderr, "error: %s con %d workers difiere del secuencial\n", s.name, s.workers)
			os.Exit(1)
		}
	}

	// las repeticiones se intercalan entre configuraciones para repartir
	// por igual cualquier deriva térmica o de carga del sistema
	for r := 1; r <= *reps; r++ {
		fmt.Printf("repetición %d/%d\n", r, *reps)
		for _, s := range all {
			m, _ := measure(runs[s])
			s.add(m)
		}
	}

	if err := report(*outPath, *hardware, *reps, d, seq, all[1:]); err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
	if err := writeCharts(filepath.Dir(*outPath), *reps, seq, all[1:]); err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
	fmt.Println("escrito:", *outPath)
}

func report(path, hardware string, reps int, d *shared.Dataset, seq *series, conc []*series) error {
	var b strings.Builder
	base := compute(seq.times)

	fmt.Fprintf(&b, "# Resultados de speedup\n\n")
	fmt.Fprintf(&b, "Generado con `go run ./benchmark` el %s.\n\n", time.Now().Format("2006-01-02 15:04"))
	fmt.Fprintf(&b, "## Entorno\n\n- Hardware: %s\n- Go: %s (%s/%s), `runtime.NumCPU()` = %d\n", hardware, runtime.Version(), runtime.GOOS, runtime.GOARCH, runtime.NumCPU())
	fmt.Fprintf(&b, "- Datos: %d estudiantes, %d cursos, K=%d vecinos, %d recomendaciones\n", d.NumStudents(), d.NumCourses(), shared.NumNeighbors, shared.NumRecommendations)
	fmt.Fprintf(&b, "- Método: 1 corrida de calentamiento + %d repeticiones por configuración, intercaladas. El tiempo mide solo la fase de recomendación (sin la carga de CSV); incluye ordenar los resultados. Antes de medir se verificó que todas las configuraciones dan resultados idénticos al secuencial.\n", reps)
	fmt.Fprintf(&b, "- **Media recortada:** se descarta el 10%% de las mediciones en cada extremo (la más rápida y la más lenta de %d) y se promedia el resto.\n", reps)
	fmt.Fprintf(&b, "- **speedup = T_sec / T_conc** y **eficiencia = speedup / workers**, ambos con la **media recortada**. `f` es la fracción serial estimada con la métrica de Karp-Flatt: f = (1/S − 1/p) / (1 − 1/p).\n\n")

	b.WriteString("## Gráficos\n\n![Tiempos](tiempos.svg)\n\n![Speedup](speedup.svg)\n\n![Eficiencia](eficiencia.svg)\n\n")
	fmt.Fprintf(&b, "## Secuencial\n\n| media recortada (s) | mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) |\n|---|---|---|---|---|---|\n")
	fmt.Fprintf(&b, "| %.3f | %.3f | %.3f | %.3f | %.3f | %.3f |\n\n", base.trimmed, base.median, base.mean, base.std, base.min, base.max)

	for _, variant := range []struct{ name, title string }{
		{"canal", "Concurrente: productor / workers / recolector (canal de resultados)"},
		{"prealloc", "Concurrente: variante con slice pre-asignado (sin canal de resultados)"},
	} {
		fmt.Fprintf(&b, "## %s\n\n| workers | media recortada (s) | mediana (s) | media (s) | desv. est. (s) | mín (s) | máx (s) | speedup | eficiencia | f |\n|---|---|---|---|---|---|---|---|---|---|\n", variant.title)
		for _, s := range conc {
			if s.name != variant.name {
				continue
			}
			c := compute(s.times)
			sp := base.trimmed / c.trimmed
			f := "—"
			if s.workers > 1 {
				f = fmt.Sprintf("%.3f", (1/sp-1/float64(s.workers))/(1-1/float64(s.workers)))
			}
			fmt.Fprintf(&b, "| %d | %.3f | %.3f | %.3f | %.3f | %.3f | %.3f | %.2fx | %.2f | %s |\n",
				s.workers, c.trimmed, c.median, c.mean, c.std, c.min, c.max, sp, sp/float64(s.workers), f)
		}
		b.WriteString("\n")
	}

	writeResources(&b, base, seq, conc)

	if disc, err := os.ReadFile(filepath.Join(filepath.Dir(path), "discusion.md")); err == nil {
		b.Write(disc)
	}
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		return err
	}
	return os.WriteFile(path, []byte(b.String()), 0o644)
}

// writeResources añade el análisis de uso de recursos: CPU, memoria y punto de equilibrio.
func writeResources(b *strings.Builder, base stats, seq *series, conc []*series) {
	b.WriteString("## Uso de recursos de cómputo\n\n")
	b.WriteString("Medido en cada repetición (media recortada). **Núcleos usados** = tiempo de CPU del proceso / tiempo real: indica cuántos núcleos estuvieron ocupados en promedio. **Asignado** son los MiB reservados por el programa durante la corrida (incluye los resultados) y **memoria del SO** es lo que el proceso le pidió al sistema operativo (`runtime.MemStats.Sys`). **Ganancia marginal** es cuánto sube el speedup por cada worker añadido respecto a la configuración anterior de la misma variante.\n\n")
	b.WriteString("| modo | workers | tiempo (s) | CPU (s) | núcleos usados | asignado (MiB) | ciclos GC | memoria del SO (MiB) | ganancia marginal |\n|---|---|---|---|---|---|---|---|---|\n")

	row := func(name string, s *series, marginal string) {
		t, c := compute(s.times), compute(s.cpus)
		fmt.Fprintf(b, "| %s | %d | %.3f | %.3f | %.2f | %.1f | %.1f | %.0f | %s |\n",
			name, s.workers, t.trimmed, c.trimmed, c.trimmed/t.trimmed,
			compute(s.allocs).trimmed, compute(s.gcs).trimmed, compute(s.sys).trimmed, marginal)
	}
	row("secuencial", seq, "—")

	equilibrium, eqMarginal, eqEff := 0, "—", 0.0
	for _, name := range []string{"canal", "prealloc"} {
		prevW, prevS := 1.0, base.trimmed/base.trimmed
		for _, s := range conc {
			if s.name != name {
				continue
			}
			sp := base.trimmed / compute(s.times).trimmed
			marginal := "—"
			if s.workers > 1 {
				marginal = fmt.Sprintf("%.2f", (sp-prevS)/(float64(s.workers)-prevW))
			}
			if name == "canal" && sp/float64(s.workers) >= 0.5 && s.workers > equilibrium {
				equilibrium, eqMarginal, eqEff = s.workers, marginal, sp/float64(s.workers)
			}
			prevW, prevS = float64(s.workers), sp
			row(name, s, marginal)
		}
	}
	b.WriteString("\n")
	fmt.Fprintf(b, "**Punto de equilibrio.** Se define como la mayor cantidad de workers cuya eficiencia sigue siendo al menos 0.50 (más allá, más de la mitad de la capacidad añadida se pierde). En esta ejecución, con el canal de resultados, es **%d workers** (eficiencia %.2f, ganancia marginal %s por worker añadido). Si la eficiencia está cerca de 0.50 o la ganancia marginal es baja, agregar más workers rinde poco: el límite lo ponen los núcleos físicos.\n\n", equilibrium, eqEff, eqMarginal)
}
