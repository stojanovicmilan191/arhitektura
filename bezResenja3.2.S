# aritmeticka sredina niza
.section .data
    NELEM = 9
    niz1: .long 1, 2, 3, 4, 5, 6, 7, 8, 9
    niz2: .long 9, 8, 7, 6, 5, 4, 3, 2, 1
    niz3: .fill 9, 4, 0
    suma: .long 0
.section .text
.globl main
main:
    movl $NELEM, %ecx # brojacki registar
    movl $niz1, %esi # bazni registar za niz1
    movl $niz2, %edi # bazni registar za niz2
    movl $niz3, %edx # bazni registar za niz2
    movl $0, %eax
    jmp petlja
smanji:
    decl %ecx
    movl $0, %eax
petlja:
    cmpl $0, %ecx
    jl kraj
    addl (%esi, %ecx, 4), %eax # dodavanje i-tog elemenata iz niza1 u registar eax
    addl (%edi, %ecx, 4), %eax # dodavanje i-tog elemenata iz niza2 u registar eax
    movl %eax, (%edx, %ecx, 4)
    jmp smanji
kraj:
    movl $1, %eax
    movl $0, %ebx
    int $0x80