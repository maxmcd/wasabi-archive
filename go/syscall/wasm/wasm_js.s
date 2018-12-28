#include "textflag.h"

TEXT ·getRandomData(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·loadBytes(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·prepareBytes(SB), NOSPLIT, $0
    CallImport
    RET
