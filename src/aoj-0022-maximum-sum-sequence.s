// Created by Ayush Biswas at 2025/09/12 22:00
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0022
        .global     _main

        .text
scan$n:         .asciz  "%ld"
                .align  2

_main:
        mov     fp, sp
        sub     sp, sp, #16 // can store upto two quads     

        main.n  .req x19
        sub     main.n, fp, 8

solve_again:
        adr     x0, scan$n
        str     main.n, [sp]
        bl      _scanf
        ldr     x0, [main.n]
        cbz     x0, done
        bl      _solve
        b       solve_again
done:
        mov     x0, #0
        bl      _exit

scan$ai:        .asciz  "%ld"
print$res:      .asciz  "%ld\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48


        solve.ai        .req x20
        solve.max_sum   .req x21
        solve.curr_sum  .req x22
        solve.n         .req x23

        mov     solve.n, x0

        sub     solve.ai, fp, #8
        ldr     solve.max_sum, =-999999
        mov     solve.curr_sum, #0
        
next_number:
        str     solve.ai, [sp]
        adr     x0, scan$ai
        bl      _scanf

        ldr     x1, [solve.ai]
        add     solve.curr_sum, x1, solve.curr_sum
        cmp     solve.curr_sum, solve.max_sum
        ble     not_more_than_max
        mov     solve.max_sum, solve.curr_sum
not_more_than_max:
        cmp     solve.curr_sum, #0
        bge     already_positive
        mov     solve.curr_sum, #0
already_positive:
        subs    solve.n, solve.n, #1
        bne     next_number

        str     solve.max_sum, [sp]
        adr     x0, print$res
        bl      _printf
        
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret