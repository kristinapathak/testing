package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"io"
	"net/http"
	"os"
	"runtime"
)

const (
	applicationName = "testing"
)

var (
	// dynamic versioning
	Version   string
	BuildTime string
	GitCommit string
)

func application(arguments []string) int {

	fmt.Println("Starting Application!!")

	router := mux.NewRouter()
	router.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		writer.WriteHeader(200)
		writer.Write([]byte("Hi"))
	})

	http.ListenAndServe(":8080", router)

	return 0
}

func main() {
	printVersionInfo(os.Stdout)
	os.Exit(application(os.Args))
}

func printVersionInfo(writer io.Writer) {
	fmt.Fprintf(writer, "%s:\n", applicationName)
	fmt.Fprintf(writer, "  version: \t%s\n", Version)
	fmt.Fprintf(writer, "  go version: \t%s\n", runtime.Version())
	fmt.Fprintf(writer, "  built time: \t%s\n", BuildTime)
	fmt.Fprintf(writer, "  git commit: \t%s\n", GitCommit)
	fmt.Fprintf(writer, "  os/arch: \t%s/%s\n", runtime.GOOS, runtime.GOARCH)
}
