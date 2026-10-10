package main

import (
	"fmt"
	"math"
	"os"
	"path/filepath"
	"strings"
)

// Gráficos SVG sin dependencias. Colores: slots 1 y 2 de la paleta categórica
// de referencia (azul y naranja, en ese orden fijo), con variante oscura.
// Los marcadores difieren en forma (círculo / cuadrado) para no depender solo del color.

type point struct{ x, y, lo, hi float64 } // lo/hi: rango mín-máx de las repeticiones

type chartLine struct {
	name   string
	class  string // s1 | s2
	square bool
	pts    []point
}

type chart struct {
	title, subtitle, yLabel string
	yMax                    float64
	ticks                   []float64
	tickFmt                 string
	ideal                   []point // referencia, línea punteada gris
	idealName               string
	lines                   []chartLine
	maxX                    float64
}

const svgStyle = `<style>
svg{--surface:#fcfcfb;--text:#0b0b0b;--text2:#52514e;--grid:#e6e5e0;--s1:#2a78d6;--s2:#eb6834;font-family:system-ui,Segoe UI,Arial,sans-serif}
@media (prefers-color-scheme:dark){svg{--surface:#1a1a19;--text:#ffffff;--text2:#c3c2b7;--grid:#34342f;--s1:#3987e5;--s2:#d95926}}
.bg{fill:var(--surface)}.t{fill:var(--text)}.t2{fill:var(--text2)}
.grid{stroke:var(--grid);stroke-width:1}.axis{stroke:var(--text2);stroke-width:1}
.ideal{stroke:var(--text2);stroke-width:1.5;stroke-dasharray:5 4;fill:none}
.s1.l{stroke:var(--s1)}.s2.l{stroke:var(--s2)}
.s0.m{fill:var(--text2)}.s1.m{fill:var(--s1)}.s2.m{fill:var(--s2)}
.l{fill:none;stroke-width:2;stroke-linejoin:round}.m{stroke:var(--surface);stroke-width:2}
.w{stroke-width:1.5;opacity:.55}
.wh{stroke:var(--text2);stroke-width:1.5;opacity:.8}
</style>`

