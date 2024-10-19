.686
.model flat

public _main
extern _MessageBoxW@16 : PROC
extern _MessageBoxA@16 : PROC
.code
_main PROC  

    push 4	 ; uint MB_YESNO
	push OFFSET tytul
	push OFFSET tekst
	push 0	 ; HWND
	call _MessageBoxA@16

; konwersja stringa z ASCII na UTF-16
	mov   ah,0
	mov   ecx,16
	mov esi,0
	mov edi,0
et:
	mov   al, tekstW[esi]
	add  esi,1
	;mov   BYTE PTR bufor,al
	;mov   BYTE PTR bufor[1],0
	
	mov   bufor[edi],ax
	add   edi,2

	loop et


	push 4	 ; uint MB_YESNO
	push OFFSET tytulW
	push OFFSET bufor
	push 0	 ; HWND
	call _MessageBoxW@16
	nop
_main ENDP


.data
 tekst db  'Czy lubisz AKO?',0
 tytul db  'Pytanie',0

 tekstW db 'Czy lubisz AKO?',0
 tytulW db 'P',0,'y',0,'t',0,'a',0,'n',0,'i',0,'e',0,0,0

 bufor  dw 16 dup (0)

 napis dw 'AB'
		dw 4142H

 END