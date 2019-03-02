package net

import (
	"io/ioutil"
	"net/http"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestRoundtripperAndListenAndServe(t *testing.T) {
	body := []byte("Hello World")
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Write(body)
	})
	go ListenAndServe("127.0.0.1:8080", handler)
	time.Sleep(time.Millisecond * 10) // wait for the server to be ready

	client := http.Client{Transport: &RoundTripper{}}

	req, err := http.NewRequest("GET", "http://localhost:8080", nil)
	if err != nil {
		t.Error(err)
	}
	resp, err := client.Do(req)
	if err != nil {
		t.Error(err)
	}

	assert := assert.New(t)
	assert.Equal(http.StatusOK, resp.StatusCode, "status code should be 200")

	b, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		t.Error(err)
	}
	assert.Equal(body, b, "response body should be the same")
}
