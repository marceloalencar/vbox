; $Id: bs3-cmn-SelRealModeDataToFlat.asm $
;; @file
; BS3Kit - Bs3SelRealModeDataToFlat.
;

;
; Copyright (C) 2007-2020 Oracle Corporation
;
; This file is part of VirtualBox Open Source Edition (OSE), as
; available from http://www.virtualbox.org. This file is free software;
; you can redistribute it and/or modify it under the terms of the GNU
; General Public License (GPL) as published by the Free Software
; Foundation, in version 2 as it comes in the "COPYING" file of the
; VirtualBox OSE distribution. VirtualBox OSE is distributed in the
; hope that it will be useful, but WITHOUT ANY WARRANTY of any kind.
;
; The contents of this file may alternatively be used under the terms
; of the Common Development and Distribution License Version 1.0
; (CDDL) only, as it comes in the "COPYING.CDDL" file of the
; VirtualBox OSE distribution, in which case the provisions of the
; CDDL are applicable instead of those of the GPL.
;
; You may elect to license modified versions of this file under the
; terms and conditions of either the GPL or the CDDL or both.
;


;*********************************************************************************************************************************
;*      Header Files                                                                                                             *
;*********************************************************************************************************************************
%include "bs3kit-template-header.mac"


;*********************************************************************************************************************************
;*  External Symbols                                                                                                             *
;*********************************************************************************************************************************
TMPL_BEGIN_TEXT
%if TMPL_BITS == 16
CPU 8086
%endif


;;
; @cproto   BS3_CMN_PROTO_NOSB(uint32_t, Bs3SelRealModeDataToFlat,(uint32_t uFar1616));
; @cproto   BS3_CMN_PROTO_NOSB(uint32_t, Bs3SelRealModeCodeToFlat,(uint32_t uFar1616));
;
; @uses     Only return registers (ax:dx, eax, eax);
; @remarks  No 20h scratch area requirements.
;
BS3_PROC_BEGIN_CMN Bs3SelRealModeCodeToFlat, BS3_PBC_NEAR      ; Far stub generated by the makefile/bs3kit.h.
BS3_PROC_BEGIN_CMN Bs3SelRealModeDataToFlat, BS3_PBC_NEAR      ; Far stub generated by the makefile/bs3kit.h.
        push    xBP
        mov     xBP, xSP

        ; Calc flat address.
%if TMPL_BITS == 16
        push    cx
        mov     dx, [xBP + xCB + cbCurRetAddr + 2]
        mov     ax, dx
        mov     cl, 12
        shr     dx, cl
        mov     cl, 4
        shl     ax, cl
        add     ax, [xBP + xCB + cbCurRetAddr]
        adc     dx, 0
        pop     cx

%elif TMPL_BITS == 32
        movzx   eax, word [xBP + xCB + cbCurRetAddr + 2]
        shl     eax, 4
        add     ax, [xBP + xCB + cbCurRetAddr]
        jnc     .return
        add     eax, 10000h

%elif TMPL_BITS == 64
        mov     eax, ecx
        shr     eax, 16
        shl     eax, 4
        add     ax, cx
        jnc     .return
        add     eax, 10000h

%else
 %error "TMPL_BITS!"
%endif

.return:
        pop     xBP
        BS3_HYBRID_RET
BS3_PROC_END_CMN   Bs3SelRealModeDataToFlat

