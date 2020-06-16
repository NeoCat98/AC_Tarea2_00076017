org 100h

section .text

    call 	texto	
	call 	cursor

inicio:
	call 	phrase
    xor 	si, si

lupi:	
    call 	kb
	cmp 	si,1d
	je	mostrar
	CMP al,48d
	JB error
	CMP al,57d
	JA error
	mov	[300h+si], al ; CS:0300h en adelante

	inc 	si
	jmp 	lupi
lupi2:
    call    phrase2
    call 	kb	
    inc 	si
	cmp 	si,3d
	je	mostrar2
	CMP al,48d
	JB error
	CMP al,57d
	JA error
	mov	[300h+si], al ; CS:0300h en adelante
	jmp 	lupi2
mostrar:
    mov al,"+"
    mov [300h+si],al
    call 	w_strng
    call lupi2
mostrar2:
    call w_strng
mostrar3:
    call phrase3
    call 	kb
	cmp al,"S"
    JE lupi3
    call mostrar3
lupi3:
    mov al,"="
    mov [300h+si],al
    inc si
    call 	w_strng
    mov al,[300h]
    SUB al,30h
    mov cl,[302h]
    SUB cl,30h
    ADD al,cl
	CMP al,9d
	JA	imprimir2
    ADD al,30h
    mov [300h],al
    mov si,1d
    call 	r_strng
	call 	kb	; solo detenemos la ejecución
	int 	20h
imprimir2:
	mov cl,al
	mov al,"1"
	mov [300h],al
	inc si
	SUB cl,10d
	ADD cl,30h
	mov al,cl
	mov [301h],al
	mov si,2d
	call r_strng
	call 	kb	; solo detenemos la ejecución
	int 	20h
kb:
    mov	ah, 00h ;subrutina que detiene la ejecución hasta recibir
	int 	16h	;algun carácter en el buffer del teclado
	ret		;este carácter lo guarda en el registro AL

w_strng:
    mov	ah, 13h
	mov al, 01h ; asigna a todos los caracteres el atributo de BL,
			; actualiza la posición del cursor
	mov 	bh, 00h ; número de página
	mov	bl, 00101110b ; atributo de caracter
	mov	cx, si ; tamaño del string (SI, porque todavía guarda la última posición)
	mov	dl, 30d ; columna inicial
	mov	dh, 15d	; fila inicial
	; Como esta interrupción saca el string de ES:BP, tenemos que poner los valores correcpondientes
	push 	cs ; Segmento actual en el que está guardado nuestro string
	pop	es ; Puntero al segmento que queremos 
	mov	bp, 300h ; Dirección inicial de nuestra cadena de texto
	; ES:BP equals CS:300h 
	int 10h
	ret
r_strng:
    mov	ah, 13h
	mov al, 01h ; asigna a todos los caracteres el atributo de BL,
			; actualiza la posición del cursor
	mov 	bh, 00h ; número de página
	mov	bl, 01110001b ; atributo de caracter
	mov	cx, si ; tamaño del string (SI, porque todavía guarda la última posición)
	mov	dl, 34d ; columna inicial
	mov	dh, 15d	; fila inicial
	; Como esta interrupción saca el string de ES:BP, tenemos que poner los valores correcpondientes
	push 	cs ; Segmento actual en el que está guardado nuestro string
	pop	es ; Puntero al segmento que queremos 
	mov	bp, 300h ; Dirección inicial de nuestra cadena de texto
	; ES:BP equals CS:300h 
	int 10h
	ret
texto:	
    mov 	ah, 00h
	mov	    al, 03h
	int 	10h
	ret

cursor: 
    mov	    ah, 01h
	mov 	ch, 00000000b
	mov 	cl, 00001110b;   IRGB
	int 	10h
	ret

w_char:	mov 	ah, 09h
	mov 	al, cl
	mov 	bh, 0h
	mov 	bl, 00001111b
	mov 	cx, 1h
	int 	10h
	ret

m_cursr:
    mov 	ah, 02h
	mov 	dx, di  ; columna
	mov 	dh, 1d ; fila
	mov 	bh, 0h
	int 	10h
	ret

m_cursr2:
    mov 	ah, 02h
	mov 	dx, di  ; columna
	mov 	dh, 0d ; fila
	mov 	bh, 0h
	int 	10h
	ret
phrase:	mov 	di, 0d
escribir1:	
    mov 	cl, [msg+di]
	call    m_cursr
	call 	w_char
	inc	di
	cmp 	di, len
	jb	escribir1
	ret
phrase2:	mov 	di, 0d
escribir2:	
    mov 	cl, [msg2+di]
	call    m_cursr
	call 	w_char
	inc	di
	cmp 	di, len2
	jb	escribir2
	ret
phrase3:	mov 	di, 0d
escribir3:	
    mov 	cl, [msg3+di]
	call    m_cursr
	call 	w_char
	inc	di
	cmp 	di, len3
	jb	escribir3
	ret
phraseError:	mov 	di, 0d
escribirError:	
    mov 	cl, [msg4+di]
	call    m_cursr2
	call 	w_char
	inc	di
	cmp 	di, len4
	jb	escribirError
	ret
error:
	call phraseError
	call inicio

section .data
msg 	db 	"Ingrese el primer numero: "
len 	equ	$-msg
msg2 	db 	"Ingrese el segundo numero: "
len2 	equ	$-msg2
msg3    db  "   Oprima S para terminar   "
len3 	equ	$-msg3
msg4    db  "Ingresar solo digitos"
len4 	equ	$-msg4
nl	db 	0xA, 0xD, "$"