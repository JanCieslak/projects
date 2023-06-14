package main

import (
	"io/fs"
	"log"
	"os/exec"
	"path/filepath"

	"github.com/fsnotify/fsnotify"
	"github.com/spf13/cobra"
)

var mainCommand = cobra.Command{
	Use:   "run-on-change",
	Short: "TODO",
	Long:  "TODO",
	Run: func(cmd *cobra.Command, args []string) {
		// TODO: Validate args

		for i, arg := range args {
			log.Printf("Arg[%d]: %v\n", i, arg)
		}

		directory := args[0]

		watcher, err := fsnotify.NewWatcher()
		if err != nil {
			log.Fatalln(err)
		}
		defer watcher.Close()

		path, err := filepath.Abs(directory)
		if err != nil {
			log.Fatalln(err)
		}

		go func() {
			for {
				select {
				case event, ok := <-watcher.Events:
					if !ok {
						return
					}
					log.Println("Event:", event)
					if event.Has(fsnotify.Write) {
						log.Printf("Modified file: %s, running: %v\n", event.Name, args[1:])
						cmd := exec.Command(args[1], args[2:]...)
						cmd.Dir = path
						out, err := cmd.Output()
						log.Printf("Command output: %q\n", string(out))
						if err != nil {
							log.Println(err)
						}
					}
				case err, ok := <-watcher.Errors:
					if !ok {
						return
					}
					log.Println("error:", err)
				}
			}
		}()

		log.Printf("Watching: %s\n", path)

		err = filepath.Walk(path, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}

			err = watcher.Add(path)
			if err != nil {
				return err
			}

			return nil
		})
		if err != nil {
			log.Fatalln(err)
		}

		<-make(chan struct{})
	},
}

func main() {
	mainCommand.Execute()
}
