package shared

// Student guarda un estudiante por núcleo, indexado por CoreMath,
// CoreReading y CoreScience. ID es el índice denso (orden de aparición en
// estudiantes.csv).
type Student struct {
	ID    ID
	Cores [NumCores]Core
}
