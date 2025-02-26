.686
.model flat

public _suma

.code

_suma PROC

	push ebp
	mov ebp, esp
	;sub esp
	push ebx
	push esi
	push edi

	mov eax, [ebp+8]		; adres tablicy
	mov ecx, [ebp+12]		; rozmiar l1
	mov edi, [ebp+16]		; rozmiar l2
	mov esi, [ebp+20]		; rozmiar l3
	mov edi [ebp +24]		;rozmiar l4



	pop edi
	pop esi
	pop ebx
	;add esp
	pop ebp
	ret
_suma ENDP
END