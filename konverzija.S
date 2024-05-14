.section .data
    input_msg: .ascii "Unesite string: \0"
    input_length = . - input_msg
    output_msg: .ascii "Izlaz: \0"
    output_length = . - output_msg
    max_len = 30
    string: .fill 30, 1, 42
    string_len: .long 0
    broj: .long 10
    string_hex: .fill 30, 1, 42
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

    movl $string, %ecx
    movl $broj, %edx

    pushl %ecx # treci
    pushl %edx # drugi
    pushl %eax # prvi
    call string_u_decimal
    addl $12, %esp
    movl $broj, %eax
    movl $string_hex, %ebx
    pushl %ebx
    pushl %eax
    call decimal_u_hex
kraj:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

#########################################################################

string_u_decimal:
    pushl %ebp
    movl %esp, %ebp
    
    # 12(%ebp) adresa rezultata
    # 16(%ebp) adresa stringa

    pushl %esi
    pushl %edi
    pushl %ebx
    movl 16(%ebp), %esi

    movl $0, %edi # greska
    xorl %eax, %eax
    xorl %ebx, %ebx

    movl $10, %ecx
dec_cifra:
    movb (%esi), %bl
    cmpb $10, %bl
    je kraj_dec
    subb $'0', %bl
    mull %ecx
    addl %ebx, %eax
    incl %esi
    jmp dec_cifra
kraj_dec:
    cmpl 16(%ebp), %esi
    jne krajf1
greska:
    incl %edi
krajf1:
    movl 12(%ebp), %edx # adresa rezultata
    movl %eax, (%edx)
    movl %edi, %eax
    
    popl %ebx
    popl %edi
    popl %esi

    movl %ebp, %esp
    popl %ebp
    ret

#########################################################################

decimal_u_hex:
    pushl %ebp
    movl %esp, %ebp
    
    movl 8(%ebp), %edx
    movl (%edx), %eax
    pushl %ebx
    pushl %edi
    movl 12(%ebp), %edi
    movl $16, %ebx
hex_cifra:
    movl $0, %edx
    cmpl $0, %eax
    je krajf2
    divl %ebx
    cmpl $9, %edx
    ja hex
    addl $'0', %edx
    movb %dl, (%edi)
    incl %edi
    jmp hex_cifra
hex:
    addl $'A' - 10, %edx
    movb %dl, (%edi)
    incl %edi
    jmp hex_cifra
krajf2:
    popl %edi
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret
