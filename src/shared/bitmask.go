package shared

import "fmt"

// BoolToBitmask convierte los cursos de un núcleo (máx. CoursesPerCore) en un bitmask.
func BoolToBitmask(arr []bool) (uint64, error) {
	if len(arr) > CoursesPerCore {
		return 0, fmt.Errorf("bitmask: %d cursos exceden el máximo de %d por núcleo", len(arr), CoursesPerCore)
	}

	var mask uint64
	for i, done := range arr {
		if done {
			mask |= 1 << i
		}
	}

	return mask, nil
}
