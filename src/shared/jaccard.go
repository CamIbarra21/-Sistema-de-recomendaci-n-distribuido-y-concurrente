package shared

import (
	"fmt"
	"math/bits"
)

func Jaccard(a, b []uint64) (float32, error) {
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

	return float32(common) / float32(total), nil
}
