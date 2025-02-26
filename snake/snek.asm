.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy

snake PROC

    ; przechowanie rejestrow
    push ax
    push bx
    push cx
    push es

    mov ax, 0A000H ; adres pamięci ekranu dla trybu 13H
    mov es, ax

    ; czyszczenie poprzedniego piksela
    mov bx, cs:adres_piksela
    mov al, 0
    mov es:[bx], al
    mov es:[bx+1], al
    mov es:[bx+2], al
    mov es:[bx+320], al
    mov es:[bx+321], al
    mov es:[bx+322], al
    mov es:[bx+640], al
    mov es:[bx+641], al
    mov es:[bx+642], al

    ; zmiana kierunku w zależności od przycisków strzałek
    cmp cs:kierunek, 0
    je ruch_dol
    cmp cs:kierunek, 1
    je ruch_gora
    cmp cs:kierunek, 2
    je ruch_lewo
    cmp cs:kierunek, 3
    je ruch_prawo

    ruch_dol:
    add bx, 320
    cmp bx, 320*200
    jb narysuj
    sub bx, 320*200
    jmp narysuj

    ruch_gora:
    sub bx, 320
    cmp bx, 0
    jge narysuj
    add bx, 320*200
    jmp narysuj

    ruch_lewo:
    sub bx, 3
    cmp bx, 0
    jge narysuj
    add bx, 320
    jmp narysuj

    ruch_prawo:
    add bx, 3
    cmp bx, 320*200
    jb narysuj
    sub bx, 320

    narysuj:

    ; narysowanie nowego piksela 3x3 w kolorze białym
    mov al, 15
    mov es:[bx], al
    mov es:[bx+1], al
    mov es:[bx+2], al
    mov es:[bx+320], al
    mov es:[bx+321], al
    mov es:[bx+322], al
    mov es:[bx+640], al
    mov es:[bx+641], al
    mov es:[bx+642], al

    ; Sprawdzenie, czy biała kropka dotyka czerwonej
    ; Sprawdzenie, czy adres piksela (bx) jest równy red_pixel1 lub red_pixel2
    mov dx, cs:red_pixel1
    cmp bx, dx
    je usun_czerwony1

    mov ax, bx
    add ax, 1
    cmp ax, dx
    je usun_czerwony1

    mov ax, bx
    add ax, 2
    cmp ax, dx
    je usun_czerwony1

    mov ax, bx
    add ax, 320
    cmp ax, dx
    je usun_czerwony1

    mov ax, bx
    add ax, 321
    cmp ax, dx
    je usun_czerwony1

    mov ax, bx
    add ax, 322
    cmp ax, dx
    je usun_czerwony1

    mov ax, bx
    add ax, 640
    cmp ax, dx
    je usun_czerwony1

    mov ax, bx
    add ax, 641
    cmp ax, dx
    je usun_czerwony1

    mov ax, bx
    add ax, 642
    cmp ax, dx
    je usun_czerwony1

    mov dx, cs:red_pixel2
    cmp bx, dx
    je usun_czerwony2

    mov ax, bx
    add ax, 1
    cmp ax, dx
    je usun_czerwony2

    mov ax, bx
    add ax, 2
    cmp ax, dx
    je usun_czerwony2

    mov ax, bx
    add ax, 320
    cmp ax, dx
    je usun_czerwony2

    mov ax, bx
    add ax, 321
    cmp ax, dx
    je usun_czerwony2

    mov ax, bx
    add ax, 322
    cmp ax, dx
    je usun_czerwony2

    mov ax, bx
    add ax, 640
    cmp ax, dx
    je usun_czerwony2

    mov ax, bx
    add ax, 641
    cmp ax, dx
    je usun_czerwony2

    mov ax, bx
    add ax, 642
    cmp ax, dx
    je usun_czerwony2

    mov cs:adres_piksela, bx
    jmp koniec_ruchu

usun_czerwony1:
    ; Zmiana koloru pierwszego czerwonego piksela na czarny (tło)
    mov bx, cs:red_pixel1     ; Załadowanie adresu pierwszego czerwonego piksela do bx
    mov al, 0                 ; Kolor tła (czarny)
    mov es:[bx], al
    mov es:[bx+1], al
    mov es:[bx+2], al
    mov es:[bx+320], al
    mov es:[bx+321], al
    mov es:[bx+322], al
    mov es:[bx+640], al
    mov es:[bx+641], al
    mov es:[bx+642], al
    
    mov cs:red_pixel1_active, 0
    jmp przemiesc_sie

usun_czerwony2:
    ; Zmiana koloru drugiego czerwonego piksela na czarny (tło)
    mov bx, cs:red_pixel2     ; Załadowanie adresu drugiego czerwonego piksela do bx
    mov al, 0                 ; Kolor tła (czarny)
    mov es:[bx], al
    mov es:[bx+1], al
    mov es:[bx+2], al
    mov es:[bx+320], al
    mov es:[bx+321], al
    mov es:[bx+322], al
    mov es:[bx+640], al
    mov es:[bx+641], al
    mov es:[bx+642], al
    
    mov cs:red_pixel2_active, 0
    jmp przemiesc_sie

koniec_ruchu:

przemiesc_sie:
    ; Aktualizacja pozycji piksela w cs:adres_piksela
    mov cs:adres_piksela, bx

    ; Narysowanie nowego piksela po kolizji (kontynuacja ruchu)
    mov al, 15
    mov es:[bx], al
    mov es:[bx+1], al
    mov es:[bx+2], al
    mov es:[bx+320], al
    mov es:[bx+321], al
    mov es:[bx+322], al
    mov es:[bx+640], al
    mov es:[bx+641], al
    mov es:[bx+642], al
    
    ; 2 owoce do zebrania (czerwone)
    cmp cs:red_pixel1_active, 1
    jne brak_pixel1
    push bx
    mov bx, 320 * 50 + 100    
    mov al, 4               
    mov es:[bx], al
    mov es:[bx+1], al
    mov es:[bx+2], al
    mov es:[bx+320], al
    mov es:[bx+321], al
    mov es:[bx+322], al
    mov es:[bx+640], al
    mov es:[bx+641], al
    mov es:[bx+642], al
    mov cs:red_pixel1, bx  ; Zapisz adres pierwszego czerwonego piksela
    pop bx

brak_pixel1:

    cmp cs:red_pixel2_active, 1
    jne brak_pixel2
    push bx
    mov bx, 320 * 150 + 250   
    mov al, 4                
    mov es:[bx], al
    mov es:[bx+1], al
    mov es:[bx+2], al
    mov es:[bx+320], al
    mov es:[bx+321], al
    mov es:[bx+322], al
    mov es:[bx+640], al
    mov es:[bx+641], al
    mov es:[bx+642], al
    mov cs:red_pixel2, bx   ; Zapisz adres drugiego czerwonego piksela
    pop bx

brak_pixel2:

    cmp cs:red_pixel1_active, 1
    je no_cleanup_1

    mov bx, cs:red_pixel1    
    mov al, 0
    mov es:[bx-642], al
    mov es:[bx-641], al
    mov es:[bx-640], al
    mov es:[bx-639], al
    mov es:[bx-638], al
    mov es:[bx-637], al   
    mov es:[bx-322], al                 
    mov es:[bx-321], al
    mov es:[bx-320], al
    mov es:[bx-319], al
    mov es:[bx-318], al
    mov es:[bx-317], al
    mov es:[bx-2], al
    mov es:[bx-1], al
    mov es:[bx], al
    mov es:[bx+1], al
    mov es:[bx+2], al
    mov es:[bx+3], al
    mov es:[bx+318], al
    mov es:[bx+319], al
    mov es:[bx+320], al
    mov es:[bx+321], al
    mov es:[bx+322], al
    mov es:[bx+323], al
    mov es:[bx+638], al
    mov es:[bx+639], al
    mov es:[bx+640], al
    mov es:[bx+641], al
    mov es:[bx+642], al
    mov es:[bx+643], al

no_cleanup_1:

    cmp cs:red_pixel2_active, 1
    je no_cleanup_2

    mov bx, cs:red_pixel2     
    mov al, 0 
    mov es:[bx-642], al
    mov es:[bx-641], al
    mov es:[bx-640], al
    mov es:[bx-639], al
    mov es:[bx-638], al
    mov es:[bx-637], al   
    mov es:[bx-322], al                 
    mov es:[bx-321], al
    mov es:[bx-320], al
    mov es:[bx-319], al
    mov es:[bx-318], al
    mov es:[bx-317], al
    mov es:[bx-2], al
    mov es:[bx-1], al
    mov es:[bx], al
    mov es:[bx+1], al
    mov es:[bx+2], al
    mov es:[bx+3], al
    mov es:[bx+318], al
    mov es:[bx+319], al
    mov es:[bx+320], al
    mov es:[bx+321], al
    mov es:[bx+322], al
    mov es:[bx+323], al
    mov es:[bx+638], al
    mov es:[bx+639], al
    mov es:[bx+640], al
    mov es:[bx+641], al
    mov es:[bx+642], al
    mov es:[bx+643], al

no_cleanup_2:

    ; odtworzenie rejestrow
    pop es
    pop cx
    pop bx
    pop ax

    ; skok do oryginalnego podprogramu obsługi przerwania zegarowego
    jmp dword PTR cs:wektor8

    ; zmienne procedury
    kolor db 15 ; biały kolor
    adres_piksela dw (320 * 100) + 160 ; bieżący adres piksela
    przyrost dw 0
    kierunek db 0 ; 0 = dół, 1 = góra, 2 = lewo, 3 = prawo
    wektor8 dd ?
    red_pixel1 dw 320*50 + 100   
    red_pixel2 dw 320*150 + 250   
    red_pixel1_active db 1
    red_pixel2_active db 1

snake ENDP

zacznij:
    mov ah, 0
    mov al, 13H ; tryb graficzny
    int 10H
    mov bx, 0
    mov es, bx
    mov eax, es:[32]
    mov cs:wektor8, eax

    mov ax, SEG snake
    mov bx, OFFSET snake

    cli
    mov es:[32], bx
    mov es:[32+2], ax
    sti

czekaj:
    mov ah, 1
    int 16h
    jz czekaj
    mov ah, 0
    int 16h
    cmp al, 1Bh ; kod ASCII dla klawisza ESC
    je koniec
    cmp ah, 48h ; strzałka w górę
    je zmien_gora
    cmp ah, 50h ; strzałka w dół
    je zmien_dol
    cmp ah, 4Bh ; strzałka w lewo
    je zmien_lewo
    cmp ah, 4Dh ; strzałka w prawo
    je zmien_prawo
    jmp czekaj

zmien_gora:
    mov cs:kierunek, 1
    jmp czekaj

zmien_dol:
    mov cs:kierunek, 0
    jmp czekaj

zmien_lewo:
    mov cs:kierunek, 2
    jmp czekaj

zmien_prawo:
    mov cs:kierunek, 3
    jmp czekaj

koniec:
    mov ah, 0
    mov al, 3H
    int 10H

    mov eax, cs:wektor8
    mov es:[32], eax

    mov ax, 4C00H
    int 21H

rozkazy ENDS

stosik SEGMENT stack
    db 256 dup (?)
stosik ENDS

END zacznij
