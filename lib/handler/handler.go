// +build !wasm

package handler

import (
	"log"
	"net/http"
	"os"

	"github.com/gorilla/handlers"
)

// ServeRequest serves the request
func ServeRequest(handle func(http.ResponseWriter, *http.Request)) {
	log.Println("Compiled outside of a wasm context. Starting the debug server.")
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	log.Printf("Broadcasting on port %s\n", port)
	log.Fatal(http.ListenAndServe(":"+port, handlers.LoggingHandler(os.Stdout, http.HandlerFunc(handle))))
}