func (c chart) svg() string {
	const W, H = 720.0, 420.0
	const ml, mr, mt, mb = 64.0, 28.0, 84.0, 68.0
	pw, ph := W-ml-mr, H-mt-mb
	px := func(x float64) float64 { return ml + math.Log2(x)/math.Log2(c.maxX)*pw }
	py := func(y float64) float64 { return mt + ph - y/c.yMax*ph }

	var b strings.Builder
	fmt.Fprintf(&b, `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 %g %g" width="%g" height="%g" role="img" aria-label="%s">`, W, H, W, H, c.title)
	b.WriteString(svgStyle)
	fmt.Fprintf(&b, `<rect class="bg" width="%g" height="%g"/>`, W, H)
	fmt.Fprintf(&b, `<text class="t" x="%g" y="26" font-size="16" font-weight="600">%s</text>`, ml, c.title)
	fmt.Fprintf(&b, `<text class="t2" x="%g" y="44" font-size="12">%s</text>`, ml, c.subtitle)

	// cuadrícula y eje Y
	for _, t := range c.ticks {
		y := py(t)
		fmt.Fprintf(&b, `<line class="grid" x1="%g" x2="%g" y1="%.1f" y2="%.1f"/>`, ml, ml+pw, y, y)
		fmt.Fprintf(&b, `<text class="t2" x="%g" y="%.1f" font-size="12" text-anchor="end">%s</text>`, ml-8, y+4, fmt.Sprintf(c.tickFmt, t))
	}
	fmt.Fprintf(&b, `<line class="axis" x1="%g" x2="%g" y1="%g" y2="%g"/>`, ml, ml+pw, mt+ph, mt+ph)
	fmt.Fprintf(&b, `<text class="t2" font-size="12" text-anchor="middle" transform="translate(16 %g) rotate(-90)">%s</text>`, mt+ph/2, c.yLabel)

	// eje X: un tick por cada cantidad de workers medida
	for _, p := range c.lines[0].pts {
		fmt.Fprintf(&b, `<text class="t2" x="%.1f" y="%g" font-size="12" text-anchor="middle">%g</text>`, px(p.x), mt+ph+20, p.x)
	}
	fmt.Fprintf(&b, `<text class="t2" x="%g" y="%g" font-size="12" text-anchor="middle">workers (escala logarítmica)</text>`, ml+pw/2, H-14)

	// referencia
	if len(c.ideal) == 2 {
		fmt.Fprintf(&b, `<line class="ideal" x1="%.1f" y1="%.1f" x2="%.1f" y2="%.1f"/>`,
			px(c.ideal[0].x), py(c.ideal[0].y), px(c.ideal[1].x), py(c.ideal[1].y))
	}

	// series
	for _, l := range c.lines {
		var path strings.Builder
		for i, p := range l.pts {
			cmd := "L"
			if i == 0 {
				cmd = "M"
			}
			fmt.Fprintf(&path, "%s%.1f %.1f", cmd, px(p.x), py(p.y))
		}
		fmt.Fprintf(&b, `<path class="%s l" d="%s"/>`, l.class, path.String())
		for _, p := range l.pts {
			x := px(p.x)
			fmt.Fprintf(&b, `<line class="%s l w" x1="%.1f" x2="%.1f" y1="%.1f" y2="%.1f"/>`, l.class, x, x, py(p.lo), py(p.hi))
			tip := fmt.Sprintf("%s, %g workers: %.2f (rango %.2f a %.2f)", l.name, p.x, p.y, p.lo, p.hi)
			if l.square {
				fmt.Fprintf(&b, `<rect class="%s m" x="%.1f" y="%.1f" width="9" height="9"><title>%s</title></rect>`, l.class, x-4.5, py(p.y)-4.5, tip)
			} else {
				fmt.Fprintf(&b, `<circle class="%s m" cx="%.1f" cy="%.1f" r="5"><title>%s</title></circle>`, l.class, x, py(p.y), tip)
			}
		}
	}

	// leyenda (siempre presente con 2 o más series)
	lx, ly := ml, 62.0
	fmt.Fprintf(&b, `<line class="s1 l" x1="%g" x2="%g" y1="%g" y2="%g"/><circle class="s1 m" cx="%g" cy="%g" r="5"/>`, lx, lx+22, ly, ly, lx+11, ly)
	fmt.Fprintf(&b, `<text class="t2" x="%g" y="%g" font-size="12">%s</text>`, lx+28, ly+4, c.lines[0].name)
	fmt.Fprintf(&b, `<line class="s2 l" x1="%g" x2="%g" y1="%g" y2="%g"/><rect class="s2 m" x="%g" y="%g" width="9" height="9"/>`, lx+190, lx+212, ly, ly, lx+190+6.5, ly-4.5)
	fmt.Fprintf(&b, `<text class="t2" x="%g" y="%g" font-size="12">%s</text>`, lx+218, ly+4, c.lines[1].name)
	fmt.Fprintf(&b, `<line class="ideal" x1="%g" x2="%g" y1="%g" y2="%g"/>`, lx+370, lx+392, ly, ly)
	fmt.Fprintf(&b, `<text class="t2" x="%g" y="%g" font-size="12">%s</text>`, lx+398, ly+4, c.idealName)

	b.WriteString(`</svg>`)
	return b.String()
}

