; blit2   PROC C  mask:*bitmap,back:*bitmap,work:*bitmap
;
; bitmap  struc {left:w,top:w,right:w,bot:w,bytes:w,pntr:d}

jumps
locals

.MODEL COMPACT,C

.CODE
assume	ds:@code

segoff	struc
offs	dw	?
segm	dw	?
segoff	ends

bit_count	dw	?		; count of bits in bitmap.
line_count	dw	?		; count of lines in bitmap.
line_rest	dw	?		; add to next line

bitmap: 				; dest bitmap structure
left	dw	?
top	dw	?
right	dw	?
bot	dw	?
bytes	dw	?
lgthd	=  $ - bitmap
destpt  segoff <>
lgtbm	=  $ - bitmap
srcpt	segoff <>
maskpt  segoff <>
sstack	segoff <>

	PUBLIC	C blit2
blit2	PROC C	bmask:DATAPTR,bback:DATAPTR,bwork:DATAPTR
	push	ds
	push	si
	push	di
	mov	ax,cs
	mov	es,ax
if @datasize
	lds	si,bwork
else
	mov	si,bwork
endif
	mov	di,offset bitmap
	mov	cx,lgtbm/2
	rep	movsw
if @datasize
	lds	si,bback
else
	mov	ax,cs
	mov	ds,ax
	mov	si,bback
endif
	mov	di,offset bitmap
	mov	cx,lgthd/2
	repz	cmpsw
	jcxz	@@ok1
	jmp	cannot_handle
@@ok1:	lds	si,[si]
	mov	di,offset srcpt
	mov	ax,si
	stosw
	mov	ax,ds
	stosw
if @datasize
	lds	si,bmask
else
	mov	ax,cs
	mov	ds,ax
        mov     si,bmask
endif
	mov	di,offset bitmap
	mov	cx,lgthd/2
	repz	cmpsw
	jcxz	@@ok2
	jmp	cannot_handle
@@ok2:	lds	si,[si]
	mov	di,offset maskpt
	mov	ax,si
	stosw
	mov	ax,ds
	stosw
	mov	ax,cs
	mov	ds,ax
        call    blitter2
cannot_handle:
	pop	di
	pop	si
	pop	ds
	ret
blit2	endp

blitter2 proc
	mov	ax,right		;compute the h size.
	sub	ax,left
	jbe	blit_ret		;if empty, exit now.
	mov	bit_count,ax
	mov	ax,bot			;compute the v size.
	sub	ax,top
	jbe	blit_ret		;if empty, exit now.
	mov	line_count,ax

	mov	cx,left
	shr	cx,3
	mov	ax,top
	mul	bytes
	add	ax,cx
	add	destpt.offs,ax		;adjust pointers
	add	srcpt.offs,ax
	add	maskpt.offs,ax

	cmp	bit_count,8		;does it fit in one byte?
	ja	blit_slow		;no - do it "slowly"

blit_quick:                             ;yes - do it "quickly"
	mov	dx,00ffh		;compute the mask.
	mov	cx,bit_count
	ror	dx,cl			;make the necessary number of bits.

	mov	dl,0			;get rid of the unnecessary bits.

	mov	cx,left 		;compute the alignment.
	and	cx,7
	shr	dx,cl			;shift the mask to where it should be.
	xchg	dh,dl			;right order

	cli				; no interrupts
	mov	sstack.offs,sp
	mov	sstack.segm,ss
	mov	cx,bytes
	mov	bp,maskpt.offs
	mov	ss,maskpt.segm		; mask pointer
	les	di,destpt		; destination pointer
        lds     si,srcpt                ; source pointer
blit_qlp:
	mov	ax,[si] 		;get the byte into ax
	and	ax,[bp]
	and	ax,dx
	or	es:[di],ax
	add	si,cx			;move down a line.
        add     di,cx
	add	bp,cx
        dec     cs:line_count
	jne	blit_qlp

	mov	ax,cs
	mov	ds,ax			; restore ds
	mov	sp,sstack.offs
	mov	ss,sstack.segm		; restore stack
	sti				; reenable int
	jmp	blit_ret

blit_slow:
	mov	bx,bit_count
	mov	dx,0ff00h
	mov	cx,right
	and	cx,7
	shr	dx,cl			;right part of the mask
	sub	bx,cx
        mov     dh,0ffh
        mov     cx,left
	and	cx,7
        shr     dh,cl                   ;left part of the mask
	add	bx,cx
	shr	bx,3
	mov	cx,bytes
	sub	cx,bx
	dec	cx
	mov	line_rest,cx
	dec	bx

	cli				; no interrupts
	mov	sstack.offs,sp
	mov	sstack.segm,ss
	mov	bp,maskpt.offs
	mov	ss,maskpt.segm		; mask pointer
	les	di,destpt		; destination pointer
        lds     si,srcpt                ; source pointer
blit_slp:
	lodsb				;get the byte into al
	and	al,[bp]
	inc	bp
	and	al,dh
	or	es:[di],al
	inc	di
	mov	cx,bx
	jcxz	nomiddle
mid:	lodsb				;get the byte into al
	and	al,[bp]
	inc	bp
	or	es:[di],al
	inc	di
	loop	mid
nomiddle:
	lodsb				;get the byte into al
	and	al,[bp]
	inc	bp
	and	al,dl
	or	es:[di],al
	inc	di
	mov	cx,cs:line_rest
	add	si,cx			;move down a line.
	add	di,cx
	add	bp,cx
	dec	cs:line_count
	jne	blit_slp

	mov	ax,cs
	mov	ds,ax			; restore ds
	mov	sp,sstack.offs
	mov	ss,sstack.segm		; restore stack
	sti				; reenable int
blit_ret:
	ret
blitter2 endp

	END
