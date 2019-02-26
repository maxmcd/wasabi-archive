package wasabi

import (
	"fmt"
	"testing"
)

func TestMain(t *testing.T) {
	ln, err := ListenTcp("127.0.0.1:12384")
	fmt.Println(ln, err)
}
