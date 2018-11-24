const http = require("http");
const Go = require("./wasm_exec.js");
const fs = require("fs");

global.__server = (addr, handler) => {
    console.log("__server called", addr, handler);
    http
        .createServer(function(req, res) {
            global["__wasmhttp_request"](handler, req, res, body => {
                res.write(body);
                res.end();
            });
        })
        .listen(Number(addr.substr(1, 4)));
};

const go = new Go();
go.env = process.env;
go.exit = process.exit;
WebAssembly.instantiate(
    fs.readFileSync("./example-server.wasm"),
    go.importObject
)
    .then(result => {
        process.on("exit", code => {
            // Node.js exits if no callback is pending
            if (code === 0 && !go.exited) {
                // deadlock, make Go print error and stack traces
                // go._callbackShutdown = false;
                go._inst.exports.run();
            }
        });
        return go.run(result.instance);
    })
    .catch(err => {
        throw err;
    });

wait = () => {
    setTimeout(wait, 1000);
};
wait();
