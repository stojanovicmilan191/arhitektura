.section .data
    input_msg: .ascii "Unesite zirafin pritisak: \0"
    input_length = . - input_msg
    output_msg: .ascii "Korekcija: \0"
    output_length = . - output_msg
    string: .fill 30, 1, 42
    pritisak: .long 0, 0
    provera: .long 0x80000000
    ispis: .fill 30, 1, 42
    ispis_length: .long 0
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

    movl $string, %eax
    movl $pritisak, %ebx

    pushl %eax # drugi
    pushl %ebx # prvi
    call konverzija_u_interni
    addl $8, %esp

    movl $pritisak, %ebx
    pushl %ebx
    call proveri_pritisak
    addl $4, %esp

    movl $ispis, %eax
    movl $pritisak, %ebx

    pushl %eax # drugi
    pushl %ebx # prvi
    call konverzija_u_string
    addl $8, %esp
    movl %eax, ispis_length

    movl $4, %eax
    movl $1, %ebx
    movl $ispis, %ecx
    movl ispis_length, %edx
    int $0x80
kraj:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

############################################################

konverzija_u_interni:
    pushl %ebp
    movl %esp, %ebp

    movl 12(%ebp), %esi
    movl $10, %ecx
    xorl %eax, %eax
    xorl %ebx, %ebx
    jmp dec_cifra
sledeci:
    movl 8(%ebp), %edx # adresa rezultata
    movl %eax, (%edx)
    xorl %eax, %eax
    xorl %ebx, %ebx
    xorl %edx, %edx
    addl $4, 8(%ebp)
    incl %esi
dec_cifra:
    movb (%esi), %bl
    cmpb $10, %bl
    je krajf1
    cmpb $'/', %bl
    je sledeci
    subb $'0', %bl
    mull %ecx
    addl %ebx, %eax
    incl %esi
    jmp dec_cifra
krajf1:
    movl 8(%ebp), %edx # adresa rezultata
    movl %eax, (%edx)
    
    popl %ebx
    popl %eax

    movl %ebp, %esp
    popl %ebp
    ret

############################################################

proveri_pritisak:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %ecx
    movl (%ecx), %eax
provera_gornji_240:
    cmpl $240, %eax
    jg provera_gornji_280
    movl $240, %edx
    subl %eax, %edx
    movl %edx, (%ecx)
    addl $4, %ecx
    jmp provera_donji_160
provera_gornji_280:
    cmpl $280, %eax
    jl nula_gornji
    movl $280, %edx
    subl %eax, %edx
    movl %edx, (%ecx)
    addl $4, %ecx
    jmp provera_donji_160
nula_gornji:
    movl $0, (%ecx)
    addl $4, %ecx
provera_donji_160:
    movl (%ecx), %eax
    cmpl $160, %eax
    jg provera_donji_200
    movl $160, %edx
    subl %eax, %edx
    movl %edx, (%ecx)
    jmp krajf2
provera_donji_200:
    cmpl $200, %eax
    jl nula_donji
    movl $200, %edx
    subl %eax, %edx
    movl %edx, (%ecx)
    jmp krajf2
nula_donji:
    movl $0, (%ecx)
    addl $4, %ecx
krajf2:
    popl %ebx

    movl %ebp, %esp
    popl %ebp
    ret

############################################################

konverzija_u_string:
    pushl %ebp
    movl %esp, %ebp

    pushl %edi
    pushl %esi
    pushl %ebx
    movl 8(%ebp), %esi # pritisak
    movl 12(%ebp), %ecx # string
    movl $10, %edi

    movl (%esi), %eax
    cmpl $0, %eax
    jnl pozitivan1
negativan1:
    movb $'-', (%ecx)
    negl %eax
    incl %ecx
    jmp konverzija1
pozitivan1:
    movb $'+', (%ecx)
    incl %ecx
konverzija1:
    movl $0, %edx
    cmpl $0, %eax
    je nastavak
    divl %edi
    addl $'0', %edx
    movb %dl, (%ecx)
    incl %ecx
    jmp konverzija1
nastavak:
    addl $4, %esi
    movl (%esi), %eax
    movb $'/', (%ecx)
    incl %ecx
    cmpl $0, %eax
    jnl pozitivan2
negativan2:
    movb $'-', (%ecx)
    negl %eax
    incl %ecx
    jmp konverzija2
pozitivan2:
    movb $'+', (%ecx)
    incl %ecx
konverzija2:
    movl $0, %edx
    cmpl $0, %eax
    je krajf3
    divl %edi
    addl $'0', %edx
    movb %dl, (%ecx)
    incl %ecx
    jmp konverzija2
krajf3:
    movl %edx, %ecx
    movl $0, %ecx
    subl 8(%ebp), %ecx
    movl %ecx, %eax
    popl %esi
    popl %edi
    movl %ebp, %esp
    popl %ebp
    ret
