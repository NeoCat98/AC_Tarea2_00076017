org 	100h

section .text

	call 	texto	
	call 	cursor
	call 	phrase
inicio:
    call    phrase2
    xor 	si, si

lupi:	
    call 	kb
	cmp 	al, "$"
	je	mostrar
	mov	[300h+si], al ; CS:0300h en adelante
	inc 	si
	jmp 	lupi

mostrar:
    CMP si,5d 
    JNE reintentar
    call 	w_strng
	call 	kb	; solo detenemos la ejecución
	int 	20h
reintentar:
    call phrase3
    call inicio
kb:
    mov	ah, 00h ;subrutina que detiene la ejecución hasta recibir
	int 	16h	;algun carácter en el buffer del teclado
	ret		;este carácter lo guarda en el registro AL

w_strng:
    mov	ah, 13h
	mov al, 01h ; asigna a todos los caracteres el atributo de BL,
			; actualiza la posición del cursor
	mov 	bh, 00h ; número de página
	mov	bl, 01100100b ; atributo de caracter
	mov	cx, si ; tamaño del string (SI, porque todavía guarda la última posición)
	mov	dl, 43d ; columna inicial
	mov	dh, 17d	; fila inicial
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
    
w_gato:	mov 	ah, 09h
	mov 	al, cl
	mov 	bh, 0h
	mov 	bl, 01000000b;rojo negro
	mov 	cx, 1h
	int 	10h
	ret

kbwait: 
    mov 	ax, 0000h
	int 	16h
	ret

m_cursr:
    mov 	ah, 02h
	mov 	dx, di  ; columna
	mov 	dh, 17d ; fila
	mov 	bh, 0h
	int 	10h
	ret

m_cursr2:
    mov 	ah, 02h
	mov 	dx, di  ; columna
	mov 	dh, 16d ; fila
	mov 	bh, 0h
	int 	10h
	ret
m_cursr3:
    mov 	ah, 02h
	mov 	dx, di  ; columna
	mov 	dh, 15d ; fila
	mov 	bh, 0h
	int 	10h
	ret
phrase:	mov 	di, 43d
escribir1:	
    mov 	cl, [msg+di-43d]
	call    m_cursr
	call 	w_gato
	inc	di
	cmp 	di, len
	jb	escribir1
	ret
phrase2:	mov 	di, 0d
escribir2:	
    mov 	cl, [msg2+di]
	call    m_cursr2
	call 	w_char
	inc	di
	cmp 	di, len2
	jb	escribir2
	ret
phrase3:	mov 	di, 0d
escribir3:	
    mov 	cl, [msg3+di]
	call    m_cursr3
	call 	w_char
	inc	di
	cmp 	di, len3
	jb	escribir3
	ret
section .data
msg		db 	"GATO"
len 	equ	$-msg+43
msg2     db  "Ingrese una palabra de 5 caracteres(terminar con $): "
len2     equ $-msg2
msg3     db  "RECORDAR: La palabra debe de tener 5 caracteres(ejemplo: clave$)"
len3     equ $-msg3