package wasmutils

import (
	"os"
	"strings"
)

func GetArg(argName string) *string {
	for _, f := range os.Args {
		s := strings.Split(f, ":")
		if len(s) == 2 && s[0] == argName {
			return &s[1]
		}
	}
	return nil
}
