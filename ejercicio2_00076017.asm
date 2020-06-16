org 	100h

section .text

    mov di,0d
    call password

inicio:
	mov 	dx, msg
	call 	w_strng
	xor 	si, si 	;lo mimso que: mov si, 0000h
lupi:	
    call 	kb
	cmp 	al, "E"
	je	mostrar
	mov	[300h+si], al ; CS:0200h en adelante
	inc 	si
	jmp 	lupi

mostrar:
    mov 	dx, nl
	call	w_strng
	mov	byte [300h+si], "$"
    ;Verificamos la clave
    call verificar
texto:	
    mov 	ah, 00h
	mov	al, 03h
	int 	10h
	ret

kb: 	
    mov	ah, 1h
	int 	21h
	ret

w_strng:
    mov	ah, 09h
	int 	21h
	ret
verificar:
    mov al,[300h]
    mov cl,[200h]
    CMP al,cl
    JNE inicio
    mov al,[301h]
    mov cl,[201h]
    CMP al,cl
    JNE inicio
    mov al,[302h]
    mov cl,[202h]
    CMP al,cl
    JNE inicio
    mov al,[303h]
    mov cl,[203h]
    CMP al,cl
    JNE inicio
    mov al,[304h]
    mov cl,[204h]
    CMP al,cl
    JNE inicio
    call bienvenido
bienvenido:
    mov dx, msg2
    call w_strng
    call kb
    int 20h
password:
    mov al,[pass+di]
    mov [200h+di],al
    CMP di,4d
    JE inicio
    inc di
    call password
section .data
msg 	db 	"La clave debe de tener 5 caracteres(para terminar escriba E): $"
msg2    db  "BIENVENIDO$"
pass    db  "clave"
nl	db 	0xA, 0xD, "$"