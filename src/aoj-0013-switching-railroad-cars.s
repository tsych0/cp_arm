// Created by Ayush Biswas at 2025/09/10 16:16
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0013
        .global     _main
        .text
_main:

        bl      _solve

        mov     x0, #0
        bl      _exit

read$car:       .asciz  "%d"
print$car:      .asciz  "%d\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.car .req x21
        sub     solve.car, fp, #4

        solve.stack   .req x19
        mov     x0, #101
        bl      _malloc
        mov     solve.stack, x0

        solve.idx     .req x20 
        mov     solve.idx, #0

next_car:
        adr     x0, read$car
        str     solve.car, [sp]
        bl      _scanf
        cmp     x0, #1
        bne     done
        ldrb    w0, [solve.car]
        cbz     x0, pop
push:
        strb    w0, [solve.stack, solve.idx]
        add     solve.idx, solve.idx, #1
        b       next_car
pop:
        sub     solve.idx, solve.idx, #1
        ldrb    w0, [solve.stack, solve.idx]
        str     w0, [sp]
        adr     x0, print$car
        bl      _printf
        b       next_car 
done:
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret
