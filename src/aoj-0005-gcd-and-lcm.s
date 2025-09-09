// Created by Ayush Biswas at 2025/09/08 11:04
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0005
        .global     _main

        .text
        .align 2
_main:

solve_again:
        bl      _solve
        cbz     x0, solve_again

        mov     x0, #0
        bl      _exit

scan$ab:        .asciz  "%d %d"
print$ans:      .asciz  "%ld %ld\n"

        .align  2
_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.a = -4
        solve.b = solve.a - 4

        adr     x0, scan$ab
        add     x1, fp, solve.a
        add     x2, fp, solve.b
        stp     x2, x1, [sp]
        bl      _scanf
        cmp     x0, 2

        mov     x0, #1
        bne     got_eof

        ldr     w0, [fp, solve.a]
        ldr     w1, [fp, solve.b]
        bl      _gcd

        ldr     w1, [fp, solve.a]
        ldr     w2, [fp, solve.b] 
        mul     x1, x1, x2
        udiv    x1, x1, x0

        stp     x0, x1, [sp]
        adr     x0, print$ans
        bl      _printf

        mov     x0, #0

got_eof:
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret

_gcd:   // gcd(a, b) = a if b == 0 else gcd(b, a % b)
        // a % b = a - (a / b) * b
        cbz     x1,  done_gcd
        udiv    x2, x0, x1 // x2 = x0 / x1
        msub    x2, x1, x2, x0 // x2 = x0 - x1 * x2
        mov     x0, x1
        mov     x1, x2
        b       _gcd
done_gcd:
        ret
