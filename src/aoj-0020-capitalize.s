// Created by Ayush Biswas at 2025/09/11 16:16
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0020
        .global     _main

        .text
_main:
        bl      _solve

        mov     x0, #0
        bl      _exit

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.string = -8
        solve.strcap = -16
        solve.len .req x19

        str     xzr, [fp, solve.string]
        str     xzr, [fp, solve.strcap]

        adrp    x2, ___stdinp@GOTPAGE
        ldr     x2, [x2, ___stdinp@GOTPAGEOFF]
        ldr     x2, [x2]
        add     x0, fp, solve.string
        add     x1, fp, solve.strcap
        bl      _getline
        mov     solve.len, x0

        sub     x9, solve.len, #1
        ldr     x10, [fp, solve.string]
        mov     w11, ' '
make_uppercase:
        sub     x9, x9, #1
        ldrb    w0, [x10, x9]
        cmp     w0, ' '
        beq     make_uppercase
        cmp     w0, '.'
        beq     make_uppercase
        eor     w0, w0, w11
        strb    w0, [x10, x9]
        cbnz    x9, make_uppercase

        mov     x0, x10
        bl      _printf

        ldr     x0, [fp, solve.string]
        bl      _free
        
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret