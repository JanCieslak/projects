package wasmutils

import "syscall/js"

type Canvas struct {
	js.Value
}

type Document struct {
	js.Value
}

func GetDocument() Document {
	return Document{
		Value: js.Global().Get("document"),
	}
}

func (d Document) querySelector(selector string) js.Value {
	return d.Call("querySelector", selector)
}

func (d Document) GetCanvas(canvasName string) Canvas {
	return Canvas{
		Value: d.querySelector(canvasName),
	}
}
