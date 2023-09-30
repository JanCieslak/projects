package wasmutils

import "syscall/js"

type Context2D struct {
	js.Value
}

func GetMainCanvasContext2D() Context2D {
	canvasId := GetArg("canvasId")
	document := GetDocument()
	canvas := document.GetCanvas(*canvasId)
	return canvas.GetContext2D()
}

func (c Context2D) FillStyle(style string) {
	c.Set("fillStyle", style)
}

func (c Context2D) FillRect(x, y, w, h int) {
	c.Call("fillRect", x, y, w, h)
}
