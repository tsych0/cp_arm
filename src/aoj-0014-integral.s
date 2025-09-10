// Created by Ayush Biswas at 2025/09/10 18:14
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0014
        .global     _main
        .text
_main:

solve_again:
        bl      _solve
        cbz     x0, solve_again

        mov     x0, #0
        bl      _exit

scan$int:       .asciz  "%d"
print$int:      .asciz  "%ld\n"
                .align  2 

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.d .req x19
        sub     solve.d, fp, 4

        adr     x0, scan$int 
        str     solve.d, [sp]
        bl      _scanf
        cmp     x0, #1
        mov     x0, #1
        bne     eof

        ldr     w19, [solve.d]
        mov     x1, #0
        mov     x3, #0
next_value:
        madd    x3, x1, x1, x3
        add     x1, x1, solve.d
        cmp     x1, #600
        bne     next_value
        mul     x3, x3, solve.d 

        str     x3, [sp]
        adr     x0, print$int
        bl      _printf

        mov     x0, #0
eof:
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret