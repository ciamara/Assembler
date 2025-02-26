.686
.model flat

public _plus_jeden

.code

_plus_jeden PROC

	push ebp ; zapisanie zawartosci EBP na stosie
	mov ebp,esp ; kopiowanie zawartosci ESP do EBP
	push ebx ; przechowanie zawartosci rejestru EBX
	; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
	; w kodzie w jezyku C
	mov ebx, [ebp+8]
	mov eax, [ebx] ; odczytanie wartosci zmiennej
	inc eax ; dodanie 1
	mov [ebx], eax ; odeslanie wyniku do zmiennej
	; uwaga: trzy powyzsze rozkazy mozna zastapic jednym rozkazem
	; w postaci: inc dword PTR [ebx]
	pop ebx
	pop ebp
	ret
_plus_jeden ENDP
END