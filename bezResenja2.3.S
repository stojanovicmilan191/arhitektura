.section .data
    prvi: .quad 0x8000
    drugi: .quad 0x7CE0
    rezultat: .quad 0
    greska: .byte 0
.section .text
.globl main
main:
    movl prvi, %eax
    movl prvi + 4, %ebx
    movl drugi, %ecx
    movl drugi + 4, %edx
oduzimanje:
    sbbl %ecx, %eax
    subl %edx, %ebx
kraj:
    movl %eax, rezultat
    movl %ebx, rezultat + 4

    movl $1, %eax
    movl $0, %ebx
    int $0x80