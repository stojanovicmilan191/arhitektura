# Student: 
.section .data
    poruka_unos: .ascii "Unesite namirnice:\n"
    unos_len = . - poruka_unos
    poruka_greska: .ascii "Pogresna oznaka makro-nutrijenta.\n"
    greska_len = . - poruka_greska
    poruka_kalorije: .ascii "Ukupno kalorija: "
    kalorije_poruka_len = . - poruka_kalorije
    poruka_p: .ascii "Protein: "
    poruka_p_len = . - poruka_p
    poruka_c: .ascii "Ugljenih-hidrati: "
    poruka_c_len = . - poruka_c
    poruka_f: .ascii "Masti: "
    poruka_f_len = . - poruka_f
    MAX_LEN = 1000
    unos: .fill MAX_LEN, 1, 42
    proteini: .long 0
    hidrati: .long 0
    masti: .long 0
    kalorije: .long 0
    greska: .long 0
    kalorije_string: .fill 5, 1, 42
    kalorije_len: .long 0
    proteini_string: .fill 5, 1, 42
    proteini_len: .long 0
    hidrati_string: .fill 5, 1, 42
    hidrati_len: .long 0
    masti_string: .fill 5, 1, 42
    masti_len: .long 0
    pomocna: .long 1
.section .text
.globl main
main:
	movl $4, %eax
    	movl $1, %ebx
   	movl $poruka_unos, %ecx
	movl $unos_len, %edx
   	int $0x80

    	movl $3, %eax
    	movl $0, %ebx
   	movl $unos, %ecx
    	movl $MAX_LEN, %edx
    	int $0x80
    	
    	movl $unos, %esi
petlja:
	cmpb $10, (%esi)
	je racunaj_kalorije
	
	cmpb $' ', (%esi)
	je nutrijenti
	
	incl %esi
	jmp petlja
nutrijenti:
	incl %esi
	incl %esi
	cmpb $'-', (%esi)
	jne petlja
	decl %esi
	cmpb $'P', (%esi)
	je unos_proteini
	
	cmpb $'C', (%esi)
	je unos_hidrati
	
	cmpb $'F', (%esi)
	je unos_masti
	
	incl greska
	jmp proveri_gresku

unos_proteini:
	incl greska
	cmpl $1, pomocna
	jne proveri_gresku
	decl greska
	movl $2, pomocna
	addl $2, %esi
	movl $proteini, %eax
	movb $' ', %cl
	pushl %ecx # drugi, separator
	pushl %eax # prvi, adresa niza
	call konverzija_u_interni
	addl $8, %esp
	jmp petlja
unos_hidrati:
	incl greska
	cmpl $2, pomocna
	jne proveri_gresku
	decl greska
	movl $3, pomocna
	addl $2, %esi
	movl $hidrati, %eax
	movb $' ', %cl
	pushl %ecx # drugi, separator
	pushl %eax # prvi, adresa niza
	call konverzija_u_interni
	addl $8, %esp
	jmp petlja
unos_masti:
	incl greska
	cmpl $3, pomocna
	jne proveri_gresku
	decl greska
	movl $1, pomocna
	addl $2, %esi
	movl $masti, %eax
	movb $',', %cl
	pushl %ecx # drugi, separator
	pushl %eax # prvi, adresa niza
	call konverzija_u_interni
	addl $8, %esp
	jmp petlja
racunaj_kalorije:
	movl proteini, %eax
	movl $4, %ebx
	mull %ebx
	
	addl %eax, kalorije
	
	movl hidrati, %eax
	movl $4, %ebx
	mull %ebx
	
	addl %eax, kalorije
	
	movl masti, %eax
	movl $9, %ebx
	mull %ebx
	
	addl %eax, kalorije

proveri_gresku:
	cmpl $0, greska
	je ispisi_kalorije
	
	movl $4, %eax
    	movl $1, %ebx
    	movl $poruka_greska, %ecx
    	movl $greska_len, %edx
    	int $0x80
    	jmp kraj
ispisi_kalorije:
	movl $kalorije, %eax
    	movl $kalorije_string, %ebx
    	pushl %ebx # drugi
    	pushl %eax # prvi
    	call decimal_u_string
    	addl $8, %esp
    	movl %eax, kalorije_len
    	
    	movl $4, %eax
    	movl $1, %ebx
    	movl $poruka_kalorije, %ecx
    	movl $kalorije_poruka_len, %edx
    	int $0x80
    	
    	movl $kalorije_string, %eax
    	movl kalorije_len, %ebx
    	movl kalorije_len, %edx
    	addl %ebx, %eax
    	movl $10, (%eax)
    	incl %edx
    	
    	movl $4, %eax
    	movl $1, %ebx
    	movl $kalorije_string, %ecx
    	int $0x80
