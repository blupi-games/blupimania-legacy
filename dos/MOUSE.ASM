
;========
;opentime
;========

;        Indique le debut d'une operation plus ou moins longue
;        (ne fait rien, enregistre simplement le temps absolu).

	PUBLIC opentime
opentime PROC C
	mov ax,cntime
	mov mtime,ax
	ret
opentime endp

;=========
;closetime
;=========

;        Indique la fin d'une operation plus on moins longue,
;        avec attente si la duree etait plus petite que le temps total souhaite.

	PUBLIC closetime
closetime PROC C t:WORD
	test speed_onoff,1
	jnz @@return
	cmp word ptr t,0
	jz @@return
	mov cx,t
	add cx,mtime
@@more: mov ax,cntime
	sub ax,cx       ; ax = diff in 20 ms
	jge @@return
	cmp ax,-50
	jnc @@more      ; do not wait more than 1 sec
@@return:
	ret
closetime endp

	PUBLIC vfy_mouse
vfy_mouse PROC C
	mov ax,0        ; int mouse
	int 33h
	cmp ax,-1
	jnz not_supported_mouse
	mov ax,1
	jmp @@return
not_supported_mouse:
	mov ax,-1
@@return:
	ret
vfy_mouse endp


	PUBLIC disable_mouse
disable_mouse PROC C
	mov dx,int_port
	or dx,dx
	jz @@return
	in al,dx
	or al,int_mask
	out dx,al
@@return:
	ret
disable_mouse endp

	PUBLIC enable_mouse
enable_mouse PROC C
	mov dx,int_port
	or dx,dx
	jz @@return
	in al,dx
	not al
	or al,int_mask
	not al
	out dx,al
@@return:
	ret
enable_mouse endp

