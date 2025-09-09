// Created by Ayush Biswas at 2025/09/08 15:19
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0007
        .global     _main

        .text
scan$n:         .asciz  "%ld"
print$res:      .asciz  "%ld"
        .align 2
_main:
        mov     fp, sp
        sub     sp, sp, #16 // can store upto two quads     

        main.n  = -8

        // Read t
        adr     x0, scan$n
        add     x1, fp, main.n
        str     x1, [sp]
        bl      _scanf

        // load t in x19
        ldr     x19, [fp, main.n]
        ldr     x0, =100000
        mov     x2, 100
        mov     x3, 1000
        mov     x4, 5
next_week:
        cbz     x19, done_with_interests
        mul     x1, x0, x4
        udiv    x1, x1, x2
        add     x0, x0, x1
        add     x0, x0, 999
        udiv    x0, x0, x3
        mul     x0, x0, x3
        sub     x19, x19, #1
        b       next_week
done_with_interests:
        str     x0, [sp]
        adr     x0, print$res
        bl      _printf

        mov     x0, #0
        bl      _exit
