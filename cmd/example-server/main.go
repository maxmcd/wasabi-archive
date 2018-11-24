package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/mux"
	"github.com/maxmcd/wasm-servers/pkg/wasmhttp"
)

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello %s", time.Now())
	})
	log.Fatal(wasmhttp.ListenAndServe(":8080", r))
}
