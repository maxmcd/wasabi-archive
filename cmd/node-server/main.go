package main

import (
	"fmt"
	"log"
	"net"
	"net/http"
	"time"

	"github.com/gorilla/mux"
	"github.com/maxmcd/wasm-servers/pkg/wasmjshttp"
)

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello %s", time.Now())
	})
	conn, err := net.Dial("tcp", "golang.org:80")
	fmt.Println(conn, err)
	// _, err := http.Get("https://www.google.com")
	// log.Println(err)
	log.Fatal(wasmjshttp.ListenAndServe(":8080", r))
}
