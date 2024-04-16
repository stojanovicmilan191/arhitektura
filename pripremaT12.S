.section .data
    input_msg: .ascii "Unesite string: \0"
    input_length = . - input_msg
    output_msg: .ascii "Izlaz: \0"
    output_length = . - output_msg
    max_len = 30
    string: .fill 30, 1, 42
    string_len: .long 0
.section .text
.globl main
main:
    movl $4, %eax
    movl $1, %ebx
    movl $input_msg, %ecx
    movl $input_length, %edx
    int $0x80

    movl $3, %eax
    movl $0, %ebx
    movl $string, %ecx
    movl $30, %edx
    int $0x80

    movl %eax, string_len
    movl $string, %ebp
    movl $0, %esi
    movl $0, %edi
    movl $0, %ecx
reset:
    movl %ecx, %esi
    movl $0, %edi
    decl string_len
petlja:
    cmpl string_len, %esi
    je kraj

    movl %esi, %ecx
    movl (%ebp, %esi, 1), %eax
    cmpb $'i', (%ebp, %esi, 1)
    je obrni

    incl %esi
    jmp petlja
obrni:
    cmpl %edi, %esi
    jna izbaci

    movb (%ebp, %esi, 1), %al
    movb (%ebp, %edi, 1), %bl

    movb %al, (%ebp, %edi, 1)
    movb %bl, (%ebp, %esi, 1)

    incl %edi
    decl %esi
    jmp obrni
izbaci:
    movl $0, %edi
nastavak:
    cmpl string_len, %edi
    je reset

    incl %edi
    movb (%ebp, %edi, 1), %al
    decl %edi
    movb %al, (%ebp, %edi, 1)
    incl %edi
    jmp nastavak
kraj:
    movl $4, %eax
    movl $1, %ebx
    movl $output_msg, %ecx
    movl $output_length, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $string, %ecx
    movl string_len, %edx
    int $0x80

    movl $1, %eax
    movl $0, %ebx
    int $0x80
