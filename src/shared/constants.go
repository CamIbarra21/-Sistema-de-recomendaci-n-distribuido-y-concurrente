package shared

// Decisión de aritmética: todo el proyecto usa float64. Los CSV traen
// decimales de doble precisión y el costo de memoria es irrelevante con
// 25,000 estudiantes. Los modos secuencial y concurrente llaman a las mismas
// funciones y suman en el mismo orden, por lo que dan resultados idénticos.
const (
	NumNeighbors       = 5
	NumRecommendations = 3

	WeightAffinity      float64 = 0.25
	WeightSkill         float64 = 0.25
	WeightCollaboration float64 = 0.50
)

// Estructura del dataset: 3 núcleos de 60 cursos cada uno, de modo que un
// uint64 por núcleo alcanza como bitmask de cursos aprobados.
const (
	NumCores       = 3
	CoursesPerCore = 60
	MaxPrereqs     = 2
	NoPrereq       = -1
)

// Índice de cada núcleo (coincide con el orden del pseudocódigo).
const (
	CoreMath    = 0
	CoreReading = 1
	CoreScience = 2
)

// CoreNames mapea el nombre del CSV al índice del núcleo.
var CoreNames = map[string]int{
	"Matematica": CoreMath,
	"Lectura":    CoreReading,
	"Ciencias":   CoreScience,
}
