.686
.model flat

public _przestaw

.code

_przestaw PROC

	push ebp ; zapisanie zawartosci EBP na stosie
	mov ebp,esp ; kopiowanie zawartosci ESP do EBP
	push ebx ; przechowanie zawartosci rejestru EBX
	mov ebx, [ebp+8] ; adres tablicy tabl
	mov ecx, [ebp+12] ; liczba elementow tablicy
	dec ecx
	; wpisanie kolejnego elementu tablicy do rejestru EAX

ptl: mov eax, [ebx]

	; porownanie elementu tablicy wpisanego do EAX z nastepnym
	cmp eax, [ebx+4]
	jle gotowe ; skok, gdy nie ma przestawiania

	; zamiana sasiednich elementow tablicy
	mov edx, [ebx+4]
	mov [ebx], edx
	mov [ebx+4], eax

gotowe:

	add ebx, 4 ; wyznaczenie adresu kolejnego elementu
	loop ptl ; organizacja petli

	pop ebx ; odtworzenie zawartosci rejestrow
	pop ebp
	ret ; powrot do programu glownego
_przestaw ENDP
END