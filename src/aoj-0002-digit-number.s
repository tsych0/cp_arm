// Created by Ayush Biswas at 2025/09/05 17:34
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0002
        .global     _main

        .text
        .align 2
_main:

solve_again:
        bl      _solve
        cbz     x0, solve_again

        mov     x0, #0
        bl      _exit

scan$ab:        .asciz  "%ld %ld"
print$int:      .asciz  "%d\n" 
        .align  2
_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.a = -8
        solve.b = solve.a - 8
read_a_and_b:
        adr     x0, scan$ab
        add     x1, fp, solve.b
        str     x1, [sp]
        add     x1, fp, solve.a
        str     x1, [sp, #8]
        bl      _scanf
        cmp     x0, #2
        bne     end_of_file
compute_the_result:
        ldr     x0, [fp, solve.a]
        ldr     x1, [fp, solve.b]
        // need to count the number of digits in a + b
        add     x0, x0, x1
        mov     w2, #0
        mov     x1, #10
go_for_next_digit:
        udiv    x0, x0, x1
        add     w2, w2, 1
        cbnz    x0, go_for_next_digit

        adr     x0, print$int
        str     w2, [sp]
        bl      _printf
        
        mov     x0, #0
        b       success
end_of_file:
        mov     x0, #1
success:
         
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret