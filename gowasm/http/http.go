package http

import "net/http"

// Get is...
func Get(url string) (resp *http.Response, err error) {
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return
	}
	return roundTrip(req)
}
