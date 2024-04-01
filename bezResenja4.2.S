.section .data
    poruka1: .ascii "Unesite prvi string:\0"
    poruka1_len = . - poruka1
    poruka2: .ascii "Unesite drugi string:\0"
    poruka2_len = . - poruka2
    poruka3: .ascii "Spojeno:\0"
    poruka3_len = . - poruka3
    string1_len: .long 0
    string2_len: .long 0
    string3_len: .long 0
    string1: .fill 50, 1, 42
    string2: .fill 50, 1, 42
    string3: .fill 50, 1, 42
.section .text
.globl main
main:
    movl $4, %eax
    movl $1, %ebx
    movl $poruka1, %ecx
    movl $poruka1_len, %edx
    int $0x80

    movl $3, %eax
    movl $0, %ebx
    movl $string1, %ecx
    movl $50, %edx
    int $0x80

    decl %eax
    movl %eax, string1_len

    movl $4, %eax
    movl $1, %ebx
    movl $poruka2, %ecx
    movl $poruka2_len, %edx
    int $0x80

    movl $3, %eax
    movl $0, %ebx
    movl $string2, %ecx
    movl $50, %edx
    int $0x80

    decl %eax
    movl %eax, string2_len

    addl string1_len, %eax
    movl %eax, string3_len
    movl $0, %esi
    movl $0, %edi
    movl $string3, %ebp
    movl $string1, %edx
    movl $0, %ebx
spajanje1:
    cmpl string1_len, %esi
    je nastavak
    
    movb (%edx, %esi, 1), %bl
    movb %bl, (%ebp, %esi, 1)
    incl %esi
    jmp spajanje1
nastavak:
    movl $string2, %edx
spajanje2:
    cmpl string2_len, %edi
    je kraj
    
    movb (%edx, %edi, 1), %bl
    movb %bl, (%ebp, %esi, 1)
    incl %edi
    incl %esi
    jmp spajanje2
kraj:
    movl $4, %eax
    movl $1, %ebx
    movl $poruka3, %ecx
    movl $poruka3_len, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $string3, %ecx
    movl string3_len, %edx
    int $0x80
