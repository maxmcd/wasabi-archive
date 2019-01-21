// Copyright 2013 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

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
