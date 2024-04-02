.section .data
.section .text
.globl maska
maska:
    pushl %ebp
    movl %esp, %ebp
    pushl %esi

    movl $1, %eax 
    addl $31, %ecx
    subl 8(%ebp), %ecx
    subl 8(%ebp), %ecx
    movl 12(%ebp), %edx
    movl $0, %esi
upisi1:
    cmpl $31, %esi
    je provera
    
    cmpl %ecx, %esi
    je dodaj0

    shll $1, %eax
    xorl $1, %eax
    incl %esi
    jmp upisi1
dodaj0:
    shll $1, %eax
    incl %esi
    jmp upisi1
provera:
    cmpl $0, %edx
    jne kraj
upisi0:
    notl %eax
kraj:
    movl %ebp, %esp
    popl %esi
    popl %ebp
    ret