        .global     _main

        .text
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

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret