package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"net/http"
	"os"
)

func application(arguments []string) int {

	fmt.Println("Starting Application")

	router := mux.NewRouter()
	router.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		writer.WriteHeader(200)
		writer.Write([]byte("Hello"))
	})

	http.ListenAndServe(":8080", router)

	return 0
}

func main() {
	os.Exit(application(os.Args))
}
