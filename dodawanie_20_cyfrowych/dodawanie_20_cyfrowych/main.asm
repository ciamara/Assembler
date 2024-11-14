.686
.model flat
extern __write : PROC
extern __read : PROC

public _main

.data

    input1 db 21 dup (?) ;input1
    input2 db 21 dup (?) ;input2
    output db 22 dup (?) ;output
    dziesiec dd 10  ; mnoznik


.code

wczytaj_l1 PROC

    push dword PTR 21       ; liczba znaków
    push dword PTR OFFSET input1 ; adres inputu
    push dword PTR 0            ; klawiatura
    call __read
    add esp, 12                 ; usuniecie parametrow ze stosu

    ret
wczytaj_l1 ENDP

wczytaj_l2 PROC

    push dword PTR 21         ; liczba znaków
    push dword PTR OFFSET input2 ; adres inputu
    push dword PTR 0            ; klawiatura
    call __read
    add esp, 12                 ; usuniecie parametrow ze stosu

    ret
wczytaj_l2 ENDP

_main PROC

    call wczytaj_l1
    call wczytaj_l2

    xor ecx, ecx
    mov ecx, 20     ; indeks
    xor ebx, ebx
    mov ebx, 19
    xor edi, edi  ; flaga na przeniesienie

petla:
    
    xor eax, eax
    xor edx, edx
    mov al, input1[ebx]
    add al, input2[ebx]
    sub al, 30H
    
    cmp edi, 1
    jne brak_jedynki
    inc eax
    xor edi, edi

brak_jedynki:

    cmp eax, 10   ;sprawdzam czy mniejsza od 10
    jb brak_przeniesienia
    inc edi     ; ustawiam flage jak przeniesienie
    sub eax, 10


brak_przeniesienia:

    add al, 30H
    mov output[ecx], al

    dec ebx
    loop petla
    
    mov output[21], 10

    push dword PTR 22                ; l znakow
    push dword PTR OFFSET output                ; adres
    push dword PTR 1                 ; ekran
    call __write
    add esp, 12             ; usuniecie parametrow

    ret
_main ENDP
END