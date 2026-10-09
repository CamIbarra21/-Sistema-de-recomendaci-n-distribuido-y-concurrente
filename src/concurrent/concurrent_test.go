package concurrent

import (
	"bytes"
	"os"
	"runtime"
	"testing"

	"recommendation/sequential"
	"recommendation/shared"
)

const dataDir = "../../dataset/data"

func loadReal(t *testing.T) *shared.Dataset {
	t.Helper()
	if _, err := os.Stat(dataDir); err != nil {
		t.Skip("dataset real no disponible")
	}
	d, err := shared.LoadDataset(dataDir)
	if err != nil {
		t.Fatal(err)
	}
	if raceEnabled {
		d.Students = d.Students[:1500]
	}
	return d
}

func csvBytes(t *testing.T, d *shared.Dataset, rs []shared.Result) []byte {
	t.Helper()
	var buf bytes.Buffer
	if err := d.WriteCSV(&buf, rs); err != nil {
		t.Fatal(err)
	}
	return buf.Bytes()
}

// La salida secuencial y la concurrente deben ser idénticas byte a byte
// para cualquier número de workers.
func TestEquivalenceWithSequential(t *testing.T) {
	d := loadReal(t)
	want := sequential.Run(d)
	wantCSV := csvBytes(t, d, want)

	for _, w := range []int{1, 2, 4, runtime.NumCPU(), 64} {
		for name, run := range map[string]func(*shared.Dataset, int) []shared.Result{
			"canal": Run, "prealloc": RunPrealloc,
		} {
			got := run(d, w)
			if !shared.EqualResults(want, got) {
				t.Errorf("%s, %d workers: resultados distintos", name, w)
			}
			if !bytes.Equal(wantCSV, csvBytes(t, d, got)) {
				t.Errorf("%s, %d workers: CSV distinto", name, w)
			}
		}
	}
}

func TestEdgeCases(t *testing.T) {
	d := loadReal(t)
	d.Students = d.Students[:3] // más workers que estudiantes
	want := sequential.Run(d)
	if !shared.EqualResults(want, Run(d, 16)) {
		t.Error("más workers que estudiantes: resultados distintos")
	}
	if !shared.EqualResults(want, Run(d, 0)) {
		t.Error("workers=0 debe comportarse como 1")
	}
	d.Students = nil
	if got := Run(d, 4); len(got) != 0 {
		t.Errorf("sin estudiantes debe devolver vacío, devolvió %d", len(got))
	}
	if got := RunPrealloc(d, 4); len(got) != 0 {
		t.Errorf("prealloc sin estudiantes debe devolver vacío, devolvió %d", len(got))
	}
}

func BenchmarkRun(b *testing.B) {
	if _, err := os.Stat(dataDir); err != nil {
		b.Skip("dataset real no disponible")
	}
	d, err := shared.LoadDataset(dataDir)
	if err != nil {
		b.Fatal(err)
	}
	b.Run("canal", func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			Run(d, runtime.NumCPU())
		}
	})
	b.Run("prealloc", func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			RunPrealloc(d, runtime.NumCPU())
		}
	})
}
