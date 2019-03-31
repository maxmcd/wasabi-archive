package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/maxmcd/wasabi"
)

func main() {
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s %s %s\n", r.Method, r.URL.String(), time.Now())
		w.Write([]byte("Hello World"))
	})
	fmt.Println("listening on 0.0.0.0:8080")
	log.Fatal(wasabi.ListenAndServe("0.0.0.0:8080", handler))
}