// writeCharts genera speedup.svg y eficiencia.svg junto al reporte.
// Cada punto es la media recortada; la barra fina vertical marca el rango mín-máx de las repeticiones.
func writeCharts(dir string, reps int, seq *series, conc []*series) error {
	base := compute(seq.times)
	byName := map[string][]point{}
	for _, s := range conc {
		c := compute(s.times)
		w := float64(s.workers)
		// el mejor tiempo (mín) da el mayor speedup y el peor (máx) el menor
		byName[s.name] = append(byName[s.name], point{
			x: w, y: base.trimmed / c.trimmed, lo: base.trimmed / c.max, hi: base.trimmed / c.min,
		})
	}
	maxW := byName["canal"][len(byName["canal"])-1].x
	sub := fmt.Sprintf("Media recortada de %d repeticiones; la barra vertical marca el mínimo y el máximo", reps)

	speedup := chart{
		title: "Speedup frente al secuencial", subtitle: sub, yLabel: "speedup (T_sec / T_conc)",
		yMax: maxW, tickFmt: "%.0f", maxX: maxW, idealName: "ideal (speedup = workers)",
		ideal: []point{{x: 1, y: 1}, {x: maxW, y: maxW}},
	}
	eff := chart{
		title: "Eficiencia frente al secuencial", subtitle: sub, yLabel: "eficiencia (speedup / workers)",
		yMax: 1.1, tickFmt: "%.2f", maxX: maxW, idealName: "ideal (eficiencia = 1)",
		ideal: []point{{x: 1, y: 1}, {x: maxW, y: 1}},
	}
	for i := 0; i <= 4; i++ {
		speedup.ticks = append(speedup.ticks, maxW*float64(i)/4)
		if i < 4 {
			eff.ticks = append(eff.ticks, 0.25*float64(i+1))
		}
	}
	eff.ticks = append([]float64{0}, eff.ticks...)

	for _, v := range []struct {
		name, label, class string
		square             bool
	}{{"canal", "canal de resultados", "s1", false}, {"prealloc", "slice pre-asignado", "s2", true}} {
		sl := chartLine{name: v.label, class: v.class, square: v.square}
		el := chartLine{name: v.label, class: v.class, square: v.square}
		for _, p := range byName[v.name] {
			sl.pts = append(sl.pts, p)
			el.pts = append(el.pts, point{x: p.x, y: p.y / p.x, lo: p.lo / p.x, hi: p.hi / p.x})
		}
		speedup.lines = append(speedup.lines, sl)
		eff.lines = append(eff.lines, el)
	}

	if err := os.MkdirAll(dir, 0o755); err != nil {
		return err
	}
	if err := os.WriteFile(filepath.Join(dir, "tiempos.svg"), []byte(timesSVG(base, conc)), 0o644); err != nil {
		return err
	}
	for name, c := range map[string]chart{"speedup.svg": speedup, "eficiencia.svg": eff} {
		if err := os.WriteFile(filepath.Join(dir, name), []byte(c.svg()), 0o644); err != nil {
			return err
		}
	}
	return nil
}

