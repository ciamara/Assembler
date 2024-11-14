.686
.model flat
extern __write : PROC
extern __read : PROC

public _main

.data


.code

_main PROC

	push dword PTR 12 ;liczba znakow
	push dword PTR OFFSET input ; adres
	push dword PTR 0; klawiatura
	call __read
	add esp, 12 ; usuni?cie parametrów

	mov eax, 0 ;przeksztalcona liczba, poczatkowa wartosc = 0
	mov ebx, OFFSET input ; adres inputu

pobieraj_znaki:

	mov cl, [ebx] ; pobranie kolejnej cyfry w ascii
	inc ebx ; zwi?kszenie indeksu
	cmp cl,10 ; czy newline
	je byl_enter ; skok, gdy newline
	sub cl, 30H ; ascii do cyfry
	movzx ecx, cl ; wartosc cyfry w ecx
	mul dword PTR dziesiec ;mnozenie poprzedniej wartosci przez 10
	add eax, ecx ; dodanie ostatnio odczytanej cyfry
	jmp pobieraj_znaki ; skok na pocz?tek p?tli

byl_enter:

	;wartosc binarna w eax

	mov ecx, 32                 ; 32 bity
    mov esi, OFFSET wynik      ; buffer

do_binarnej:

    shl eax, 1                  ; przesuniecie w lewo, w CF bit
    jc set_one                  ; jesli CF = 1 to bit jest 1
    mov byte PTR [esi], '0'     ; w innym wypadku 0
    jmp nastepny_bit

set_one:

    mov byte PTR [esi], '1'     ; 1

nastepny_bit:

    inc esi                     ; nastepny bit
    loop do_binarnej      ; dla wszystkich 32 bitow

    mov byte PTR [esi], 0Ah     ; newline

    push dword PTR 33           ; 32bity + newline
    push dword PTR OFFSET wynik ; adres
    push dword PTR 1            ; ekran
    call __write
    add esp, 12                 ; usuniecie parametrow ze stosu

ret
_main ENDP
END