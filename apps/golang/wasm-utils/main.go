package wasmutils

import (
	"fmt"
	"syscall/js"
	"time"
)

var isRunning = false

//export pause
func pause(this js.Value, args []js.Value) any {
	isRunning = false
	return nil
}

//export play
func play(this js.Value, args []js.Value) any {
	isRunning = true
	return nil
}

type WasmApplication interface {
	// Init initialize application state. It's also used as application state reset.
	Init()
	// Step represents a single simulation step / application frame
	Step(dt float64)
}

func Run(app WasmApplication) {
	postfix := GetArg("postfix")
	js.Global().Set(fmt.Sprintf("play%s", *postfix), js.FuncOf(play))
	js.Global().Set(fmt.Sprintf("pause%s", *postfix), js.FuncOf(pause))

	fmt.Printf("Setting: play%s\n", *postfix)
	fmt.Printf("Setting: pause%s\n", *postfix)

	// TODO Reset
	app.Init()
	for {
		fmt.Println("IsRunning", isRunning)
		time.Sleep(time.Second)
		if isRunning {
			app.Step(0) // TODO delta time
		}
	}
}
