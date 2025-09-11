        .global     _main

        .text

hwStr:  .asciz  "Hello, World!\n"
        .align  2

_main:
        adr    x0, hwStr
        bl      _printf

        mov     x0, #0
        bl      _exit

        .data