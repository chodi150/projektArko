;eax -> wskaznik na rysunek
;[ebp+12] - szerokosc
;[ebp+16] - wysokosc
;[ebp+20] - S
;[ebp+24] - a
;[ebp+28] - b
;[ebp+32] - c
;[ebp-8]  - px/szerokosc
;[ebp-12] - px / wysokosc
;[ebp-16] - aktualny x
;[ebp-20] - wyliczony y
;[ebp-24] - cos
;[ebp-28] - sin
;[ebp-32] - aktualna wartosc w petli
;[ebp-36] - skok w petli
;[ebp-40] - dx
;[ebp-44] - dy
;[ebp-48] - pocodna
section .text

global func

func:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]


    mov [ebp-4], dword 256      ;zaladowanie 256
    cvtsi2ss xmm0, [ebp-4]      ;konwersja na float
    movss [ebp-4], xmm0         ;zuruck do pamieci
    fld dword [ebp-4]           ;zaladowanie na stos
    fdiv dword [ebp+12]		;dzielenie 1024/szerokosc
    fstp  dword [ebp-8]		;[ebp-8]  -> px / szer
    fld  dword [ebp-4]		;256 na stos
    fdiv dword [ebp+16]  	;dzielenie 512/2*wysokosc
    fstp  dword [ebp-12]		;2*wysokosc pod [ebp-12]


    fld dword [ebp+12]                ;szerokosc na stos
    fsub dword [ebp+12]
    fsub dword [ebp+12]                 ;poczatkowy x to -szerokosc
    fstp dword [ebp-16]

    mov ecx, 10000

loop:
        fld dword [ebp-16]
	fmul dword [ebp-16]	;x^2
	fmul dword [ebp+24]	;ax^2
	fld  dword [ebp-16]		;wrzucenie x na stos
	fmul dword [ebp+28]	;bx
        fadd 				;ax^2 + bx ; wynik w st(0)
	fld dword [ebp+32]			;wrzucenie c na stos
	fadd					;ax^2+bx + c ; wynik w st(0)
        fstp dword [ebp-20]   ;wyliczony y

	;POCHODNA
	
        mov [ebp-4], dword 2        ;zaladowanie 2
        cvtsi2ss xmm0, [ebp-4]      ;konwersja na float
        movss [ebp-4], xmm0         ;zuruck do pamieci
        fld dword [ebp-4]           ;zaladowanie 2 na stos
        fmul dword [ebp+24]         ;2*a
        fmul dword [ebp-16]         ;2ax
        fadd dword [ebp+28]         ;2ax+b
        fstp dword [ebp-48]
        fld dword [ebp-48]

	
        mov [ebp-4], dword 1       ;zaladowanie 1
        cvtsi2ss xmm0, [ebp-4]      ;konwersja na float
        movss [ebp-4], xmm0         ;zuruck do pamieci
        fld dword [ebp-4]           ;zaladowanie 2 na stos
	fpatan				;arctg
	fsincos
        fstp dword [ebp-24]			;zapisanie cosinusa pod [ebp-24]
        fstp dword [ebp-28]			;zapisanie sinusa pod [ebp-28]

        mov [ebp-32], dword 0        ;zaladowanie 0 jako aktualnej wartosci w petli
        cvtsi2ss xmm0, [ebp-32]      ;konwersja na float
        movss [ebp-32], xmm0         ;zuruck do pamieci

        mov [ebp-4], dword 1        ;zaladowanie 1
        cvtsi2ss xmm0, [ebp-4]      ;konwersja na float
        movss [ebp-4], xmm0         ;zuruck do pamieci
        fld dword [ebp-4]           ;zaladowanie 1 na stos

        mov [ebp-4], dword 1000        ;zaladowanie 100
        cvtsi2ss xmm0, [ebp-4]      ;konwersja na float
        movss [ebp-4], xmm0         ;zuruck do pamieci
        fdiv dword [ebp-4]           ;zaladowanie 2 na stos
        fstp dword [ebp-36]         ;zapisanie skoku w petli 1/00

	
drawLoop:
	fld dword [ebp-32]
        fadd dword [ebp-36]			;dodanie skoku do dlugosci
        fstp dword [ebp-32]			;aktualna wartosc dlugosci
	
	fld dword [ebp-16]			;zaladowanie x na stos
        fmul dword [ebp-8]			;wyliczenie piksela dla x
        fstp dword [ebp-4]
        movss xmm0, [ebp-4]
        cvtss2si edi, xmm0	;konwersja wyliczonego x na l calki ;UNFALL

	
        fld dword [ebp-20]			;zaladowanie y na stos
        fmul dword [ebp-12]			;wyliczenie piksela dla x
        fstp dword [ebp-4]
        movss xmm0, [ebp-4]
        cvtss2si esi, xmm0	;konwersja wyliczonego x na l calki ;UNFALL

	
	add edi, 256
	add esi, 256
	lea edi, [edi + edi*2]
	lea esi, [esi + esi*2]
	shl esi,9
	add edi, esi
	
	cmp edi, 0
	jl next
	cmp edi, 786432
	jg next

	mov [eax + edi], BYTE 255
	mov [eax + edi+1], BYTE 255
	mov [eax + edi+2], BYTE 255

next:
	fld dword [ebp-24]			;wczytanie cos na stos
        fmul dword [ebp-32]			;wyliczenie dx = s * cos
        fstp dword [ebp-40]			;zapisanie dx pod [ebp-40]
	fld dword [ebp-28]			;wczytanie sin na stos
        fmul dword [ebp-32]			;wyliczenie dy
        fstp dword [ebp-44]			;zapisanie dy pod [ebp-44]
	
	fld dword [ebp-16]			;zaladowanie x na stos
        fadd dword [ebp-40]			;x' = x + dx
        fstp dword [ebp-16]			;zapisanie nowego x
	fld dword [ebp-20]			;zaladowanie y na stos
        fadd dword [ebp-44]			;y'=y+dy
        fstp dword [ebp-20]			;zapisanie nowego y
	
	fld dword [ebp-32]			;aktualna wartosc dlugosci na stos
	fld dword [ebp+20]			;docelowa dlugosc linii
	fcomip
	fstp
	ja drawLoop

        cmp ecx, 0
        jz end
        dec ecx

	fld dword  [ebp+12]			;szerokosc na stos
	fld dword [ebp-16]			;aktualny x
	fcomip
	fstp
	ja end
	jmp loop
end:
    fld dword [ebp-16]
    pop ebp
    ret
