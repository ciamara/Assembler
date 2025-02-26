.686
.model flat
extern _ExitProcess@4 : PROC
extern _GetLocalTime@4 : PROC

public _swap
public _daj_czas

.data

.code
_swap PROC
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push esi

	mov eax, [ebp+8]		; adres tab[0]
	mov ecx, [ebp+12]		; rozmiar tablicy
	mov edi, [ebp+16]		; 1 miejsce
	mov esi, [ebp+20]		; 2 miejsce

	cmp edi, 0
	jb zwroc_zero_tab
	cmp edi, ecx
	jae zwroc_zero_tab
	cmp esi, 0
	jb zwroc_zero_tab
	cmp esi, ecx
	jae zwroc_zero_tab
	jmp zamien_tab

zwroc_zero_tab:

	mov eax, 0
	jmp koniec_swap

zamien_tab:

	mov ebx, [eax+esi*4]
	mov ecx, [eax+edi*4]

	mov [eax+esi*4], ecx
	mov [eax+edi*4], ebx
	mov eax, 1

koniec_swap:

	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
_swap ENDP

_daj_czas PROC
	push	ebp
	mov		ebp, esp

	sub	esp, 16
	push esi
	push edi

	mov	edi, [ebp+8]		; w edi jest adres struktury

	mov esi, esp			; pod adresem z esi (w zmiennych)
							; bedzie localtime

	push esi				; EAX sie psul
	call _GetLocalTime@4
	nop
	mov	al, [esi+8]
	mov	[edi], al			; pierwszy parametr (1 bajt)
	mov	dl, [esi+10]
	mov	[edi+1], dl			; drugi parametr (1 bajt)

	pop edi
	pop	esi
	add	esp, 16
	pop	ebp
	ret
_daj_czas ENDP

END