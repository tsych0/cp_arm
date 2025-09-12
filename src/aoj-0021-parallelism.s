// Created by Ayush Biswas at 2025/09/12 19:59
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0021
        .global     _main

        .text

Slope:
        slope.numerator  = 0
        slope.denomintor = 8
        slope.size       = 16


scan$t:         .asciz  "%ld"
                .align  2

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

epsillon:       .double 1e-10
YES:            .asciz  "YES\n"
NO:             .asciz  "NO\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.a = -8
        solve.b = -16

        bl      _read_line
        str     x0, [fp, solve.a]
        bl      _read_line
        str     x0, [fp, solve.b]

        ldr     x0, [fp, solve.a]
        ldr     x1, [fp, solve.b]

        ldr     d0, [x0, slope.numerator]
        ldr     d1, [x0, slope.denomintor]
        ldr     d2, [x1, slope.numerator]
        ldr     d3, [x1, slope.denomintor]

        fmul    d4, d2, d1
        fmul    d5, d0, d3

        fsub    d6, d5, d4
        fabs    d6, d6 
        adr     x0, epsillon
        ldr     d7, [x0]
        fcmp     d6, d7
        adr     x1, YES
        adr     x2, NO
        csel    x0, x1, x2, lt
        bl      _printf
        
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret

scan$line:      .asciz  "%lf %lf %lf %lf"
                .align  2

/*
function read_line
        reads four numbers from stdin
        returns the slope of the line
*/
_read_line:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #64

        read_line.x1 = -8
        read_line.y1 = -16
        read_line.x2 = -24
        read_line.y2 = -32
        read_line.res = -40

        adr     x0, scan$line
        add     x1, fp, read_line.x1
        add     x2, fp, read_line.y1
        stp     x1, x2, [sp]
        add     x1, fp, read_line.x2
        add     x2, fp, read_line.y2
        stp     x1, x2, [sp, #16]
        bl      _scanf

        mov     x0, slope.size
        bl      _malloc

        ldr     d2, [fp, read_line.y2]
        ldr     d1, [fp, read_line.y1]
        fsub    d0, d2, d1
        str     d0, [x0, slope.numerator]

        ldr     d2, [fp, read_line.x2]
        ldr     d1, [fp, read_line.x1]
        fsub    d0, d2, d1
        str     d0, [x0, slope.denomintor]

        add     sp, sp, #64
        ldp     fp, lr, [sp], #16
        ret