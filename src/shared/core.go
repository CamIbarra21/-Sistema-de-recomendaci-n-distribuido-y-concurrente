package shared

// Core agrupa la información de un estudiante en un núcleo.
// Affinity y Skill vienen del CSV en [0,1]; Completed es el bitmask de
// cursos aprobados (bit i = i-ésimo curso del núcleo, 0..59).
type Core struct {
	Affinity  float64
	Skill     float64
	Completed uint64
}
