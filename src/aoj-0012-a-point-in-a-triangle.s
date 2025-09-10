// Created by Ayush Biswas at 2025/09/10 00:49
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0012
        .global     _main
        .text
Point:  
        point.x        = 0
        point.y        = point.x + 8
        point.size     = point.y + 8

_main:

solve_again:
        bl      _solve
        cbz     x0, solve_again

        mov     x0, #0
        bl      _exit

YES:    .asciz  "YES\n"
NO:     .asciz  "NO\n"
pr$flt: .asciz  "%f\n"
        .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.a = -8
        solve.b = solve.a - 8
        solve.c = solve.b - 8
        solve.p = solve.c - 8

        bl      _read_point
        cbz     x0, eof_solve
        str     x0, [fp, solve.a]
        bl      _read_point
        str     x0, [fp, solve.b]
        bl      _read_point
        str     x0, [fp, solve.c]
        bl      _read_point
        str     x0, [fp, solve.p]

        ldr     x0, [fp, solve.a]
        ldr     x1, [fp, solve.b]
        ldr     x2, [fp, solve.c]
        bl      _area_triangle
        fmov    d10, d0

        ldr     x0, [fp, solve.a]
        ldr     x1, [fp, solve.b]
        ldr     x2, [fp, solve.p]
        bl      _area_triangle
        fmov    d11, d0

        ldr     x0, [fp, solve.a]
        ldr     x1, [fp, solve.p]
        ldr     x2, [fp, solve.c]
        bl      _area_triangle
        fadd    d11, d11, d0
        
        ldr     x0, [fp, solve.p]
        ldr     x1, [fp, solve.b]
        ldr     x2, [fp, solve.c]
        bl      _area_triangle
        fadd    d11, d11, d0

        fsub    d1, d10, d11
        fabs    d1, d1
        ldr     x0, =0x3e1f41fc1e5d5c6e   // bit pattern of 1.0e-9 as a 64-bit integer
        fmov    d2, x0                   // move that bit pattern into d1

        fcmp    d1, d2
        ble     in_triangle
        adr     x0, NO
        b       out_triange
in_triangle:
        adr     x0, YES
out_triange:
        bl      _printf

        ldr     x0, [fp, solve.a]
        bl      _free
        ldr     x0, [fp, solve.b]
        bl      _free
        ldr     x0, [fp, solve.c]
        bl      _free
        ldr     x0, [fp, solve.p]
        bl      _free

        mov     x0, #-1
eof_solve:
        add     x0, x0, #1

        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret

/*
function new_point
        allocate memory for point on the heap
*/
_new_point:
        stp     fp, lr, [sp, #-16]!
        mov     x0, point.size
        bl      _malloc
        ldp     fp, lr, [sp], #16
        ret

scan$point:     .asciz  "%lf %lf"
                .align  2
/* 
function read_point
        reads x, y from stdin
        returns point
*/
_read_point:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #32

        read_point.pt = -8

        bl      _new_point
        str     x0, [fp, read_point.pt]

        add     x1, x0, point.x
        add     x2, x0, point.y
        stp     x2, x1, [sp]
        adr     x0, scan$point
        bl      _scanf
        cmp     x0, #2
        mov     x0, #0
        bne     eof_read_point
        ldr     x0, [fp, read_point.pt]

eof_read_point:
        add     sp, sp, #32
        ldp     fp, lr, [sp], #16
        ret

debug$point:    .asciz  "Point(%.3f, %.3f)\n"
                .align  2
/*
function point
        prints point on stdout
*/
_print_point:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #32

        ldr     d0, [x0, point.x]
        ldr     d1, [x0, point.y]
        stp     d1, d0, [sp]
        adr     x0, debug$point
        bl      _printf

        add     sp, sp, #32
        ldp     fp, lr, [sp], #16
        ret

/*
function area_triangle
        computes area of triangle
        returns  abs(x1*(y2 - y3) + x2*(y3 - y1) + x3*(y1 - y2)) / 2
*/
_area_triangle:
        mov     x3, x2
        mov     x2, x1
        mov     x1, x0

        fmov    d0, #0.0

        ldr     d1, [x1, point.x]
        ldr     d2, [x2, point.y]
        ldr     d3, [x3, point.y]
        fsub    d2, d2, d3
        fmadd   d0, d1, d2, d0

        ldr     d2, [x2, point.x]
        ldr     d1, [x1, point.y]
        ldr     d3, [x3, point.y]
        fsub    d3, d3, d1
        fmadd   d0, d2, d3, d0

        ldr     d3, [x3, point.x]
        ldr     d1, [x1, point.y]
        ldr     d2, [x2, point.y]
        fsub    d1, d1, d2
        fmadd   d0, d3, d1, d0

        fmov    d1, #2.0
        fdiv    d0, d0, d1
        fabs    d0, d0

        ret