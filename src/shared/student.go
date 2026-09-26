package shared

type Student struct {
	ID      ID
	Math    Core
	Reading Core
	Science Core
}

var NextID ID = 0

func (s *Student) Init(math, reading, science Core) {
	s.ID = NextID
	NextID++
	s.Math = math
	s.Reading = reading
	s.Science = science
}
