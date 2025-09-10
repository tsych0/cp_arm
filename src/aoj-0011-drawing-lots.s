// Created by Ayush Biswas at 2025/09/09 20:15
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0011
        .global     _main
        .text
_main:
        bl      _solve

        mov     x0, #0
        bl      _exit

scan$int:       .asciz  "%d"
scan$2int:      .asciz  "%d,%d"
print$int:      .asciz  "%d\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.w         = -4
        solve.n         = solve.w - 4
        solve.a         = solve.n - 4
        solve.b         = solve.a - 4
        solve.array     = solve.b - 8

        add     x0, fp, solve.w
        str     x0, [sp]
        adr     x0, scan$int
        bl      _scanf

        ldr     w0, [fp, solve.w]
        add     w0, w0, #1
        bl      _malloc
        str     x0, [fp, solve.array]

        ldr     w1, [fp, solve.w]
initialize_next_value:
        strb    w1, [x0, x1]
        subs    w1, w1, #1 
        bne     initialize_next_value

        add     x0, fp, solve.n
        str     x0, [sp]
        adr     x0, scan$int
        bl      _scanf
        ldr     w19, [fp, solve.n]
        ldr     x20, [fp, solve.array]
next_swap:
        adr     x0, scan$2int
        add     x1, fp, solve.a
        add     x2, fp, solve.b
        stp     x2, x1, [sp]
        bl      _scanf
        ldr     w9, [fp, solve.a]
        ldr     w10, [fp, solve.b]
        ldrb    w11, [x20, x9]
        ldrb    w12, [x20, x10]
        strb    w11, [x20, x10]
        strb    w12, [x20, x9]
        subs    x19, x19, #1
        bne     next_swap

        ldr     w19, [fp, solve.w]
        mov     w21, #1
print_next:
        adr     x0, print$int
        ldrb    w1, [x20, x21]
        str     w1, [sp] 
        bl      _printf
        add     w21, w21, #1
        cmp     w21, w19
        ble     print_next

        // free array
        ldr     x0, [fp, solve.array]
        bl      _free
        
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret