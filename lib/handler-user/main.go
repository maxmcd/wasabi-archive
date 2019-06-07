package main

import (
	"net/http"

	"github.com/wasabi/handler"
)

func main() {
	handler.ServeRequest(func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello"))
	})
}
