package shared

import "fmt"

func BoolToBitmask(arr []bool) (uint64, error) {
	var mask uint64

	for i, done := range arr {
		if i >= 64 {
			return 0, fmt.Errorf("boot2bitmask: uint64 is losing, refactor needed")
		}
		if done {
			mask |= 1 << i
		}
	}

	return mask, nil
}
