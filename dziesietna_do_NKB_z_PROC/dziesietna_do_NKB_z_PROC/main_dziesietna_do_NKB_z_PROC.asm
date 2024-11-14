.686
.model flat
extern __write : PROC
extern __read : PROC

public _main

.data

    input db 12 dup (?)        ; input
    dziesiec dd 10             ; dziesiec do mnozenia
    wynik db 32 dup (0)        ; output bufor

.code

; wczytanie i wrzucenie do eax
wczytaj_do_EAX PROC

    push ebx
    push esi
    push edi
    push ebp

    push dword PTR 12           ; liczba znaków
    push dword PTR OFFSET input ; adres inputu
    push dword PTR 0            ; klawiatura
    call __read
    add esp, 12                 ; usuni?cie parametrów ze stosu

    mov eax, 0                  ; pocz?tkowa warto?? EAX
    mov ebx, OFFSET input       ; adres inputu

konwertuj_na_dziesietna:

    mov cl, [ebx]               ; pobranie kolejnej cyfry ASCII
    inc ebx                     ; przej?cie do kolejnego znaku
    cmp cl, 10                  ; sprawdzenie, czy znak to newline
    je koniec_konwersji         ; je?li newline, zako?cz p?tl?
    sub cl, 30H                 ; konwersja ASCII na cyfr?
    movzx ecx, cl               ; przeniesienie cyfry do ECX
    mul dword PTR dziesiec      ; pomno?enie EAX przez 10
    add eax, ecx                ; dodanie cyfry do wyniku
    jmp konwertuj_na_dziesietna ; powtórzenie dla kolejnej cyfry

koniec_konwersji:

    pop ebp
    pop edi
    pop esi
    pop ebx
    ret
wczytaj_do_EAX ENDP

_main PROC

    call wczytaj_do_EAX

    ; Konwersja EAX do ci?gu binarnego w ASCII
    mov ecx, 32                 ; liczba bitów do przetworzenia
    mov esi, OFFSET wynik       ; pocz?tek bufora wynik

konwersja_do_bin:

    shl eax, 1                  ; przesuni?cie w lewo, MSB w CF
    jc ustaw_jeden              ; je?li CF = 1, ustaw ASCII '1'
    mov byte PTR [esi], '0'     ; w przeciwnym wypadku ASCII '0'
    jmp nastepny_bit

ustaw_jeden:

    mov byte PTR [esi], '1'     ; ustaw ASCII '1'

nastepny_bit:

    inc esi                     ; przej?cie do kolejnej pozycji w buforze
    loop konwersja_do_bin       ; powtórzenie dla wszystkich 32 bitów

    mov byte PTR [esi], 0Ah     ; znak nowej linii

    push dword PTR 33           ; 32 bity + znak nowej linii
    push dword PTR OFFSET wynik ; adres bufora
    push dword PTR 1            ; deskryptor urz?dzenia (1 dla wyj?cia na ekran)
    call __write
    add esp, 12                 ; usuni?cie parametrów ze stosu

    ret
_main ENDP
END
