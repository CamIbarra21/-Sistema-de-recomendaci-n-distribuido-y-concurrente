package main

import (
	"flag"
	"fmt"
	"os"
	"runtime"
	"time"

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
	if *conc {
		fail(fmt.Errorf("el modo concurrente (%d workers) aún no está implementado", *workers))
	}

	start := time.Now()
	d, err := shared.LoadDataset(*dataDir)
	if err != nil {
		fail(err)
	}
	fmt.Printf("datos cargados: %d estudiantes, %d cursos (%v)\n", d.NumStudents(), d.NumCourses(), time.Since(start))

	// el tiempo mide solo la fase de recomendación, sin la carga
	start = time.Now()
	results := sequential.Run(d)
	fmt.Printf("secuencial: %v\n", time.Since(start))

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
