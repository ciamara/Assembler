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
   mov ecx, 8 ; liczba obiegów petli konwersji
   mov esi, 1 ; indeks do zapisu

ptl3hex:
   
    rol eax, 4      ;przesuniecie cykliczne, bity 28-31 przesuna sie na 0-3
    mov ebx, eax ; kopiowanie EAX do EBX
    and ebx, 0000000FH ; zerowanie bitow 31 - 4 rej.EBX
    mov dl, dekoder[ebx] ; pobranie cyfry z tablicy
    mov [edi][esi], dl  ; przeslanie cyfry do obszaru roboczego
    inc esi ;inkrementacja modyfikatora
    loop ptl3hex ; sterowanie petla

    mov byte PTR [edi][0], 10   ;newline przed i po cyfrach
    mov byte PTR [edi][9], 10   ;newline przed i po cyfrach

    ; wyswietlenie przygotowanych cyfr

    push 10 ; 8 cyfr + 2 znaki nowego wiersza
    push edi ; adres obszaru roboczego
    push 1 ; ekran
    call __write
    add esp, 24     ;12 przez 3 pushe argumentow + 12 zarezerwowanych na poczatku programu

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