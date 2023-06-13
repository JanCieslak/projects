package main

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var command = cobra.Command{
	Use:   "",
	Short: "",
	Long:  "",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Hi")
	},
}

var directory os.DirEntry

func init() {
	var dirPath string
	command.PersistentFlags().StringVar(&dirPath, "directory", "./", "TODO")
}

func main() {
	command.Execute()
}
