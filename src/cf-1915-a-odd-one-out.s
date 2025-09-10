// Created by Ayush Biswas at 2025/09/03 15:33
// https://codeforces.com/problemset/problem/1915/A

        .global     _main

        .text
Scan$t:         .asciz  "%ld"
Scan$abc:       .asciz  "%d %d %d"
Print$res:      .asciz  "%d\n"
                .align  2
                
_main:
        mov     fp, sp
        sub     sp, sp, #16 // can store upto two quads     

        main.t  = -8

        // Read t
        adr     x0, Scan$t
        add     x1, fp, main.t
        str     x1, [sp]
        bl      _scanf

        // load t in x19
        ldr     x19, [fp, main.t]
solveAgain:
        bl      _solve
        subs    x19, x19, 1
        bne     solveAgain

        mov     x0, #0
        bl      _exit

_solve:
        stp fp, lr, [sp, #-16]!
        mov fp, sp
        sub sp, sp, #48

        solve.a = -4
        solve.b = solve.a - 4
        solve.c = solve.b - 4

        adr    x0, Scan$abc
        add     x1, fp, solve.c
        str     x1, [sp]
        add     x1, fp, solve.b
        str     x1, [sp, #8]
        add     x1, fp, solve.a
        str     x1, [sp, #16]
        bl      _scanf

        ldr     w0, [fp, solve.a]
        ldr     w1, [fp, solve.b]
        ldr     w2, [fp, solve.c]

        eor     w1, w0, w1
        eor     w1, w1, w2

        adr    x0, Print$res
        str     w1, [sp]
        bl      _printf
        
        add sp, sp, #48
        ldp fp, lr, [sp], #16
        ret