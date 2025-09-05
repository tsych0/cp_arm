// Created by Ayush Biswas at 2025/09/03 00:16
// https://codeforces.com/problemset/problem/1999/A

        .global     _main

        .text

Scan$t:        .asciz  "%ld"

        .align  2
_main:
        mov     fp, sp
        sub     sp, sp, #16 // can store upto two quads     

        main.t  = -8

        adr    x0, Scan$t
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

Scan$n:         .asciz  "%ld"
Print$res:      .asciz  "%ld\n"

        .align  2
_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #16 // can store upto 2 quads

        solve.n = -8

        // Read n
        adr    x0, Scan$n
        add     x1, fp, solve.n
        str     x1, [sp]
        bl      _scanf

        ldr     x1, [fp, solve.n]
        mov     x2, #10
        udiv    x3, x1, x2 // x3 = x1 / 10
        msub    x2, x3, x2, x1 // x2 = x1 - x3*10
        add     x1, x2, x3 // x1 = x2 + x3
        // Print x1
        adr    x0, Print$res
        str     x1, [sp] 
        bl      _printf

        add     sp, sp, #16
        ldp     fp, lr, [sp], #16
        ret