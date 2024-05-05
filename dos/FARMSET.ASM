locals
jumps
 
.MODEL LARGE,C


.CODE
;===========
; farmemset
;===========

	PUBLIC farmemset
farmemset PROC C p:DATAPTR,fill:WORD,lgt:DWORD
	push di
	les di,p
	mov cx,word ptr lgt
	mov ax,fill
        mov bx,di
	neg bx
	cmp bx,cx
	jc @@wrap
	cmp word ptr lgt+2,0
	jz @@last
@@wrap: mov cx,bx
	rep stosb
	sub word ptr lgt,bx
	jnc @@nc
@@nxsg: dec word ptr lgt+2
@@nc:	mov bx,es
	add bx,1000h
	mov es,bx
	cmp word ptr lgt+2,0
	jz @@final
	rep stosb
	jmp @@nxsg
@@final:mov cx,word ptr lgt
@@last: rep stosb
	pop di
	ret
farmemset endp

	end
