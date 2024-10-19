.686
.model flat


extern _MessageBoxA@16 : PROC
extern _ExitProcess@4 : PROC
.code

_main PROC
	 
	 ;MBox( HWND,"fd","df",UTYPE)
	 push 4   ; UTYPE
	 push OFFSET tytul
	 push OFFSET tekst
	 push  0   ; HWND
	 call _MessageBoxA@16

	 push 0
	 call _ExitProcess@4

_main ENDP


.data
 poczatek db 123
 tekst db 'Czy lubisz AKO?',0
 tytul db  'Pytanie',0


END
