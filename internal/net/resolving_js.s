#include "textflag.h"

TEXT ·lookupIP(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·lookupPort(SB), NOSPLIT, $0
    CallImport
    RET
