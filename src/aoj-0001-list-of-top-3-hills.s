// Created by Ayush Biswas at 2025/09/05 16:38
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0001
        .global     _main
        .text
_main:
        bl      _solve

        mov     x0, #0
        bl      _exit

scan$int:       .asciz  "%d"
print$int:      .asciz  "%d\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48
allocate_memory_for_mountains:
        solve.mountains = -8
        mov     x0, #10
        mov     x1, #4
        bl      _calloc
        str     x0, [fp, solve.mountains]
read_heights_of_mountains:
        mov     x19, #10
        ldr     x20, [fp, solve.mountains]
read_next_value:
        adr     x0, scan$int
        str     x20, [sp] 
        bl      _scanf
        add     x20, x20, #4
        subs    x19, x19, #1
        bne     read_next_value
sort_the_values:
        ldr     x0, [fp, solve.mountains]
        mov     x1, #10
        mov     x2, #4
        adr     x3, _comparator
        bl      _qsort

        mov     x19, #3
        ldr     x20, [fp, solve.mountains]
print_next_value:
        adr     x0, print$int
        ldr     w1, [x20], #4
        str     w1, [sp]
        bl      _printf
        subs    x19, x19, #1
        bne     print_next_value
        
        add     sp, sp, #48
        ldp     x19, x20, [sp], #16
        ldp     fp, lr, [sp], #16
        ret

_comparator:    // comparator for sorting in reverse
        ldr     w2, [x0]
        ldr     w3, [x1]
        sub     w0, w3, w2
        ret