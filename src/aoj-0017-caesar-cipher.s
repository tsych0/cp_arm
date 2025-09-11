// Created by Ayush Biswas at 2025/09/11 22:17
// https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0017
        .global     _main

        .text

_main:

solve_again:
        bl      _solve
        cbz     x0, solve_again

        mov     x0, #0
        bl      _exit

const.the:      .asciz  "the"
const.this:     .asciz  "this"
const.that:     .asciz  "that"
                .align  2

_solve:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48

        solve.cipher = -8
        solve.ccap   = -16
        solve.cipher_len .req x19
        solve.plain_text .req x20
        solve.shift      .req x21
        str     xzr, [fp, solve.cipher]

        add     x0, fp, solve.cipher
        add     x1, fp, solve.ccap
        adrp    x2, ___stdinp@GOTPAGE
        ldr     x2, [x2, ___stdinp@GOTPAGEOFF]
        ldr     x2, [x2]
        bl      _getline
        mov     solve.cipher_len, x0
        cmp     x0, #0
        blt     eof

        mov     solve.shift, #26

check_next_shift:
        sub     solve.shift, solve.shift, #1

        ldr     x0, [fp, solve.cipher]
        mov     x1, solve.cipher_len
        mov     x2, solve.shift
        bl      _caesar_cipher
        mov     solve.plain_text, x0

        adr     x1, const.the
        bl      _strstr
        cbnz    x0, found_answer
        mov     x0, solve.plain_text
        adr     x1, const.this
        bl      _strstr
        cbnz    x0, found_answer
        mov     x0, solve.plain_text
        adr     x1, const.that
        bl      _strstr
        cbnz    x0, found_answer

        cbnz    solve.shift, check_next_shift
        
found_answer:
        mov     x0, solve.plain_text
        bl      _printf

        mov     x0, #0
eof:
        
        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret

/*
function caesar_cipher(cipher, len, shift) -> plain_text
*/
_caesar_cipher:
        stp     fp, lr, [sp, #-16]!
        mov     fp, sp
        sub     sp, sp, #48
        // local variables
        caesar_cipher.cipher     = -8
        caesar_cipher.len        = -16
        caesar_cipher.shift      = -24
        caesar_cipher.plain_text = -32
        // store the arguments
        str     x0, [fp, caesar_cipher.cipher]
        str     x1, [fp, caesar_cipher.len]
        str     x2, [fp, caesar_cipher.shift]
        // allocate mem for result
        mov     x0, x1
        bl      _malloc
        str     x0, [fp, caesar_cipher.plain_text]
        // load the things for computation
        ldr     x0, [fp, caesar_cipher.cipher]
        ldr     x1, [fp, caesar_cipher.plain_text]
        ldr     x2, [fp, caesar_cipher.len]
        ldr     x3, [fp, caesar_cipher.shift]
        mov     w6, #26 // the base for remainder
decipher_next_char:
        sub     x2, x2, #1
        ldrb    w4, [x0, x2]
        cmp     w4, 'a'
        blt     not_alphabet
        cmp     w4, 'z'
        bgt     not_alphabet
        sub     w4, w4, 'a'
        add     w4, w4, w3
        udiv    w5, w4, w6
        msub    w4, w5, w6, w4
        add     w4, w4, 'a'
not_alphabet:
        strb    w4, [x1, x2]
        cbnz    x2, decipher_next_char

        // return the result
        ldr     x0, [fp, caesar_cipher.plain_text]

        add     sp, sp, #48
        ldp     fp, lr, [sp], #16
        ret