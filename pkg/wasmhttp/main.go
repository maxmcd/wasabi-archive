package wasmhttp

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/http/httptest"

	"syscall/js"
)

var handlers []http.Handler

func init() {
	js.Global().Set("__wasmhttp_request", js.NewCallback(request))
}

// ListenAndServe will serve an http handler
func ListenAndServe(addr string, handler http.Handler) error {
	c := make(chan struct{}, 0)
	handlers = append(handlers, handler)
	js.Global().Get("__server").Invoke(addr, len(handlers)-1)
	fmt.Println("OK")
	<-c
	return nil
}

func request(i []js.Value) {
	handler := handlers[i[0].Int()]
	// jsreq := i[1]
	// jsres := i[2]
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		log.Fatal(err)
	}
	w := httptest.NewRecorder()
	handler.ServeHTTP(w, req)
	resp := w.Result()
	body, _ := ioutil.ReadAll(resp.Body)
	i[3].Invoke(string(body))
}
