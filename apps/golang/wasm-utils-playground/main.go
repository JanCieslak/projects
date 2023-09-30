package main

import (
	wasmutils "wasm-renderer"
)

func main() {
	ctx := wasmutils.GetMainCanvasContext2D()
	ctx.FillStyle("green")
	ctx.FillRect(10, 10, 200, 30)
}
