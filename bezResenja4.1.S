.section .data
    string: .fill 50, 1, 42
    poruka: .ascii "Unesite string:\0"
    poruka_len = . - poruka
    string_len: .long 0
.section .text
.globl main
main:
    movl $4, %eax
    movl $1, %ebx
    movl $poruka, %ecx
    movl $poruka_len, %edx
    int $0x80

    movl $3, %eax
    movl $0, %ebx
    movl $string, %ecx
    movl $50, %edx
    int $0x80

    movl $0, %esi
    decl %eax
    decl %eax
    movl %eax, string_len
    movl $string, %ebp

    movl $0, %eax
    movl $0, %ebx
povecaj:
    incl %esi
    movl $0, %edi
sort:
    cmpl string_len, %esi
    je kraj

poredjenje:
    cmpl string_len, %edi
    je povecaj

    movb (%ebp, %edi, 1), %al
    incl %edi
    movb (%ebp, %edi, 1), %bl
    decl %edi
    cmpb %bl, %al
    jg zamena
    incl %edi
    jmp poredjenje
zamena:
    movb %bl, (%ebp, %edi, 1)
    incl %edi
    movb %al, (%ebp, %edi, 1)
    jmp poredjenje
kraj:
    incl string_len
    incl string_len
    movl $4, %eax
    movl $1, %ebx
    movl $string, %ecx
    movl string_len, %edx
    int $0x80

    movl $1, %eax
    movl $0, %ebx
    int $0x80