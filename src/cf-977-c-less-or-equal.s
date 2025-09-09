// Created by Ayush Biswas at 2025/09/03 23:27
// https://codeforces.com/problemset/problem/977/C
        .global     _main

        .text
        .align  2
_main:
        bl      _solve

        mov     x0, #0
        bl      _exit

scan$nk:        .asciz  "%d %d"
scan$ai:        .asciz  "%d"
print$res:      .asciz  "%d\n"

        .align  2
_solve:
        stp fp, lr, [sp, #-16]!
        stp x19, x20, [sp, #-16]!
        mov fp, sp
        sub sp, sp, #32
        // declare local variables
        solve.n = -4
        solve.k = solve.n - 4
        solve.a = solve.k - 8
        // read n and k
        adr     x0, scan$nk
        add     x1, fp, solve.n
        str     x1, [sp]
        add     x1, fp, solve.k
        str     x1, [sp, #8]
        bl      _scanf
        // allocate memory for a
        ldr     w0, [fp, solve.n]
        mov     w1, #4
        bl      _calloc
        str     x0, [fp, solve.a]
        // read a
        ldr     w19, [fp, solve.n]
        ldr     x20, [fp, solve.a]
readAi:
        adr     x0, scan$ai
        str     x20, [sp]
        bl      _scanf
        add     x20, x20, #4
        subs    x19, x19, #1
        bne     readAi
        // sort a
        ldr     x0, [fp, solve.a]
        ldr     w1, [fp, solve.n]
        mov     x2, #4
        adr     x3, _comparator
        bl      _qsort

        ldr     x0, [fp, solve.a]
        ldr     w1, [fp, solve.k]
        ldr     w2, [fp, solve.n]

        cmp     w1, w2
        bne     kLessThanN
        // If k == n then a[n] + 1
        sub     x1, x1, #1
        ldr     w3, [x0, x1, lsl #2]
        add     w1, w3, #1
        b       foundx
        // otherwise a[k] + 1
kLessThanN:
        ldr     w4, [x0, x1, lsl #2]
        sub     x1, x1, #1
        ldr     w3, [x0, x1, lsl #2]
        add     w1, w3, #1
        cmp     w3, w4
        bne     foundx
nox:
        mov     w1, #-1
foundx:
        adr     x0, print$res
        str     w1, [sp]
        bl      _printf

        // free a before exiting
        ldr     x0, [fp, solve.a]
        bl      _free

        // prologue
        add sp, sp, #32
        ldp x19, x20, [sp], #16
        ldp fp, lr, [sp], #16
        ret

_comparator: // int comp(int *x0, int *x1)
        ldr     w2, [x0]        
        ldr     w3, [x1]       
        sub     w0, w2, w3             
        ret