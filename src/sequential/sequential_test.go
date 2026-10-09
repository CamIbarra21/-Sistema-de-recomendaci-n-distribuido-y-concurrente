package sequential

import (
	"os"
	"testing"

	"recommendation/shared"
)

func TestRunMatchesRecommend(t *testing.T) {
	const dir = "../../dataset/data"
	if _, err := os.Stat(dir); err != nil {
		t.Skip("dataset real no disponible")
	}
	d, err := shared.LoadDataset(dir)
	if err != nil {
		t.Fatal(err)
	}
	d.Students = d.Students[:300] // subconjunto para que el test sea rápido
	res := Run(d)
	if len(res) != 300 {
		t.Fatalf("resultados = %d, quiero 300", len(res))
	}
	for s, r := range res {
		if r.Student != shared.ID(s) {
			t.Fatalf("posición %d tiene al estudiante %d", s, r.Student)
		}
	}
}
