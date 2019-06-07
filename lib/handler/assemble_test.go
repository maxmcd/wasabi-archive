package handler

import (
	"bufio"
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"net/http/httputil"
	"testing"
)

func TestRespDump(t *testing.T) {

	handlerFunc := func(w http.ResponseWriter, req *http.Request) {
		b, _ := ioutil.ReadAll(req.Body)
		w.Write([]byte(fmt.Sprintf("hello hello %s", string(b))))
	}

	s := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		b, err := httputil.DumpRequest(req, true)
		if err != nil {
			t.Error(err)
		}

		fmt.Println(string(b))

		r, err := http.ReadRequest(bufio.NewReader(bytes.NewBuffer(b)))
		if err != nil {
			t.Error(err)
		}

		rw := ResponseWriter{}
		handlerFunc(&rw, r)

		w.Write(rw.Body.Bytes())
	}))

	resp, err := http.Post(s.URL, "text/plain", bytes.NewBuffer([]byte("DATA")))
	if err != nil {
		t.Error(err)
	}
	b, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		t.Error(err)
	}
	fmt.Println(string(b))
}
