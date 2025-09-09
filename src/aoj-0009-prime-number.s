// Created by Ayush Biswas at 2025/09/08 18:12
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0009
        .global     _main

        .text
scan$t:         .asciz  "%ld"
        .align 2
_main:
        mov     fp, sp
        sub     sp, sp, #16 // can store upto two quads     

        ldr     x0, =1000000
        bl      _sieve
        mov     x20, x0

solve_again:
        mov     x0, x20
        bl      _solve
        cbz     x0, solve_again

        mov     x0, #0
        bl      _exit

scan$n:         .asciz  "%d"
print$res:      .asciz  "%d\n"

        .align  2
_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.n = -4

        // store seive in is_prime
        solve.is_prime  .req   x4
        mov             solve.is_prime, x0 

        // read n
        adr     x0, scan$n
        add     x1, fp, solve.n
        str     x1, [sp]
        bl      _scanf
        cmp     x0, #1

        mov     x0, #1
        bne     eof_reached

        ldr     w0, [fp, solve.n]
        mov     w1, #0
check_next_value:
        cbz     w0, counting_done
        ldrb    w2, [solve.is_prime, x0]
        add     w1, w1, w2
        sub     w0, w0, #1
        b       check_next_value

counting_done:
        adr     x0, print$res
        str     w1, [sp]
        bl      _printf

        mov     x0, #0
eof_reached:
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret

_sieve: // sieve of eratosthenes
        stp     fp, lr, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        mov     fp, sp

        length  .req    x19
        mov     length, x0

        bl      _malloc

        mov     x1, 1
        mov     x2, length
        bl      _memset

        is_prime        .req x0
        i               .req x1
        j               .req x2

        strb    wzr, [is_prime, #0] // is_prime(0) = false
        strb    wzr, [is_prime, #1] // is_prime(1) = false
        
        mov     i, #0 
next_prime:
        add     i, i, #1
        cmp     i, length
        bge     sieve_completed
        ldrb    w3, [x0, i] // w2 = is_prime(i)
        cbz     w3, next_prime
        mov     j, i    // j = i
next_multiple:
        add     j, j, i
        cmp     j, length
        bge     next_prime
        strb    wzr, [is_prime, j]
        b       next_multiple
sieve_completed:
        ldp     x19, x20, [sp], #16
        ldp     fp, lr, [sp], #16
        ret