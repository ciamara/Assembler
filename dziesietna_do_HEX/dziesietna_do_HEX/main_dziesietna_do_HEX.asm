.686
.model flat
extern __write : PROC
extern __read : PROC

public _main

.data
    input db 12 dup (?)        ; input
    dziesiec dd 10
    dekoder db '0123456789ABCDEF'
    wynik db 12 dup (' ')      ; Initialize result buffer with spaces

.code

wczytaj_EAX PROC
    push ebx
    push esi
    push edi
    push ebp

    push dword PTR 12           ; liczba znaków
    push dword PTR OFFSET input ; adres inputu
    push dword PTR 0            ; klawiatura
    call __read
    add esp, 12                 ; usuniecie parametrow ze stosu

    mov eax, 0                  ; poczatkowa wartosc EAX
    mov ebx, OFFSET input       ; adres inputu

pobieraj_znaki:
    mov cl, [ebx]               ; pobranie kolejnej cyfry w ascii
    inc ebx                      ; zwi?kszenie indeksu
    cmp cl, 10                   ; czy newline
    je byl_enter                 ; skok, gdy newline
    sub cl, 30H                  ; ascii do cyfry
    movzx ecx, cl                ; wartosc cyfry w ecx
    mul dword PTR dziesiec       ; mno?enie poprzedniej wartosci przez 10
    add eax, ecx                 ; dodanie ostatnio odczytanej cyfry
    jmp pobieraj_znaki           ; powtórzenie dla kolejnej cyfry

byl_enter:
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

    sub esp, 12     ; rezerwacja 12 bajtow na stosie
    mov edi, esp    ; adres zarezerwowanego obszaru
    mov ecx, 8      ; liczba obiegów p?tli konwersji (8 hex digits)
    mov esi, 1      ; indeks do zapisu
    xor dh, dh    ; flaga na wst?pne zera (czy dodali?my ju? znacz?cy digit)

ptl3hex:
    rol eax, 4      ; przesuni?cie cykliczne, bity 28-31 przesun? si? na 0-3
    mov ebx, eax    ; kopiowanie EAX do EBX
    and ebx, 0000000FH    ; zerowanie bitów 31 - 4 w EBX
    mov dl, dekoder[ebx]   ; pobranie cyfry z tablicy

    test bl, bl     ; sprawdzenie, czy nie zaczynamy z zerem
    jnz skip_space  ; je?li nie, nie dodajemy spacji
    cmp dh, 0
    ja skip_space


    ; Je?li nie by?o jeszcze "wa?nej" cyfry, dodajemy spacj?
    mov dl, ' '           ; ustawiamy spacj?
    mov [edi + esi], dl   ; zapisujemy spacj?
    inc esi               ; inkrementacja wska?nika
    jmp skip_digit        ; skok do zapisu cyfry

skip_space:
    ; Wstawiamy digit (0-9 lub A-F)
    mov [edi + esi], dl
    inc esi               ; inkrementacja wska?nika
    inc dh

skip_digit:
    loop ptl3hex           ; kontynuujemy p?tl?, a? przetworzymy wszystkie 8 cyfr

    mov byte PTR [edi], 10    ; newline przed cyframi
    mov byte PTR [edi + 9], 10    ; newline po cyfrze

    ; Wyswietlenie przygotowanych cyfr
    push 10                  ; 8 cyfr + 2 znaki nowego wiersza
    push edi                 ; adres obszaru roboczego
    push 1                   ; ekran
    call __write
    add esp, 24              ; usuni?cie argumentów ze stosu, 12 parametrów + 12 rezerwacji

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
