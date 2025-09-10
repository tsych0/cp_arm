// Created by Ayush Biswas at 2025/09/08 20:56
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0008
        .global     _main
        .text
_main:

solve_again:
        bl      _solve
        cbz     x0, solve_again

        mov     x0, #0
        bl      _exit

scan$n:         .asciz  "%d"
print$res:      .asciz  "%d\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.n = -8
        // read n
        adr     x0, scan$n
        add     x1, fp, solve.n
        str     x1, [sp]
        bl      _scanf
        cmp     x0, #1
        mov     x0, #1
        bne     eof_reached

        ldr     w0, [fp, solve.n]

        // tracking result in x7
        mov     x7, #0

        mov     x6, #10
f6:     
        subs    x6, x6, #1
        blt     done_with_loops
        mov     x5, #10
        f5:
                subs    x5, x5, #1
                blt     f6
                mov     x4, #10
                f4:     
                        subs    x4, x4, #1
                        blt     f5
                        mov     x3, #10
                        f3:     
                                subs    x3, x3, #1
                                blt     f4
                                add     x1, x3, x4
                                add     x2, x5, x6
                                add     x1, x1, x2
                                cmp     x0, x1
                                cset    x9, eq
                                add     x7, x7, x9
                                b       f3
done_with_loops:

        str     w7, [sp]
        adr     x0, print$res
        bl      _printf

        mov     x0, #0  // success

eof_reached:
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret