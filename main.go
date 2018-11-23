package main

import (
	"fmt"
	"net/http"
	"time"
)

func main() {

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello %s", time.Now())
	})

	// log.Fatal(http.ListenAndServe(":8080", nil))
	// http.Handler.ServeHTTP()
}
