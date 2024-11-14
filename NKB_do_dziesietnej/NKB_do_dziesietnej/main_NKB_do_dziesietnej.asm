.686
.model flat
extern __write : PROC
extern __read : PROC

public _main

.data

	binarna db 32 dup (0)          ; input liczby binarnej (32bit max)
	znaki db 12 dup (?) ;przechowanie cyfr dziesietnych

.code

_main PROC

	push dword PTR 32          ; liczba znakow
    push dword PTR OFFSET binarna ; adres
    push dword PTR 0           ; klawiatura
    call __read
    add esp, 12                ; usuniecie parametrow

	mov esi, OFFSET binarna     ; pointer do binarna
    xor eax, eax                 ; czyszczenie eax

parsowanie:

    movzx ecx, byte PTR [esi]  ; nastepny znak
    cmp cl, 0                  ; sprawdzanie czy null
    je do_dziesietnej
	cmp cl, 0Ah                     ; sprawdzenie newlinea
    je do_dziesietnej           ; stop jesli newline
    shl eax, 1                 ; miejsce na nastepny bit
    cmp cl, '1'                ; sprawdzenie czy '1'
    jne skip
    or eax, 1                  ; ustawienie najmlodszej gdy '1'

skip:

    inc esi                    ;nastepny znak
    jmp parsowanie

do_dziesietnej:

	mov esi, 10 ; indeks znaki
	mov ebx, 10 ; dzielnik

konwersja:

	mov edx, 0 ; starsza czesc dzielnej -> 0
	div ebx ; dzielenie, iloraz -> eax, reszta -> edx
	
	add dl, 30H ; reszta -> kod ascii

	mov znaki [esi], dl; zapisanie ascii do znaki

	dec esi ; --indeks
	cmp eax, 0 ; sprawdzenie czy iloraz = 0
	jne konwersja ; skok, gdy iloraz niezerowy

wypeln:

	or esi, esi
	jz wyswietl ; skok, gdy ESI = 0

	mov byte PTR znaki [esi], 20H ; kod spacji

	dec esi ; indeks--

	jmp wypeln

wyswietl:

	mov byte PTR znaki [0], 0AH ; kod nowego wiersza
	mov byte PTR znaki [11], 0AH ; kod nowego wiersza

	push dword PTR 12 ; liczba znaków
	push dword PTR OFFSET znaki ; adres 
	push dword PTR 1; numer urz?dzenia (ekran ma numer 1)
	call __write 
	add esp, 12 ; usuni?cie parametrów ze stosu

	ret
_main ENDP
END