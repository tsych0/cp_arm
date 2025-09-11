// Created by Ayush Biswas at 2025/09/10 22:01
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0016
        .global     _main
        .text

_main:
        bl      _solve

        mov     x0, #0
        bl      _exit

scan$dt:        .asciz  "%d, %d"
print$res:      .asciz  "%d\n%d"
print$flt:      .asciz  "%f\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.d  .req x19
        solve.t  .req x20
        solve.r  .req d19
        solve.pi .req d20
        solve.x  .req d21
        solve.y  .req d22
        solve.deg  .req d23
        
        fmov     d0, #-1.0
        bl      _acos
        fmov     solve.pi, d0

        mov     x0, #180
        scvtf   solve.deg, x0  

        fmov   solve.r, #0.0

        fmov    solve.x, #0
        fmov    solve.y, #0

        sub     solve.d, fp, 4
        sub     solve.t, fp, 8

next_step:
        adr     x0, scan$dt
        stp     solve.d, solve.t, [sp]
        bl      _scanf
        ldr     w0, [solve.d]
        cbnz    w0, okay
        ldr     w0, [solve.t]
        cbz     w0, stop
okay:
        fmov    d24, solve.r
        fmul    d24, d24, solve.pi
        fdiv    d24, d24, solve.deg
        ldr     w25, [solve.d]
        // d * cos(r)
        fmov    d0, d24
        bl      _sin
        scvtf   d1, x25
        fmul    d0, d0, d1
        fadd    solve.x, solve.x, d0 
        // d * sin(r)
        fmov    d0, d24
        bl      _cos
        scvtf   d1, x25
        fmul    d0, d0, d1
        fadd    solve.y, solve.y, d0 

        ldr     w0, [solve.t]
        scvtf   d0, w0
        fadd    solve.r, solve.r, d0 

        b       next_step
stop:
        fcvtzs  x1, solve.x
        fcvtzs  x2, solve.y

        stp     x1, x2, [sp]
        adr     x0, print$res
        bl      _printf
        
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret