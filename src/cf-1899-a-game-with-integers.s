// Created by Ayush Biswas at 2025/09/03 16:03
// https://codeforces.com/problemset/problem/1899/A
        .global     _main

        .text

Scan$t:         .asciz  "%ld"
                .align  2

_main:
        mov     fp, sp
        sub     sp, sp, #16 // can store upto two quads     

        main.t  = -8

        adr    x0, Scan$t
        add     x1, fp, main.t
        str     x1, [sp]
        bl      _scanf

        ldr     x19, [fp, main.t]

solveAgain:
        bl      _solve
        subs    x19, x19, 1
        bne     solveAgain

        mov     x0, #0
        bl      _exit

Scan$n:         .asciz  "%ld"
First:          .asciz  "First\n"
Second:         .asciz  "Second\n"
                .align 2
                
_solve:
        stp fp, lr, [sp, #-16]!
        mov fp, sp
        sub sp, sp, #32

        solve.n = -8

        adr    x0, Scan$n
        add     x1, fp, solve.n
        str     x1, [sp]
        bl      _scanf
        ldr     x0, [fp, solve.n]

        // compute remainder
        mov     x1, #3
        udiv    x2, x0, x1
        msub    x0, x1, x2, x0
        cbz     x0, vovaWins // jump according to remainder

vanyaWins: 
        adr     x0, First
        bl      _printf
        b       endsolve
vovaWins:
        adr     x0, Second
        bl      _printf
endsolve:
        add sp, sp, #32
        ldp fp, lr, [sp], #16
        ret