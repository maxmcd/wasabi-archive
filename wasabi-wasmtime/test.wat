;; an example wat hello world with the Go module
(module
    (type (;0;) (func (param i32 i32)))
    (type (;1;) (func (param i32)))
    (import "go" "runtime.wasmExit" (func $exit (param i32)))
    (import "go" "runtime.wasmWrite" (func $log (param i32)))
    (func $run (type 0)
        i32.const 4000
        call $log
        i32.const 0
        call $exit
        )
    (export "run" (func $run))
    (export "resume" (func $run))
    (memory (;0;) 16384)
    (export "mem" (memory 0))
    (data (i32.const 2000) "Hello World\n")
                                                                            ;; 2000 at 16 offset     12 at 16+8 offset
    (data (i32.const 4000) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\d0\07\00\00\00\00\00\00\0c")
)

