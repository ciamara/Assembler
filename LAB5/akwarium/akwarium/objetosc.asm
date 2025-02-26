.686
.model flat

public _objetosc

.data
	
	pol dq 0.5

.code

_objetosc PROC

	finit

	push ebp
	mov ebp, esp

	fld qword ptr pol
	fld qword ptr [ebp +48]	;szerokosc -> st(0)
	fld qword ptr [ebp +40]	;dlugosc -> st(1)
	fld qword ptr [ebp+32] ;wysokosc -> st(2)
    fld qword ptr [ebp+24]  ;grubosc -> st(3)
    fld qword ptr [ebp+16]  ;poziomwody -> st(4)
    fld qword ptr [ebp+8]   ;piasek -> st(5)


	fxch st(5)
	fmul st(0), st(6)	;piasek*0.5
	fxch st(5)

	fxch st(2)
	fsub st(0), st(3)	;wysokosc -1grubosc
	fsub st(0), st(4)	;wysokosc -poziomwody
	fsub st(0), st(5)	;wysokosc - 0.5piasek
	fxch st(2)

	fxch st(3)
	fadd st(0), st(0)	 ;grubosc razy 2
	fxch st(3)

	fsub st(0), st(3)	;szerokosc-2grubosc

	fxch st(1)
	fsub st(0), st(3)	;dlugosc-2grubosc
	fxch st(1)

	fmul st(0), st(1)	;szerokosc*dlugosc
	fmul st(0), st(2)	;szerokosc*dlugosc*wysokosc(bez grubosci akwarium)

	pop ebp
	ret
_objetosc ENDP
END