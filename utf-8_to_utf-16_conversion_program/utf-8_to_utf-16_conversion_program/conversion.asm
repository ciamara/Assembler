.686
.model flat

public _main
extern _MessageBoxW@16 : PROC
extern _MessageBoxA@16 : PROC


Comment |
W 48-bajtowej tablicy bufor znajduje siê tekst np. "Po³¹czenia kolejowo – autobusowe"
zakodowany w formacie UTF-8. W tekœcie wystêpuj¹ tak¿e symbole parowozu i autobusu. 
Napisaæ program w asemblerze, który wyœwietli ten tekst na ekranie w postaci komunikatu typu MessageBoxW. 
W poni¿szej tablicy wystêpuj¹ ci¹gi UTF-8  1-, 2-, 3 i 4-bajtowe
| 




.code
_main PROC  

;    push 4	 ; uint MB_YESNO
;	push OFFSET tytul
;	push OFFSET tekst
;	push 0	 ; HWND
;	call _MessageBoxA@16

; konwersja stringa z ASCII na UTF-16
	mov   ah,0
	mov   ecx,48
	mov   esi,0
	mov   edi,0
et:
	mov   al, bufor[esi]
	add  esi,1
	cmp   al,7fh
	ja     znak_wielobajtowy
; konwersja jednobajtowego znaku w utf-8
	;mov   BYTE PTR bufor,al
	;mov   BYTE PTR bufor[1],0
	mov   ah,0
	mov   output[edi],ax
	add   edi,2
	jmp  koniec
znak_wielobajtowy:


koniec:
	loop et


	push 4	 ; uint MB_YESNO
	push OFFSET tytulW
	push OFFSET output
	push 0	 ; HWND
	call _MessageBoxW@16
	nop
_main ENDP


.data
 tekst db  'Czy lubisz AKO?',0
 tytul db  'Pytanie',0

 tekstW db 'Czy lubisz AKO?',0
 tytulW db 'P',0,'y',0,'t',0,'a',0,'n',0,'i',0,'e',0,0,0

 bufor2  dw 16 dup (0)

 ; bufor ze znakami wejœciowymi w utf-8
 bufor	db	50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 61H, 20H 
		db	0F0H, 9FH, 9AH, 82H   ; parowóz
		db	20H, 20H, 6BH, 6FH, 6CH, 65H, 6AH, 6FH, 77H, 6FH, 20H
		db	0E2H, 80H, 93H ; pó³pauza
		db	20H, 61H, 75H, 74H, 6FH, 62H, 75H, 73H, 6FH, 77H, 65H, 20H, 20H
		db	0F0H,  9FH,  9AH,  8CH ; autobus

output  dw 0142h, 0d83dh, 0de82h,0

 napis dw 'AB'
		dw 4142H

 END