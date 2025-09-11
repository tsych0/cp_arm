// Created by Ayush Biswas at 2025/09/11 17:13
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0019
        .global     _main
        .text

_main:
        bl      _solve


        mov     x0, #0
        bl      _exit

scan$n:         .asciz  "%d"
print$n:        .asciz  "%ld\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.n = -8

        adr     x0, scan$n
        add     x1, fp, solve.n
        str     x1, [sp]
        bl      _scanf

        ldr     w1, [fp, solve.n]
        mov     x2, #1
next_number:
        mul     x2, x2, x1
        subs    w1, w1, #1
        bne     next_number

        str     x2, [sp]
        adr     x0, print$n
        bl      _printf
        
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret