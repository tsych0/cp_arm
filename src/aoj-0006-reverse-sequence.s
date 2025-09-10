// Created by Ayush Biswas at 2025/09/08 11:53
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0006
        .global     _main

        .text
scan$s:         .asciz  "%s"
print$t:        .asciz  "%s\n"
                .align 2

_main:
        mov     fp, sp
        sub     sp, sp, #16 // can store upto two quads     

        main.s  = -8
        main.t  = main.s - 8
        // read s
        mov     x0, #21
        bl      _malloc
        str     x0, [fp, main.s]
        str     x0, [sp]
        adr     x0, scan$s
        bl      _scanf
        // allocate memory for t
        mov     x0, #21
        bl      _malloc
        str     x0, [fp, main.t]
        // calculate len(s)
        ldr     x0, [fp, main.s]
        bl      _my_strlen

        mov     x2, x0
        mov     x3, #0
        ldr     x0, [fp, main.s]
        ldr     x1, [fp, main.t]

        ldrb    w4, [x0, x2]
        strb    w4, [x1, x2]
copy_next_character:
        cbz     x2, done_reversing_string
        sub     x2, x2, #1
        ldrb    w4, [x0, x2]
        strb    w4, [x1, x3]
        add     x3, x3, #1
        b       copy_next_character

done_reversing_string:
        adr     x0, print$t
        str     x1, [sp]
        bl      _printf

        mov     x0, #0
        bl      _exit

_my_strlen:
        mov     x1, x0
        mov     x0, #0
count_next_character:
        ldrb    w2, [x1], #1
        cbz     w2, done_strlen
        add     x0, x0, #1
        b       count_next_character
done_strlen:
        ret
