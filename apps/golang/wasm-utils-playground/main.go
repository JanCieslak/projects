package main

import (
	wasmutils "wasm-renderer"
)

type Playground struct {
	ctx wasmutils.Context2D
}

func (p *Playground) Init() {

}

func (p *Playground) Step(dt float64) {
	p.ctx.FillStyle("green")
	p.ctx.FillRect(10, 10, 200, 30)
}

func main() {
	wasmutils.Run(&Playground{
		ctx: wasmutils.GetMainCanvasContext2D(),
	})
}
