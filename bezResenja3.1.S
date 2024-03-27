# aritmeticka sredina niza
.section .data
    NELEM = 10
    niz: .long 1, 2, 3, 4, 10, 6, 7, 8, 9, 10
    suma: .long 0
.section .text
.globl main
main:
    movl $NELEM, %ecx # brojacki registar
    movl $niz, %esi # bazni registar
    movl $0, %eax
    jmp petlja
smanji:
    decl %ecx
petlja:
    cmpl $0, %ecx
    jl kraj
    addl (%esi, %ecx, 4), %eax # sabiranje elemenata u registar eax
    jmp smanji
kraj:
    addl %eax, suma # priprema registara za deljenje
    movl $0, %edx
    movl $NELEM, %ecx
    divl %ecx # deljenje deli registar eax registrom ecx rezultat smesta u eax a ostatak u edx

    movl $1, %eax
    movl $0, %ebx
    int $0x80