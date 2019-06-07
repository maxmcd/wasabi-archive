package main

import (
	"context"
	"os"

	hclog "github.com/hashicorp/go-hclog"
	"github.com/hashicorp/nomad/drivers/shared/executor"
)

type Logger struct {
	l hclog.Logger
}

func main() {
	ec := executor.ExecCommand{
		Cmd:  "ulimit",
		Args: []string{"-a"},
	}
	ec.SetWriters(os.Stdout, os.Stderr)

	// ue := executor.UniversalExecutor{}
	logger := Logger{l: hclog.Default()}

	ue := executor.NewExecutorWithIsolation(logger)
	ue.Launch(&ec)
	ue.Wait(context.Background())
}
