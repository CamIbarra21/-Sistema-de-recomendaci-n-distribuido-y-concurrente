package main

import (
	"flag"
	"fmt"
	"os"
	"time"

	"recommendation/shared"
)

func main() {
	dataDir := flag.String("data", "../dataset/data", "carpeta de los CSV")
	flag.Parse()

	start := time.Now()
	d, err := shared.LoadDataset(*dataDir)
	if err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
	fmt.Printf("estudiantes:   %d\ncursos:        %d\naristas:       %d\ninteracciones: %d\naprobados:     %d\ncarga:         %v\n",
		d.NumStudents(), d.NumCourses(), d.NumEdges, d.NumInteractions, d.TotalApproved(), time.Since(start))
}
