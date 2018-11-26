package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Println("Request recieved")
		fmt.Fprintf(w, "Hello %s", time.Now())
	})
	log.Println("Listening at :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
