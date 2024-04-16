.section .data
    vrednost: .quad 0xFFFFFFF00F0FFFFF
    maxBr: .long 0
.section .text
.globl main
main:
    movl vrednost, %eax
    movl vrednost + 4, %ebx

    movl $0, %ecx
    movl $0, %esi
    movl $1, %edi
petlja1:
    cmpl $32, %esi
    je reset

siftuj1:
    incl %esi
    testl %edi, %eax
    jz brojac1
    jnz uporedi1
brojac1:
    incl %ecx
    addl %edi, %edi
    jmp petlja1
uporedi1:
    addl %edi, %edi
    cmpl %ecx, maxBr
    jl dodela1
    jmp petlja1
dodela1:
    movl %ecx, maxBr
    movl $0, %ecx
    jmp petlja1
reset:
    movl $1, %edi
    movl $0, %esi
petlja2:
    cmpl $32, %esi
    je kraj
siftuj2:
    incl %esi
    testl %edi, %ebx
    jz brojac2
    jnz uporedi2
brojac2:
    incl %ecx
    addl %edi, %edi
    jmp petlja2
uporedi2:
    addl %edi, %edi
    cmpl %ecx, maxBr
    jl dodela2
    jmp petlja2
dodela2:
    movl %ecx, maxBr
    movl $0, %ecx
    jmp petlja2
kraj:
    movl $1, %eax
    movl $0, %ebx
    int $0x80