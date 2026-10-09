package main

import (
	"flag"
	"fmt"
	"os"
	"runtime"
	"time"

	"recommendation/concurrent"
	"recommendation/sequential"
	"recommendation/shared"
)

func main() {
	seq := flag.Bool("sequential", false, "corre el modo secuencial")
	conc := flag.Bool("concurrent", false, "corre el modo concurrente")
	workers := flag.Int("workers", runtime.NumCPU(), "número de workers del modo concurrente")
	dataDir := flag.String("data", "../dataset/data", "carpeta de los CSV")
	out := flag.String("out", "", "CSV de salida (opcional)")
	flag.Parse()

	if !*seq && !*conc {
		fmt.Fprintln(os.Stderr, "uso: go run . [-sequential] [-concurrent] [-workers N] [-data ruta] [-out archivo]")
		flag.PrintDefaults()
		os.Exit(2)
	}

	start := time.Now()
	d, err := shared.LoadDataset(*dataDir)
	if err != nil {
		fail(err)
	}
	fmt.Printf("datos cargados: %d estudiantes, %d cursos (%v)\n", d.NumStudents(), d.NumCourses(), time.Since(start))

	var seqRes, concRes []shared.Result
	var tSeq, tConc time.Duration
	// el tiempo mide solo la fase de recomendación, sin la carga
	if *seq {
		start = time.Now()
		seqRes = sequential.Run(d)
		tSeq = time.Since(start)
		fmt.Printf("secuencial: %v\n", tSeq)
	}
	if *conc {
		start = time.Now()
		concRes = concurrent.Run(d, *workers)
		tConc = time.Since(start)
		fmt.Printf("concurrente (%d workers): %v\n", *workers, tConc)
	}

	results := seqRes
	if *seq && *conc {
		if !shared.EqualResults(seqRes, concRes) {
			fail(fmt.Errorf("los resultados secuencial y concurrente DIFIEREN"))
		}
		speedup := float64(tSeq) / float64(tConc)
		fmt.Printf("resultados idénticos. speedup: %.2fx, eficiencia: %.2f\n", speedup, speedup/float64(*workers))
	} else if *conc {
		results = concRes
	}

	if *out != "" {
		shared.SortResults(results)
		if err := d.WriteCSVFile(*out, results); err != nil {
			fail(err)
		}
		fmt.Println("escrito:", *out)
	}
}

func fail(err error) {
	fmt.Fprintln(os.Stderr, "error:", err)
	os.Exit(1)
}
