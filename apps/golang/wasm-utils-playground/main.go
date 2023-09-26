package main

import (
	"fmt"
	wasmutils "wasm-renderer"
)

func main() {
	document := wasmutils.GetDocument()
	canvas := document.GetCanvas("#wasm-utils-playground-canvas")
	fmt.Println(canvas)
}
