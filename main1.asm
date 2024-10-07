.686
.model flat

extern _MessageBoxA@16 :PROC
extern _ExitProcess@4 :PROC

.data

text db 'Do you like computer architecture?', 0
title db 'Question', 0


.code

_main PROC

	push 4 
	push OFFSET title
	push OFFSET text
	push NULL

	call _MessageBoxA@16

	push NULL
	call _ExitProcess@4

_main ENDP


END