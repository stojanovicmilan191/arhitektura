# fakrotijal dvostruke preciznosti
.section .data
n:  .long 10
f:  .quad 1
rezultat: .quad 0
greska: .byte 0

.section .text
.globl main
main:
    cmpl $1, n
    jbe kraj
    movl n, %eax
    movl f, %ebx
    movl f + 4, %edx
# Množenje pomoću sabiranja - Ulaz: eax, ebx
mnozi:
    movl $0, %ecx
    movl $0, %esi
mnozi_petlja:
    cmpl $0, %eax
    je fakt_petlja
    addl %ebx, %ecx
    adcl %edx, %esi
    jc prekoracenje
    decl %eax
    jmp mnozi_petlja
# Množenje pomoću sabiranja - Izlaz: ecx
fakt_petlja:
    movl %ecx, f
    movl %esi, f + 4
    movl %ecx, rezultat
    movl %esi, rezultat + 4
    decl n
    jmp main
prekoracenje:
    incb greska
kraj:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
