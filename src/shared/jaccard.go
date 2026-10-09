package shared

import (
	"fmt"
	"math/bits"
)

func Jaccard(a, b []uint64) (float64, error) {
	if len(a) != len(b) {
		return 0, fmt.Errorf("jaccard: mask with different sizes: %d vs %d", len(a), len(b))
	}

	var common, total int
	for i := range a {
		common += bits.OnesCount64(a[i] & b[i])
		total += bits.OnesCount64(a[i] | b[i])
	}

	if total == 0 {
		return 0, nil
	}

	return float64(common) / float64(total), nil
}

// JaccardStudents calcula lo mismo que Jaccard sobre los 3 bitmasks de cada
// estudiante, pero sin crear slices (se usa en el camino caliente).
func JaccardStudents(a, b *Student) float64 {
	var common, total int
	for c := 0; c < NumCores; c++ {
		x, y := a.Cores[c].Completed, b.Cores[c].Completed
		common += bits.OnesCount64(x & y)
		total += bits.OnesCount64(x | y)
	}

	if total == 0 {
		return 0
	}

	return float64(common) / float64(total)
}
