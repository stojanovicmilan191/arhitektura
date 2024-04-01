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

    movl $3, %eax # unos prvog stringa
    movl $0, %ebx
    movl $string1, %ecx
    movl $50, %edx
    int $0x80

    decl %eax # brisanje znaka za novi red
    movl %eax, string1_len

    movl $4, %eax
    movl $1, %ebx
    movl $poruka2, %ecx
    movl $poruka2_len, %edx
    int $0x80

    movl $3, %eax # unos drugog stringa
    movl $0, %ebx
    movl $string2, %ecx
    movl $50, %edx
    int $0x80

    decl %eax #brisanje znaka za novi red
    movl %eax, string2_len

    addl string1_len, %eax # dodavanje duzine prvog stringa na duzinu drugog stringa i smestanje u promenjivu koja predstavlja duzinu spojenih stringova
    movl %eax, string3_len
    movl $0, %esi # brojacki registar spojenih stringova
    movl $0, %edi # brojacki registar za string2
    movl $string3, %ebp # bazni registar za spojene stringove tj. adresa pocetka stringa
    movl $string1, %edx # bazni registar za prvi string tj. adresa pocetka stringa
    movl $0, %ebx
spajanje1: # for petlja za smestanje prvog stringa
    cmpl string1_len, %esi
    je nastavak
    
    movb (%edx, %esi, 1), %bl
    movb %bl, (%ebp, %esi, 1) # smestamo bajt po bajt string1 u string3 koji je kombinacija prvog i drugog
    incl %esi
    jmp spajanje1
nastavak: 
    movl $string2, %edx # smestamo drugi string u bazni registar
spajanje2: # for petlja za smestanje drugog stringa
    cmpl string2_len, %edi
    je kraj
    
    movb (%edx, %edi, 1), %bl 
    movb %bl, (%ebp, %esi, 1) # smestamo bajt po bajt string2 u string3 pazimo na to koji brojacki registar koristimo, esi je brojac za string3, edi za string2
    incl %edi 
    incl %esi # moramo povecati oba brojacka registra
    jmp spajanje2
kraj:
    movl $4, %eax # ispis dobijenog stringa
    movl $1, %ebx
    movl $poruka3, %ecx
    movl $poruka3_len, %edx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $string3, %ecx
    movl string3_len, %edx
    int $0x80
