.686
.model flat
extern __write : PROC
extern __read : PROC

public _main

.data

	wynik db 32 dup ('0')              ; output
    newline db 10                      ; newline


.code

wczytaj_do_EAX_HEX PROC

	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

	sub esp, 12 ; rezerwacja stosu
	mov esi, esp ; adres zarezerwowanego obszaru

	push dword PTR 10 ; max ilosc znakow
	push esi ; adres obszaru pamieci
	push dword PTR 0; klawiatura
	call __read 
	add esp, 12 ; usuniecie parametrow ze stosu

	mov eax, 0 ; dotychczas uzyskany wynik
pocz_konw:

	mov dl, [esi] ; pobranie kolejnego bajtu
	inc esi ; inkrementacja indeksu
	cmp dl, 10 ; sprawdzenie czy newline
	je gotowe ; skok do konca podprogramu

	; sprawdzenie czy wprowadzony znak jest cyfra 0, 1, 2 , ..., 9
	cmp dl, '0'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, '9'
	ja sprawdzaj_dalej
	sub dl, '0' ; zamiana kodu ASCII na wartosc cyfry

dopisz:

	shl eax, 4 ; przesuniecie logiczne w lewo o 4 bity
	or al, dl ; dopisanie utworzonego kodu 4-bitowego na 4 ostatnie bity rejestru EAX

	jmp pocz_konw ; skok na poczatek petli konwersji
	; sprawdzenie czy wprowadzony znak jest cyfra A, B, ..., F

sprawdzaj_dalej:

	cmp dl, 'A'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'F'
	ja sprawdzaj_dalej2
	sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
	jmp dopisz
	; sprawdzenie czy wprowadzony znak jest cyfra a, b, ..., f

sprawdzaj_dalej2:

	cmp dl, 'a'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'f'
	ja pocz_konw ; inny znak jest ignorowany
	sub dl, 'a' - 10
	jmp dopisz

gotowe:

	; zwolnienie zarezerwowanego obszaru pamieci
	add esp, 12
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX_HEX ENDP

wyswietl_EAX_NKB PROC
	
	push ebx
    push ecx
    push edx
    push esi

    mov ecx, 32                ; 32 petle
    mov esi, OFFSET wynik      ; poczatek bufora wynik

convert_loop:

    shl eax, 1                 ; najstarszy bit do CF
    jc set_bit                 ; CF
    mov byte ptr [esi], '0'    ; else 0
    jmp next

set_bit:

    mov byte ptr [esi], '1'    ; 1 if CF

next:
    inc esi                    ; nastepna pozycja
    loop convert_loop          ; petla

    push 32                    ; liczba znakow
    push OFFSET wynik          ; adres
    push 1                     ; ekran
    call __write
    add esp, 12                ; czyszczenie stosu

    ; Print newline
    push 1                     ; liczba znakow
    push OFFSET newline        ; adres
    push 1                     ; ekran
    call __write
    add esp, 12                ; czyszczenie stosu

    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
	
wyswietl_EAX_NKB ENDP

_main PROC

	call wczytaj_do_EAX_HEX
	call wyswietl_EAX_NKB

	ret
_main ENDP
END