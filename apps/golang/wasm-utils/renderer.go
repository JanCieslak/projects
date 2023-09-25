package wasmutils

import "syscall/js"

type Canvas struct {
	js.Value
}

func GetCanvas(canvasName string) Canvas {
	return Canvas{
		Value: js.Global().Call("querySelector", canvasName),
	}
}
