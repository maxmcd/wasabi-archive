// Copyright 2013 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "textflag.h"

TEXT ·getRandomData(SB), NOSPLIT, $0
    CallImport
    RET


TEXT ·write(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·setenv(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·getenv(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·prepareArrayOfRefs(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·loadArrayOfRefs(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·valueLoadString(SB), NOSPLIT, $0
    CallImport
    RET

TEXT ·valuePrepareString(SB), NOSPLIT, $0
    CallImport
    RET


TEXT ·lookupAddr(SB), NOSPLIT, $0
    CallImport
    RET
