package shared

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"sort"
)

// Result es la recomendación de un estudiante.
type Result struct {
	Student ID
	Recs    []Recommendation
}

// SortResults ordena por estudiante. Hay que llamarla antes de comparar o
// escribir: el modo concurrente recibe los resultados en orden no determinista.
func SortResults(rs []Result) {
	sort.Slice(rs, func(i, j int) bool { return rs[i].Student < rs[j].Student })
}

// EqualResults compara dos listas ya ordenadas, incluyendo los puntajes exactos.
func EqualResults(a, b []Result) bool {
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if a[i].Student != b[i].Student || len(a[i].Recs) != len(b[i].Recs) {
			return false
		}
		for j := range a[i].Recs {
			if a[i].Recs[j] != b[i].Recs[j] {
				return false
			}
		}
	}
	return true
}

// WriteCSV escribe student_id,rec1,rec2,rec3,score1,score2,score3 (puntajes con
// 6 decimales). Si hay menos de 3 recomendaciones, las columnas sobrantes quedan vacías.
func (d *Dataset) WriteCSV(w io.Writer, rs []Result) error {
	bw := bufio.NewWriter(w)
	fmt.Fprintln(bw, "student_id,rec1,rec2,rec3,score1,score2,score3")
	for _, r := range rs {
		fmt.Fprint(bw, d.StudentNames[r.Student])
		for i := 0; i < NumRecommendations; i++ {
			if i < len(r.Recs) {
				fmt.Fprintf(bw, ",%s", d.CourseNames[r.Recs[i].Course])
			} else {
				bw.WriteByte(',')
			}
		}
		for i := 0; i < NumRecommendations; i++ {
			if i < len(r.Recs) {
				fmt.Fprintf(bw, ",%.6f", r.Recs[i].Score)
			} else {
				bw.WriteByte(',')
			}
		}
		bw.WriteByte('\n')
	}
	return bw.Flush()
}

// WriteCSVFile guarda los resultados en un archivo.
func (d *Dataset) WriteCSVFile(path string, rs []Result) error {
	f, err := os.Create(path)
	if err != nil {
		return err
	}
	if err := d.WriteCSV(f, rs); err != nil {
		f.Close()
		return err
	}
	return f.Close()
}
