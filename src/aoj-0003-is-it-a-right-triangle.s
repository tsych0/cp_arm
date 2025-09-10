// Created by Ayush Biswas at 2025/09/05 18:49
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0003
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

scan$abc:       .asciz  "%d %d %d"
YES:            .asciz  "YES\n"
NO:             .asciz  "NO\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48
        
        solve.a = -4
        solve.b = solve.a - 4
        solve.c = solve.b - 4

        adr     x0, scan$abc
        add     x1, fp, solve.c
        str     x1, [sp]
        add     x1, fp, solve.b
        str     x1, [sp, #8]
        add     x1, fp, solve.a
        str     x1, [sp, #16]
        bl      _scanf

        add     x0, fp, solve.c
        mov     x1, #3
        mov     x2, #4
        adr     x3, _comparator
        bl      _qsort

        ldr     w0, [fp, solve.a]
        ldr     w1, [fp, solve.b]
        ldr     w2, [fp, solve.c]
        
        mul     w0, w0, w0
        mul     w1, w1, w1
        mul     w2, w2, w2
        //      a^2 + b^2
        add     w0, w0, w1
        cmp     w0, w2  // == c^2 ?
        beq     is_right_triangle
        adr     x0, NO
        b       print_res
is_right_triangle:
        adr     x0, YES
print_res:
        bl      _printf
        
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret

_comparator: // int comp(int *x0, int *x1)
        ldr     w2, [x0]        
        ldr     w3, [x1]       
        sub     w0, w3, w2
        ret