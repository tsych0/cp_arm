// Created by Ayush Biswas at 2025/09/11 13:22
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0018
        .global     _main
        .text

_main:
        bl      _solve

        mov     x0, #0
        bl      _exit

scan$int:       .asciz  "%d"
print$int:      .asciz  "%d "
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.idx       .req x19
        solve.array     .req x20
        solve.bitlen    .req x21

        mov     solve.bitlen, #4

        mov     x0, #5
        mov     x1, solve.bitlen
        bl      _calloc
        mov     solve.array, x0

        mov     solve.idx, #5
read_next_number:
        sub     solve.idx, solve.idx, #1
        adr     x0, scan$int
        madd    x1, solve.idx, solve.bitlen , solve.array
        str     x1, [sp]
        bl      _scanf
        cbnz    x19, read_next_number

        mov     x0, solve.array
        mov     x1, #5
        mov     x2, #4
        adr     x3, _comparator
        bl      _qsort

        mov     x19, #0
print_next_number:
        adr     x0, print$int
        ldr     w1, [solve.array, x19, lsl #2]
        str     w1, [sp]
        bl      _printf
        add     x19, x19, #1
        cmp     x19, #5
        blt     print_next_number

        ldr     x0, solve.array
        bl      _free
        
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret

_comparator: // int comp(int *x0, int *x1)
        ldr     w2, [x0]        
        ldr     w3, [x1]       
        sub     w0, w3, w2
        ret