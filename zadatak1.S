.section .data
    input_msg: .ascii "Unesite string: \0"
    input_length = . - input_msg
    output_msg: .ascii "Najmanji element unetog niza: \0"
    output_length = . - output_msg
    max_len = 30
    string: .fill 30, 1, 42
    string_len: .long 0
    broj: .long 10
    string_broj: .fill 30, 1, 42
    brojevi: .long 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    min: .long 0
    string_min: .fill 30, 1, 42
    min_length: .long 0
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
    movl $brojevi, %edx
    jmp petlja
korak:
    incl %ecx
petlja:
    cmpb $10, (%ecx)
    je nadji_min

    cmpb $'0', (%ecx)
    jb korak
    cmpb $'9', (%ecx)
    ja korak

    pushl %ecx # drugi
    pushl %edx # prvi
    call string_u_decimal
    addl $8, %esp

    movl %eax, %ecx

    addl $4, %edx
    jmp korak
nadji_min:
    movl $brojevi, %ebx
    movl (%ebx), %eax
    movl %eax, min
petlja_min:
    cmpl %ebx, %edx
    je pretvori_u_string

    movl (%ebx), %eax
    cmpl %eax, min
    ja novi_min

    addl $4, %ebx
    jmp petlja_min
novi_min:
    movl (%ebx), %eax
    movl %eax, min
    addl $4, %ebx
    jmp petlja_min
pretvori_u_string:
    movl $min, %eax
    movl $string_min, %ebx
    pushl %ebx # drugi
    pushl %eax # prvi
    call decimal_u_string
    addl $8, %esp
    movl %eax, min_length
ispis:
    movl $4, %eax
    movl $1, %ebx
    movl $output_msg, %ecx
    movl $output_length, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $string_min, %ecx
    movl min_length, %edx
    int $0x80

kraj:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

################################################################

string_u_decimal:
    pushl %ebp
    movl %esp, %ebp
    
    # 12(%ebp) adresa rezultata
    # 16(%ebp) adresa stringa

    pushl %esi
    pushl %edi
    pushl %ebx
    movl 12(%ebp), %esi

    movl $0, %edi # greska
    xorl %eax, %eax
    xorl %ebx, %ebx

    movl $10, %ecx
dec_cifra:
    movb (%esi), %bl
    cmpb $' ', %bl
    je kraj_dec
    cmpb $10, %bl
    je kraj_dec
    subb $'0', %bl
    mull %ecx
    addl %ebx, %eax
    incl %esi
    jmp dec_cifra
kraj_dec:
    cmpl 12(%ebp), %esi
    jne krajf1
greska:
    incl %edi
krajf1:
    movl 8(%ebp), %edx # adresa rezultata
    movl %eax, (%edx)
    movl %esi, %eax
    
    popl %ebx
    popl %edi
    popl %esi

    movl %ebp, %esp
    popl %ebp
    ret

################################################################

decimal_u_string:
    pushl %ebp
    movl %esp, %ebp
    
    movl 8(%ebp), %edx
    movl (%edx), %eax # broj
    pushl %ebx
    pushl %edi
    movl 12(%ebp), %edi # string
    movl $10, %ebx
cifra:
    movl $0, %edx
    cmpl $0, %eax
    je kraj_stringa
    divl %ebx
    addl $'0', %edx
    movb %dl, (%edi)
    incl %edi
    jmp cifra
kraj_stringa:
    movl $10, (%edi)
    decl %edi
    movl 12(%ebp), %ecx
    movl $0, %ebx
zamena:
    cmpl %ecx, %edi 
    jna duzina

    incl %ebx
    movb (%ecx), %ah
    movb (%edi), %al

    movb %al, (%ecx)
    movb %ah, (%edi)
    decl %edi
    incl %ecx
    jmp zamena
duzina:
    addl %ebx, %ebx
    addl $1, %ebx
    cmpl %ecx, %edi
    jne krajf2
    addl $1, %ebx
krajf2:
    addl %ebx, %ebx
    movl %ebx, %eax
    popl %edi
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret
