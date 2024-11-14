.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

public _main

.data

	wynik db 14 dup (?)              ; output
	input1 db 14 dup (?)			;liczba1
	input2 db 14 dup (?)			;liczba2
	osiem dd 8 ; mnoznik
	dziesiec dd 10 ;dzielnik

.code

wczytaj_do_eax_oct PROC
	
	push ebx
	push ecx

	push dword PTR 14
	push dword PTR OFFSET input1 ; adres input1
	push dword PTR 0; klawiatura
	call __read 
	add esp, 12 ; usuniecie parametrow ze stosu

	xor eax, eax
	mov ebx, OFFSET input1 ; adres input1

pobieraj_znaki:

	mov cl, [ebx] ; kolejna cyfra ASCII
	
	inc ebx 
	cmp cl,10 ; czy newline
	je byl_enter ; skok gdy newline
	sub cl, 30H ; ASCII na wartosc cyfry
	movzx ecx, cl ; wartosc w ecx
	
	mul dword PTR osiem ;mnozenie przez 8 obliczonej wartosci
	add eax, ecx ; dodanie ostatnio odczytanej cyfry
	jmp pobieraj_znaki ; skok na poczatek petli

byl_enter:
	
	pop ecx
	pop ebx
	ret
wczytaj_do_eax_oct ENDP

wczytaj_do_esi_oct PROC

	push eax
	push ebx
	push ecx

	push dword PTR 14
	push dword PTR OFFSET input2 ; adres input2
	push dword PTR 0; klawiatura
	call __read 
	add esp, 12 ; usuniecie parametrow

	xor esi, esi
	mov ebx, OFFSET input2 ; adres input2

pobieraj_znaki:

	mov cl, [ebx] ; kolejna cyfra ASCII
	inc ebx ; ebx++
	cmp cl,10 ; czy newline
	je byl_enter ; skok gdy newline
	sub cl, 30H ; ASCII -> wartosc cyfry
	movzx ecx, cl ; wartosc do ecx
	
	mul dword PTR osiem	;mnozenie przez 8
	add esi, ecx ; dodanie odczytanej cyfry
	jmp pobieraj_znaki ; skok na poczatek petli

byl_enter:

	pop ecx
	pop ebx
	pop eax
	ret
wczytaj_do_esi_oct ENDP

wyswietl_eax_oct PROC

	push esi
	push ebx
	push edx


	mov esi, 12 ; indeks ,,wynik''
	mov ebx, 8 ; dzielnik równy 8

konwersja:

	mov edx, 0 ; zerowanie starszej czesci dzielnej
	div ebx ; dzielenie przez 8, reszta -> EDX, iloraz -> EAX

	add dl, 30H ;reszta -> ascii
	mov wynik [esi], dl ; zapisanie cyfry ascii
	dec esi
	cmp eax, 0 ; iloraz == 0?
	jne konwersja ; skok gdy /=0

wypeln: ;spacje + newline

	or esi, esi ;czy esi == 0?
	jz wyswietl ; skok, gdy ESI = 0
	mov byte PTR wynik [esi], 20H ; spacja
	dec esi 
	jmp wypeln

wyswietl:

	mov byte PTR wynik [0], 0AH ; newline
	mov byte PTR wynik [13], 0AH ; newline

	push dword PTR 14 ; liczba znakow
	push dword PTR OFFSET wynik ; adres wynik
	push dword PTR 1; ekran
	call __write 
	add esp, 12 ; usuniecie parametrow ze stosu

	pop edx
	pop ebx
	pop esi
	ret
wyswietl_eax_oct ENDP

_main PROC

	call wczytaj_do_eax_oct
	call wczytaj_do_esi_oct

	add eax, esi

	call wyswietl_eax_oct

	push 0
	call _ExitProcess@4

	ret
_main ENDP
END