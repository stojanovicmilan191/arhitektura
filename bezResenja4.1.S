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

    movl $3, %eax # unos stringa
    movl $0, %ebx
    movl $string, %ecx
    movl $50, %edx
    int $0x80

    movl $0, %esi
    decl %eax # brisemo jedan znak viska
    decl %eax # brisemo znak za novi red 
    movl %eax, string_len # smestamo novu duzinu stringa
    movl $string, %ebp

    movl $0, %eax
    movl $0, %ebx
povecaj: # spoljasnja for petlja za bubble sort
    incl %esi # brojac spoljasnje petlje
    movl $0, %edi # resetovanje brojaca unutrasnje petlje
sort: 
    cmpl string_len, %esi
    je kraj

poredjenje: # unutrasnja for petlja 
    cmpl string_len, %edi
    je povecaj # za slucaj da smo stigli do kraja stringa skacemo na sledecu iteraciju spoljasnje petlje

    movb (%ebp, %edi, 1), %al # trenutni znak iz stringa
    incl %edi
    movb (%ebp, %edi, 1), %bl # naredni znak iz stringa
    decl %edi
    cmpb %bl, %al # za slucaj da je vrednost iz ascii tabele narednog znaka veca od vrednosti trenutnog znaka skoci na zamenu
    jg zamena
    incl %edi # ako nije ispunjen uslov povecamo brojac i skocimo na sledecu iteraciju
    jmp poredjenje
zamena:
    movb %bl, (%ebp, %edi, 1) # smestanje narednog znaka na adresu trenutnog
    incl %edi
    movb %al, (%ebp, %edi, 1) # smestanje trenutnog znaka na adresu sledeceg
    jmp poredjenje
kraj:
    incl string_len
    incl string_len # vracamo znak viska i znak za novi red
    movl $4, %eax
    movl $1, %ebx
    movl $string, %ecx
    movl string_len, %edx
    int $0x80

    movl $1, %eax
    movl $0, %ebx
    int $0x80
