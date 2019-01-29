#include "textflag.h"

TEXT ·listenTcp(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·acceptTcp(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·readConn(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·writeConn(SB), NOSPLIT, $0
    CallImport
    RET
