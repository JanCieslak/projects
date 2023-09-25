package main

import (
	"fmt"
	wasmutils "wasm-renderer"
)

func main() {
	canvas := wasmutils.GetCanvas("#wasm-utils-playground-canvas")
	fmt.Println(canvas)
}
