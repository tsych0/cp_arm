// Created by Ayush Biswas at 2025/09/05 19:59
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0004
        .global     _main
        .text
_main:
        mov     fp, sp

solve_again:
        bl      _solve
        cbz     x0, solve_again

        mov     x0, #0
        bl      _exit

scan$abcdef:    .asciz  "%ld %ld %ld %ld %ld %ld"
print$floats:   .asciz  "%0.3f %0.3f\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #96
        //      ax + by = c
        //      dx + ey = f
        solve.a = -8
        solve.b = solve.a - 8
        solve.c = solve.b - 8
        solve.d = solve.c - 8
        solve.e = solve.d - 8
        solve.f = solve.e - 8
        // compute return addresses
        add     x1, fp, solve.a
        add     x2, fp, solve.b
        add     x3, fp, solve.c
        add     x4, fp, solve.d
        add     x5, fp, solve.e
        add     x6, fp, solve.f
        // pass the addresses into stack
        adr     x0, scan$abcdef
        stp     x1, x2, [sp]
        stp     x3, x4, [sp, #16]
        stp     x5, x6, [sp, #32]
        bl      _scanf
        cmp     x0, #6
        bne     end_of_file

        // load the value in general registers
        ldp     x1, x0, [fp, solve.b]
        ldp     x3, x2, [fp, solve.d]
        ldp     x5, x4, [fp, solve.f]

        // transfer to double precision registers
        scvtf   d0, x0  // a
        scvtf   d1, x1  // b
        scvtf   d2, x2  // c
        scvtf   d3, x3  // d
        scvtf   d4, x4  // e
        scvtf   d5, x5  // f

        // denominator
        fmul    d6, d4, d0 // ae
        fmul    d7, d3, d1 // bd
        fsub    d8, d6, d7 // ae - bd
        // numerator of x
        fmul    d6, d4, d2 // ec
        fmul    d7, d5, d1 // bf
        fsub    d9, d6, d7 // ec - bf
        // numerator of y
        fmul    d6, d5, d0 // af
        fmul    d7, d3, d2 // dc
        fsub    d10, d6, d7 // af - dc

//      value of x and y
        fdiv    d11, d9, d8
        fdiv    d12, d10, d8

        // d1 = 0.0001
        fmov    d1, #1.0
        fmov    d2, #10.0
        fmul    d2, d2, d2
        fdiv    d1, d1, d2
        fdiv    d1, d1, d2

        // d2 = abs(d11)
        fabs    d2, d11
        fcmp    d2, d1
        bgt     not_zero_1
        fmov    d11, #0.0
not_zero_1:
        // d2 = abs(d12)
        fabs    d2, d12
        fcmp    d2, d1
        bgt     not_zero_2
        fmov    d12, #0.0
not_zero_2:
        adr     x0, print$floats
        stp     d11, d12, [sp]
        bl      _printf

        mov     x0, #0
        b       success

end_of_file:
        mov     x0, #1

success:
        
        add     sp, sp, #96
        ldp     fp, lr, [sp], #16
        ret