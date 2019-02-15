#include "textflag.h"

TEXT ·loadBytes(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·prepareBytes(SB), NOSPLIT, $0
    CallImport
    RET
