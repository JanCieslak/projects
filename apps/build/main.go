package main

import (
	"encoding/json"
	"log"
	"os"
	"os/exec"
	"path/filepath"
)

const (
	wasmRelativePath = "../../pages/static/wasm"
)

type BuildConfigs struct {
	Go []GoBuildConfig `json:"go"`
}

type GoBuildConfig struct {
	Path string `json:"path"`
	Name string `json:"name"`
}

func main() {
	configBytes, err := os.ReadFile("./build-configurations.json")
	panicIfNil(err, "Failed to open file")

	var config BuildConfigs
	err = json.Unmarshal(configBytes, &config)
	panicIfNil(err, "Failed to unmarshall config data")

	wasmAbsolutePath, err := filepath.Abs(wasmRelativePath)
	panicIfNil(err, "Absolute filepath failed")

	if len(config.Go) > 0 {
		err := os.Setenv("GOOS", "js")
		panicIfNil(err, "Failed to set GOOS")

		err = os.Setenv("GOARCH", "wasm")
		panicIfNil(err, "Failed to set GOARCH")

		for _, c := range config.Go {
			log.Printf("Building %s from path: %s\n", c.Name, c.Path)

			panicIfEmpty(c.Path, "specify path")
			panicIfEmpty(c.Name, "specify path")

			cmd := exec.Command("go", "build", "-o", wasmAbsolutePath+"/"+c.Name+".wasm")
			cmdDir, err := filepath.Abs("../" + c.Path)
			panicIfNil(err, "Absolute filepath failed")
			cmd.Dir = cmdDir

			out, err := cmd.Output()
			panicIfNil(err, "Failed to run build")
			log.Println("Build command output: " + string(out))
		}
	}
}

func panicIfEmpty(s string, message string) {
	if len(s) == 0 {
		panic(message)
	}
}

func panicIfNil(err error, message string) {
	if err != nil {
		panic(message + ": " + err.Error())
	}
}
