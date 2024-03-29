.section .data
    NELEM = 9
    niz: .long 1, 9, 9, 1, 2, 9, 1, 1, 9
    minIndex: .fill 9, 4, -1
    maxIndex: .fill 9, 4, -1
    min: .long 0
    max: .long 0
.section .text
.globl main
main:
    movl $NELEM - 1, %ecx # brojacki registar
    movl $niz, %esi # bazni registar za niz
    movl $0, %eax
    movl $0, %ebx
    movl (%esi, %ecx, 4), %edi # prvi element smestamo u registar edi u kom cemo izracunati min
    movl (%esi, %ecx, 4), %edx # prvi element smestamo u registar edx u kom cemo izracunati max
    jmp pronadjiMinIMax
smanji1:
    decl %ecx
pronadjiMinIMax:
    cmpl $0, %ecx
    jl reset
    cmpl %edi, (%esi, %ecx, 4) # proveravamo da li je trenutni element manji od minimuma
    jna pronadjenMin
    cmpl %edx, (%esi, %ecx, 4) # proveravamo da li je trenutni element veci od maksimuma
    ja pronadjenMax
    jmp smanji1
pronadjenMin:
    movl (%esi, %ecx, 4), %edi 
    jmp smanji1
pronadjenMax:
    movl (%esi, %ecx, 4), %edx
    jmp smanji1
reset:
    movl $NELEM, %ecx # brojacki registar
    movl %edi, %eax # eax sadrzi vrednost najmanjeg elementa
    movl %edx, %ebx # ebx sadrzi vrednost najveceg elementa
    movl $minIndex, %edi # bazni registar za niz minimalnih indeksa
    movl $maxIndex, %edx # bazni registar za niz maksimalnih indeksa
smanji2:
    decl %ecx
smestanjeIndexa:
    cmpl $0, %ecx
    jl kraj
    cmpl %eax, (%esi, %ecx, 4) # proveravamo da li smo naisli na minimum
    je upisMin
    cmpl %ebx, (%esi, %ecx, 4) # proveravamo da li smo naisli na maksimum
    je upisMax
    jmp smanji2
upisMin:
    movl %ecx, (%edi)
    addl $4, %edi # nakon sto smo u prethodnom redu smestili indeks u niz pomeramo se na sledece mesto u nizu
    jmp smanji2
upisMax:
    movl %ecx, (%edx)
    addl $4, %edx # nakon sto smo u prethodnom redu smestili indeks u niz pomeramo se na sledece mesto u nizu
    jmp smanji2
kraj:
    movl $1, %eax
    movl $0, %ebx
    int $0x80