ispis_proteini:
	movl $proteini, %eax
    	movl $proteini_string, %ebx
    	pushl %ebx # drugi
    	pushl %eax # prvi
    	call decimal_u_string
    	addl $8, %esp
    	movl %eax, proteini_len
    	
    	movl $4, %eax
    	movl $1, %ebx
    	movl $poruka_p, %ecx
    	movl $poruka_p_len, %edx
    	int $0x80
    	
    	movl $proteini_string, %eax
    	movl proteini_len, %ebx
    	movl proteini_len, %edx
    	addl %ebx, %eax
    	movl $'g', (%eax)
    	incl %eax
    	movl $10, (%eax)
    	incl %edx
    	incl %edx
    	
    	movl $4, %eax
    	movl $1, %ebx
    	movl $proteini_string, %ecx
    	int $0x80
ispis_hidrati:
	movl $hidrati, %eax
    	movl $hidrati_string, %ebx
    	pushl %ebx # drugi
    	pushl %eax # prvi
    	call decimal_u_string
    	addl $8, %esp
    	movl %eax, hidrati_len
    	
    	movl $4, %eax
    	movl $1, %ebx
    	movl $poruka_c, %ecx
    	movl $poruka_c_len, %edx
    	int $0x80
    	
    	movl $hidrati_string, %eax
    	movl hidrati_len, %ebx
    	movl hidrati_len, %edx
    	addl %ebx, %eax
    	movl $'g', (%eax)
    	incl %eax
    	movl $10, (%eax)
    	incl %edx
    	incl %edx
    	
    	movl $4, %eax
    	movl $1, %ebx
    	movl $hidrati_string, %ecx
    	int $0x80
ispis_masti:
	movl $masti, %eax
    	movl $masti_string, %ebx
    	pushl %ebx # drugi
    	pushl %eax # prvi
    	call decimal_u_string
    	addl $8, %esp
    	movl %eax, masti_len
    	
    	movl $4, %eax
    	movl $1, %ebx
    	movl $poruka_f, %ecx
    	movl $poruka_f_len, %edx
    	int $0x80
    	
    	movl $masti_string, %eax
    	movl masti_len, %ebx
    	movl masti_len, %edx
    	addl %ebx, %eax
    	movl $'g', (%eax)
    	incl %eax
    	movl $10, (%eax)
    	incl %edx
    	incl %edx
    	
    	movl $4, %eax
    	movl $1, %ebx
    	movl $masti_string, %ecx
    	int $0x80
kraj:
	movl $1, %eax
	movl greska, %ebx
	int $0x80
	
########################################################################

konverzija_u_interni:
	pushl %ebp
	movl %esp, %ebp
	
	movl $0, %eax
	movl 12(%ebp), %ecx
	movl $0, %ebx
	movl $10, %edi
dec_cifra:
	movb (%esi), %bl
   	cmpb %cl, %bl
   	je kraj_dec
    	cmpb $10, %bl
    	je kraj_dec
    	subb $'0', %bl
    	mull %edi
    	addl %ebx, %eax
    	incl %esi
    	jmp dec_cifra
kraj_dec:
	movl %eax, %ebx
	movl 8(%ebp), %eax
	addl %ebx, (%eax)
    	popl %eax
    	popl %ecx

    	movl %ebp, %esp
    	popl %ebp
    	ret
    	
########################################################################

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
    	jna duzina_priprema

    	incl %ebx
    	movb (%ecx), %ah
    	movb (%edi), %al

    	movb %al, (%ecx)
    	movb %ah, (%edi)
    	decl %edi
    	incl %ecx
    	jmp zamena
duzina_priprema:
	movl 12(%ebp), %edi # string
	movl $0, %eax
duzina:
    	cmpb $10, (%edi)
    	je krajf2
    	cmpl $4, %eax
    	je krajf2
    	incl %eax
    	incl %edi
    	jmp duzina
krajf2:
    	popl %edi
    	popl %ebx
    	movl %ebp, %esp
    	popl %ebp
    	ret
