package shared

type Core struct {
	Affinity  float32
	Skill     float32
	Completed uint64
}

func (c *Core) Init(affinity float32, skill float32, completed uint64) {
	c.Affinity = affinity
	c.Skill = skill
	c.Completed = completed
}
