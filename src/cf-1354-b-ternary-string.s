// Created by Ayush Biswas at 2025/09/04 14:27
// https://codeforces.com/problemset/problem/1354/B
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

scan$s:         .asciz  "%s"
print$s:        .asciz  "%s"
print$int:      .asciz  "%d "
print$intn:     .asciz  "%d\n"
endl:           .asciz  "\n"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48
        // declare local variables
        solve.s = -8
        solve.head = solve.s - 8
        solve.count = solve.head - 8
        // allocate mem for s
        ldr     x0, =200002
        bl      _malloc
        str     x0, [fp, solve.s]
        // read s
        adr     x0, scan$s
        ldr     x1, [fp, solve.s]
        str     x1, [sp]
        bl      _scanf
        // apply run length encoding on s
        ldr     x0, [fp, solve.s]
        bl      _compress
        str     x0, [fp, solve.head] // head is returned in x0
        str     x1, [fp, solve.count] // count is returned in x1

        mov     w14, #0 // found_solution flag

        ldr     x9, [fp, solve.head]
        ldr     x10, [fp, solve.count]
        ldrb    w11, [x9], #1
        cbz     w11, no_solution
        ldrb    w12, [x9], #1
        cbz     w12, no_solution
        ldrb    w13, [x9], #1
        cbz     w13, no_solution

        ldr     w1, =200002 // x1 = inf
check_next_block:
        ldr     w2, [x10, #4]! // w2 = count[i]
        eor     w15, w11, w12
        eor     w15, w15, w13
        subs    w15, w15, '0'
        bne     almost_done_with_this_block
this_is_triplet:
        mov     w14, #1 // found_solution = true
        cmp     w2, w1
        // don't jump to top because there are more things to do
        bge     almost_done_with_this_block 
        mov     w1, w2 // w1 = w2 (if w2 < w2)
almost_done_with_this_block:
        mov     w11, w12
        mov     w12, w13
        ldrb    w13, [x9], #1
        cbnz    w13, check_next_block

        // check the solved flag
        cbnz    w14, solved

no_solution:
        mov     x1, #0 // result in x1

solved:
        add     x1, x1, x14, lsl #1
        adr     x0, print$intn
        str     w1, [sp]
        bl      _printf

        ldr     x0, [fp, solve.s]
        bl      _free // free s
        ldr     x0, [fp, solve.head]
        bl      _free // free head
        ldr     x0, [fp, solve.count]
        bl      _free // free count
             
        add     sp, sp, #48
        ldp     x19, x20, [sp], #16
        ldp     fp, lr, [sp], #16
        ret

// compress(char* s) -> (char*, int32*)
// Run-Length Encoding compression
_compress:
        stp     fp, lr, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #32
        // declare local variables
        compress.s = -8 // argument s
        compress.head = compress.s - 8
        compress.count = compress.head - 8
        // store the argument in x19
        str     x0, [fp, compress.s]
        // allocate memory for head and count
        ldr     x0, =200002
        bl      _malloc
        str     x0, [fp, compress.head]
        ldr     x0, =200002
        mov     x1, #4
        bl      _calloc
        str     x0, [fp, compress.count]

        ldr     x9,  [fp, compress.s] // x9 = input_string
        ldr     x10, [fp, compress.head] // x10 = head
        ldr     x11, [fp, compress.count] // x11 = count
        // we need this, will increment when we find a new value
        sub     x11, x11, #4

        mov     w12, #0  // previous character
do_for_next_value:
        ldrb    w13, [x9], #1 // current character
        cbz     w13, done_with_compression
        cmp     w12, w13
        bne     got_new_value
same_as_last_value:
        ldr     w14, [x11] // get current count
        add     w14, w14, #1 // increment
        str     w14, [x11] // store it
        b       do_for_next_value
got_new_value:
        mov     w12, w13 // previous = current
        strb    w12, [x10], #1 // store it
        mov     w14, #1 // store 1 in count
        str     w14, [x11, #4]!
        b       do_for_next_value

done_with_compression: // return the values in x0 and x1
        mov     w12, #0
        strb    w12, [x10], #1 // add the null character at end
        ldr     x0, [fp, compress.head]
        ldr     x1, [fp, compress.count]

        add     sp, sp, #32
        ldp     x19, x20, [sp], #16
        ldp     fp, lr, [sp], #16
        ret