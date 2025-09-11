// Created by Ayush Biswas at 2025/09/10 20:06
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0015
        .global     _main

        .text
scan$t:         .asciz  "%ld"
                .align 2
_main:
        mov     fp, sp
        sub     sp, sp, #16 // can store upto two quads     

        main.t  = -8

        // Read t
        adr     x0, scan$t
        add     x1, fp, main.t
        str     x1, [sp]
        bl      _scanf

        // load t in x19
        ldr     x19, [fp, main.t]

solve_again:
        bl      _solve
        subs    x19, x19, 1
        bne     solve_again

        mov     x0, #0
        bl      _exit

print$overflow: .asciz  "overflow\n"
print$digit:    .asciz  "%d"
endl:           .asciz  "\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.n         .req x19
        solve.m         .req x20
        solve.res       .req x21
        solve.sum       .req w9
        solve.carry     .req w10


        bl      _read_bigint
        mov     x25, x1
        mov     solve.n, x0
        bl      _read_bigint
        mov     x26, x1
        mov     solve.m, x0

        cmp     x25, #80
        bgt     overflow
        cmp     x26, #80
        bgt     overflow

        mov     x0, #100
        bl      _malloc
        mov     solve.res, x0

        mov     x0, #0
        mov     w5, #10
        mov     solve.carry, #0
next_value:
        ldrb    w1, [solve.n, x0]
        ldrb    w2, [solve.m, x0]
        add     solve.sum, w1, w2
        add     solve.sum, solve.sum, solve.carry
        udiv    solve.carry, solve.sum, w5
        msub    solve.sum, solve.carry, w5, solve.sum
        strb    solve.sum, [solve.res, x0]
        add     x0, x0, #1
        cmp     x0, #100
        blt     next_value

        mov     x0, #100
search_for_start:
        subs    x0, x0, #1
        ble     break
        ldrb    w1, [solve.res, x0]
        cbz     x1, search_for_start
break:
        cmp     x0, #80
        bge     overflow
        mov     x22, x0
print_next_digit:
        adr     x0, print$digit
        ldrb    w1, [solve.res, x22]
        str     w1, [sp]
        bl      _printf
        subs    x22, x22, #1
        bge     print_next_digit

        adr     x0, endl
        bl      _printf

        mov     x0, solve.n
        bl      _free
        mov     x0, solve.m
        bl      _free
        mov     x0, solve.res
        bl      _free

        b       solved

overflow:
        adr     x0, print$overflow
        bl      _printf
solved:
        
        add     sp, sp, #48
        ldp     x19, x20, [sp], #16
        ldp     fp, lr, [sp], #16
        ret

scan$bigint:    .asciz  "%s"
                .align  2

/*
function read_bigint
        reads a big int upto 100 digits
        and stores them in an array of digits
        returns number of digits in x1
*/
_read_bigint:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        read_bigint.string = -8
        read_bigint.size   = read_bigint.string - 8
        read_bigint.res    = read_bigint.size - 8

        mov     x0, #101
        bl      _malloc
        str     x0, [fp, read_bigint.string]

        str     x0, [sp]
        adr     x0, scan$bigint
        bl      _scanf

        ldr     x0, [fp, read_bigint.string]    
        bl      _strlen
        str     x0, [fp, read_bigint.size]

        mov     x0, #100
        mov     x1, #1
        bl      _calloc
        str     x0, [fp, read_bigint.res]

        ldr     x0, [fp, read_bigint.string]
        ldr     x1, [fp, read_bigint.res]
        ldr     x2, [fp, read_bigint.size]
        mov     x3, #0
next_char:
        sub     x2, x2, #1
        ldrb    w4, [x0, x2]
        sub     w4, w4, '0'
        strb    w4, [x1, x3]
        add     x3, x3, #1
        cbnz    x2, next_char

        ldr     x0, [fp, read_bigint.string] 
        bl      _free

        ldr     x0, [fp, read_bigint.res]
        ldr     x1, [fp, read_bigint.size]

        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret