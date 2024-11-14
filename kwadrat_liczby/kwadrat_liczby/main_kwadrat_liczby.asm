.686
.model flat
extern __write : PROC
extern __read : PROC

public _main

.data

	input db 6 dup (?)	;input
	dziesiec dd 10	    ;mnoznik
    wynik db 16 dup (?) ;wynik

.code

;wczytanie inputu do eax
wczytaj_do_EAX PROC

	push ebx
	push esi
	push edi
	push ebp

	push dword PTR 6            ; 5 cyfr + newline
    push dword PTR OFFSET input ; adres inputu
    push dword PTR 0            ; klawiatura
    call __read
    add esp, 12                 ; usuniecie parametrow ze stosu

    xor eax, eax                ; eax = 0
    mov ebx, OFFSET input       ; adres inputu

konwertuj_na_dziesietna:

    mov cl, [ebx]               ; pobranie kolejnej cyfry ASCII
    inc ebx                     ; przejscie do kolejnego znaku
    cmp cl, 10                  ; sprawdzenie, czy znak to newline
    je koniec_konwersji         ; jesli newline, zakoncz petle
    sub cl, 30H                 ; konwersja ASCII na cyfre
    movzx ecx, cl               ; przeniesienie cyfry do ECX
    mul dword PTR dziesiec      ; pomnozenie EAX przez 10
    add eax, ecx                ; dodanie cyfry do wyniku
    jmp konwertuj_na_dziesietna ; powtorzenie dla kolejnej cyfry

koniec_konwersji:

	pop ebp
	pop edi
	pop esi
	pop ebx
	ret
wczytaj_do_EAX ENDP

;wyswietlenie eax
wyswietl_EAX PROC

	push ebx
	push esi
	push edi
	push ebp

	mov ebx, OFFSET wynik       ; adres bufora wynik
    mov ecx, 10                 ; dzielnik

    ; Konwersja liczby w EAX na ASCII
    add ebx, 16                 ; ustawienie wskaznika na koniec bufora

    xor edx, edx
    
    ; Jezeli EAX == 0, "0"
    test eax, eax
    jz ustaw_zero

konwertuj_cyfry:

    xor edx, edx                ; wyzerowanie edx przed dzieleniem
    div ecx                      ; EAX / 10, wynik w EAX, reszta w EDX
    add dl, '0'                 ; konwersja reszty na ASCII
    dec ebx                     ; przejscie do poprzedniego miejsca w buforze
    mov [ebx], dl               ; zapisanie cyfry
    test eax, eax               ; sprawdzenie, czy wynik dzielenia to 0
    jnz konwertuj_cyfry         ; jesli nie, kontynuuj dzielenie

    jmp koniec_konwersji_ascii

ustaw_zero:

    mov byte PTR [ebx], '0'     ; jesli liczba to 0, zapisujemy "0"

koniec_konwersji_ascii:

    mov byte PTR [ebx-1], 0Ah   ; newline character

    push dword PTR 16          ; liczba znakow
    push dword PTR OFFSET wynik  ; adres
    push dword PTR 1             ; ekran
    call __write
    add esp, 12                  ; usuniecie parametrow ze stosu

	pop ebp
	pop edi
	pop esi
	pop ebx
	ret
wyswietl_EAX ENDP

_main PROC

	call wczytaj_do_EAX

	mov ebx, eax
	mul ebx

	call wyswietl_EAX

	ret
_main ENDP
END