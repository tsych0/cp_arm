// Created by Ayush Biswas at 2025/09/04 09:42
// https://codeforces.com/problemset/problem/1857/C
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

scan$int:       .asciz  "%d"
print$int:      .asciz  "%d "
endl:           .asciz  "\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #32
        // declare local variables
        solve.n = -4      
        solve.a = solve.n - 8
        solve.res = solve.a - 8
        // read n
        adr     x0, scan$int
        add     x1, fp, solve.n
        str     x1, [sp]
        bl      _scanf

        // w19 = n * (n - 1) / 2
        ldr     w9, [fp, solve.n]
        sub     w10, w9, #1
        mul     w19, w9, w10
        asr     w19, w19, #1
        // w19 has the length of a
        mov     w0, w19
        mov     w1, #4
        bl      _calloc
        str     x0, [fp, solve.a]

        // read a
        ldr     x20, [fp, solve.a] // current pointer
        mov     x21, x19 // this many times iterate
read_ai:
        adr     x0, scan$int 
        str     x20, [sp] // pass current pointer
        bl      _scanf // read ai
        add     x20, x20, #4 // next current pointer
        subs    x21, x21, #1 // check for loop ending
        bne     read_ai

        // sort a
        ldr     x0, [fp, solve.a]
        mov     w1, w19 // length of a
        mov     x2, #4
        adr     x3, _comparator
        bl      _qsort

        // initialize res
        ldr     w0, [fp, solve.n]
        mov     w1, #4
        bl      _calloc
        str     x0, [fp, solve.res]

        // the real solution
        ldr     x0, [fp, solve.a]
        ldr     x1, [fp, solve.res]
        ldr     w3, [fp, solve.n]
        mov     w4, #0
next_value:
        ldr     w5, [x0, w4, uxtw #2]
        str     w5, [x1], #4
        sub     w3, w3, #1
        add     w4, w4, w3
        cmp     w3, 1
        bgt     next_value

        // last value can be one greater the previous value
        add     w5, w5, #1
        str     w5, [x1]

        // print the result
        ldr     x19, [fp, solve.res]
        ldr     w20, [fp, solve.n]
print_res:
        adr     x0, print$int
        ldr     w1, [x19], #4
        str     w1, [sp]
        bl      _printf
        subs    w20, w20, #1
        bne     print_res
        adr     x0, endl
        bl      _printf

        // free variables before exiting
        ldr     x0, [fp, solve.a]
        bl      _free
        ldr     x0, [fp, solve.res]
        bl      _free

        // exiting sol
        add     sp, sp, #32
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     fp, lr, [sp], #16
        ret

_comparator: // int comp(int *x0, int *x1)
        ldr     w2, [x0]        
        ldr     w3, [x1]       
        sub     w0, w2, w3             
        ret