// Created by Ayush Biswas at 2025/09/08 23:59
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0010
        .global     _main

        .text
scan$t:         .asciz  "%ld"
scan$point:     .asciz  "%lf %lf"
print$point:    .asciz  "%.3f %.3f "
print$distance: .asciz  "%.3f\n"
                .align 2

Point:  
        point.x        = 0
        point.y        = point.x + 8
        point.size     = point.y + 8

Line:
        line.a          = 0
        line.b          = line.a + 8
        line.c          = line.b + 8
        line.size       = line.c + 8

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


_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #64

        solve.p1        = -8
        solve.p2        = solve.p1 - 8
        solve.p3        = solve.p2 - 8
        solve.line1     = solve.p3 - 8
        solve.line2     = solve.line1 - 8
        solve.center    = solve.line2 - 8

        // read 3 points
        bl      _read_point
        str     x0, [fp, solve.p1]
        bl      _read_point
        str     x0, [fp, solve.p2]
        bl      _read_point
        str     x0, [fp, solve.p3]

        // compute bisector of any two pairs
        ldr     x0, [fp, solve.p1]
        ldr     x1, [fp, solve.p2]
        bl      _bisector
        str     x0, [fp, solve.line1]

        ldr     x0, [fp, solve.p2]
        ldr     x1, [fp, solve.p3]
        bl      _bisector
        str     x0, [fp, solve.line2]

        // their intersection is the center of the circle
        ldr     x0, [fp, solve.line1]
        ldr     x1, [fp, solve.line2]
        bl      _intersection   // compute intersection of line1 and line2
        str     x0, [fp, solve.center]

        ldr     d0, [x0, point.x]
        ldr     d1, [x0, point.y]
        stp     d1, d0, [sp]
        adr     x0, print$point
        bl      _printf
        
        ldr     x0, [fp, solve.center]
        ldr     x1, [fp, solve.p1]
        bl      _point_distance
        str     d0, [sp]
        adr     x0, print$distance
        bl      _printf

        ldr     x0, [fp, solve.p1]
        bl      _free
        ldr     x0, [fp, solve.p2]
        bl      _free
        ldr     x0, [fp, solve.p3]
        bl      _free
        ldr     x0, [fp, solve.line1]
        bl      _free
        ldr     x0, [fp, solve.line2]
        bl      _free
        ldr     x0, [fp, solve.center]
        bl      _free

        add     sp, sp, #64
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
        
        ldr     x0, [fp, read_point.pt]

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
function point_distance
        computes distances between two points
*/
_point_distance:
        stp     fp, lr, [sp, #-16]!
        ldr     d0, [x0, point.x]
        ldr     d1, [x0, point.y]
        ldr     d2, [x1, point.x]
        ldr     d3, [x1, point.y]
        fsub    d2, d2, d0
        fsub    d3, d3, d1
        fmul    d2, d2, d2
        fmul    d3, d3, d3
        fadd    d0, d2, d3
        bl      _sqrt
        ldp     fp, lr, [sp], #16
        ret

/*
function new_line
        allocate memory for a line on the heap
*/
_new_line:
        stp     fp, lr, [sp, #-16]!
        mov     x0, line.size
        bl      _malloc
        ldp     fp, lr, [sp], #16
        ret
        

/*
function bisector
        computes perpendicular bisecter of two points
*/
_bisector:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #16

        // arguments
        perpendicular.p1 .req x0
        perpendicular.p2 .req x1

        stp     x0, x1, [sp]
        perpendicular.res .req x9
        bl      _new_line
        mov     perpendicular.res, x0
        ldp     x0, x1, [sp]

        fmov    d4, #2.0
        fmov    d7, #0.0 // (x2^2-x1^2) + (y2^2-y1^2)
        ldr     d2, [perpendicular.p1, point.x]
        ldr     d3, [perpendicular.p2, point.x]
        fmul    d5, d2, d2
        fmul    d6, d3, d3
        fsub    d2, d3, d2 // x2 - x1
        fsub    d3, d6, d5 // x2^2 - x1^2
        fmul    d2, d2, d4 // 2 * (x2 - x1)
        fadd    d7, d7, d3 
        str     d2, [perpendicular.res, line.a]
        ldr     d2, [perpendicular.p1, point.y]
        ldr     d3, [perpendicular.p2, point.y]
        fmul    d5, d2, d2
        fmul    d6, d3, d3
        fsub    d2, d3, d2 // y2 - y1
        fsub    d3, d6, d5 // y2^2 - y1^2
        fmul    d2, d2, d4 // 2 * (y2 - y1)
        fadd    d7, d7, d3
        str     d2, [perpendicular.res, line.b]
        str     d7, [perpendicular.res, line.c]

        mov     x0, perpendicular.res

        add     sp, sp, #16
        ldp     fp, lr, [sp], #16
        ret

/*
function instersection
        computes intersection of two lines
        returns intersection point
*/
_intersection:
        stp     fp, lr, [sp, #-16]!
        // arguments
        intersection.l1 .req x0
        intersection.l2 .req x1

        ldr     d0, [intersection.l1, line.a]
        ldr     d1, [intersection.l1, line.b]
        ldr     d2, [intersection.l1, line.c]
        ldr     d3, [intersection.l2, line.a]
        ldr     d4, [intersection.l2, line.b]
        ldr     d5, [intersection.l2, line.c]

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

        // value of x and y
        fdiv    d0, d9, d8
        fdiv    d1, d10, d8

        bl      _new_point
        str     d0, [x0, point.x]
        str     d1, [x0, point.y]

        ldp     fp, lr, [sp], #16
        ret