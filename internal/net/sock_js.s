#include "textflag.h"

TEXT ·listenTCP(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·acceptTcp(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·closeListener(SB), NOSPLIT, $0
    CallImport
    RET


TEXT ·readConn(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·writeConn(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·closeConn(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·localAddr(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·remoteAddr(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·dialTcp(SB), NOSPLIT, $0
    CallImport
    RET
