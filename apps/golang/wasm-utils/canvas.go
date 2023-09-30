package wasmutils

import "syscall/js"

type Canvas struct {
	js.Value
}

func (c Canvas) GetContext2D() Context2D {
	return Context2D{
		Value: c.Call("getContext", "2d"),
	}
}
