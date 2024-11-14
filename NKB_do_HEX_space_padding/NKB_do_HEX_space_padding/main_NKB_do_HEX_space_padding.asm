.686
.model flat
extern __write : PROC
extern __read : PROC

public _main

.data

	binarna db 32 dup (0)          ; input liczby binarnej (32bit max)
    dekoder db '0123456789ABCDEF'

.code

wczytaj_EAX PROC

	push ebx
	push esi
	push edi
	push ebp

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
    je koniec
	cmp cl, 0Ah                     ; sprawdzenie newlinea
    je koniec                   ; stop jesli newline
    shl eax, 1                 ; miejsce na nastepny bit
    cmp cl, '1'                ; sprawdzenie czy '1'
    jne skip
    or eax, 1                  ; ustawienie najmlodszej gdy '1'

skip:

    inc esi                    ;nastepny znak
    jmp parsowanie

koniec:

	pop ebp
	pop edi
	pop esi
	pop ebx
	ret
wczytaj_EAX ENDP

wyswietl_EAX_HEX PROC

   push ebx
   push esi
   push edi
   push ebp

   sub esp, 12     ;rezerwacja 12 bajtow na stosie
   mov edi, esp ; adres zarezerwowanego obszaru
   mov ecx, 8 ; liczba obiegow petli konwersji
   mov esi, 1 ; indeks do zapisu
   xor dh, dh ;flaga na wstepne zera

ptl3hex:
   
    rol eax, 4      ;przesuniecie cykliczne, bity 28-31 przesuna sie na 0-3
    mov ebx, eax ; kopiowanie EAX do EBX
    and ebx, 0000000FH ; zerowanie bitow 31 - 4 rej.EBX
    mov dl, dekoder[ebx] ; pobranie cyfry z tablicy
    test bl, bl            ; sprawdzenie, czy nie zaczynamy z zerem
    jnz skip_space         ; jesli nie, nie dodajemy spacji
    cmp dh, 0
    ja skip_space

     ; Jezeli nie by?o jeszcze "waznej" cyfry, dodajemy spacje
    mov dl, ' '            ; ustawiamy spacje
    mov [edi][esi], dl     ; zapisujemy spacje
    inc esi                ; inkrementacja wskaznika
    jmp skip_digit         ; skok do zapisu cyfry

skip_space:

    mov [edi][esi], dl     ; zapis cyfry (0-9 lub A-F)
    inc esi                ; inkrementacja wskaznika
    inc dh

skip_digit:

    loop ptl3hex           ; kontynuujemy petle, az przetworzymy wszystkie 8 cyfr

    mov byte PTR [edi][0], 10    ; newline przed i po cyfrach
    mov byte PTR [edi][9], 10    ; newline przed i po cyfrach

    ; wyswietlenie przygotowanych cyfr

    push 10                  ; 8 cyfr + 2 znaki nowego wiersza
    push edi                 ; adres obszaru roboczego
    push 1                   ; ekran
    call __write
    add esp, 24              ; usuniecie argumentow ze stosu, 12 parametrow + 12 rezerwacji

   pop ebp
   pop edi
   pop esi
   pop ebx
   ret
wyswietl_EAX_HEX ENDP

_main PROC

call wczytaj_EAX
call wyswietl_EAX_HEX

    ret
_main ENDP
END