// timesSVG dibuja el tiempo de ejecución (media recortada) del secuencial y del concurrente
// con cada cantidad de workers, para las dos variantes. La barra fina marca mín-máx.
func timesSVG(seq stats, conc []*series) string {
	const W, H = 720.0, 420.0
	const ml, mr, mt, mb = 64.0, 28.0, 84.0, 68.0
	pw, ph := W-ml-mr, H-mt-mb

	// ejes: el máximo es el mayor valor entre los máximos de cada repeticion
	top := seq.max
	for _, s := range conc {
		if m := compute(s.times).max; m > top {
			top = m
		}
	}
	step := 0.5
	for _, st := range []float64{0.5, 1, 2, 5, 10} {
		step = st
		if top/st <= 5 {
			break
		}
	}
	yMax := math.Ceil(top/step) * step
	py := func(y float64) float64 { return mt + ph - y/yMax*ph }

	// grupos: secuencial + una por cada cantidad de workers
	var workers []int
	for _, s := range conc {
		if s.name == "canal" {
			workers = append(workers, s.workers)
		}
	}
	groups := len(workers) + 1
	gw := pw / float64(groups)
	const bw = 24.0

	var b strings.Builder
	fmt.Fprintf(&b, `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 %g %g" width="%g" height="%g" role="img" aria-label="Tiempo de ejecución secuencial frente a concurrente">`, W, H, W, H)
	b.WriteString(svgStyle)
	fmt.Fprintf(&b, `<rect class="bg" width="%g" height="%g"/>`, W, H)
	fmt.Fprintf(&b, `<text class="t" x="%g" y="26" font-size="16" font-weight="600">Tiempo de ejecución: secuencial frente a concurrente</text>`, ml)
	fmt.Fprintf(&b, `<text class="t2" x="%g" y="44" font-size="12">Media recortada de las repeticiones; la barra vertical marca el mínimo y el máximo. Menos es mejor</text>`, ml)

	for t := 0.0; t <= yMax+1e-9; t += step {
		y := py(t)
		fmt.Fprintf(&b, `<line class="grid" x1="%g" x2="%g" y1="%.1f" y2="%.1f"/>`, ml, ml+pw, y, y)
		fmt.Fprintf(&b, `<text class="t2" x="%g" y="%.1f" font-size="12" text-anchor="end">%g</text>`, ml-8, y+4, t)
	}
	fmt.Fprintf(&b, `<line class="axis" x1="%g" x2="%g" y1="%g" y2="%g"/>`, ml, ml+pw, mt+ph, mt+ph)
	fmt.Fprintf(&b, `<text class="t2" font-size="12" text-anchor="middle" transform="translate(16 %g) rotate(-90)">tiempo (s)</text>`, mt+ph/2)

	bar := func(cx float64, class, label string, c stats, showValue bool) {
		x, y := cx-bw/2, py(c.trimmed)
		fmt.Fprintf(&b, `<rect class="%s m" x="%.1f" y="%.1f" width="%g" height="%.1f" rx="3"><title>%s: %.2f s (rango %.2f a %.2f)</title></rect>`,
			class, x, y, bw, mt+ph-y, label, c.trimmed, c.min, c.max)
		fmt.Fprintf(&b, `<line class="t2 wh" x1="%.1f" x2="%.1f" y1="%.1f" y2="%.1f"/>`, cx, cx, py(c.min), py(c.max))
		if showValue {
			fmt.Fprintf(&b, `<text class="t" x="%.1f" y="%.1f" font-size="11" text-anchor="middle">%.2f</text>`, cx, py(c.max)-5, c.trimmed)
		}
	}

	// grupo 0: secuencial (neutro, una sola barra)
	bar(ml+gw/2, "s0", "secuencial", seq, true)
	fmt.Fprintf(&b, `<text class="t2" x="%.1f" y="%g" font-size="12" text-anchor="middle">secuencial</text>`, ml+gw/2, mt+ph+20)
	for i, w := range workers {
		cx := ml + gw*float64(i+1) + gw/2
		for _, s := range conc {
			if s.workers != w {
				continue
			}
			c := compute(s.times)
			if s.name == "canal" {
				bar(cx-bw/2-1, "s1", fmt.Sprintf("canal, %d workers", w), c, true)
			} else {
				bar(cx+bw/2+1, "s2", fmt.Sprintf("slice pre-asignado, %d workers", w), c, false)
			}
		}
		label := fmt.Sprintf("%d workers", w)
		if w == 1 {
			label = "1 worker"
		}
		fmt.Fprintf(&b, `<text class="t2" x="%.1f" y="%g" font-size="12" text-anchor="middle">%s</text>`, cx, mt+ph+20, label)
	}

	// leyenda
	lx, ly := ml, 62.0
	fmt.Fprintf(&b, `<rect class="s0 m" x="%g" y="%g" width="12" height="12" rx="2"/><text class="t2" x="%g" y="%g" font-size="12">secuencial</text>`, lx, ly-6, lx+18, ly+4)
	fmt.Fprintf(&b, `<rect class="s1 m" x="%g" y="%g" width="12" height="12" rx="2"/><text class="t2" x="%g" y="%g" font-size="12">concurrente, canal de resultados</text>`, lx+120, ly-6, lx+138, ly+4)
	fmt.Fprintf(&b, `<rect class="s2 m" x="%g" y="%g" width="12" height="12" rx="2"/><text class="t2" x="%g" y="%g" font-size="12">concurrente, slice pre-asignado</text>`, lx+370, ly-6, lx+388, ly+4)
	b.WriteString(`</svg>`)
	return b.String()
}
