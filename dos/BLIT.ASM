; blit	  PROC C  src:*bitmap,dest:*bitmap,mode:w
;
; bitmap  struc {left:w,top:w,right:w,bot:w,bytes:w,pntr:d}
;
; mode 0 - copy the source to the destination
; mode 1 - or the source and destination together
; mode 2 - and the source and destination together
; mode 3 - exclusive or the source and destination together
;
; mode 4 - copy the inverse of the source to the destination
; mode 5 - or the destination with the not of the source
; mode 6 - and the destination with the not of the source
; mode 7 - exclusive nor the source and destination together
;
; mode 8 - zeroes the destination bitmap
; mode 9 - or the source with the not of the destination
; mode A - and the source with the not of the destination
; mode B - invert the destination bitmap
;
; mode C - sets the destination bitmap to ones
; mode D - nand the source and the destination together
; mode E - nor the source and the destination together
; mode F - do nothing


jumps
locals

.MODEL COMPACT,C

.CODE
assume	ds:@code

rect	struc
left	dw	?
top	dw	?
right	dw	?
bot	dw	?
rect	ends

bitmap	struc
bounds	db	(size rect) dup(?)
bytes	dw	?
pntr	dd	?
bitmap	ends

segoff	struc
offs	dw	?
segm	dw	?
segoff	ends

count_begin	macro
thisone	=	$
	dw	?
	endm

count_end	macro
thatone	=	$
	org	thisone
	dw	thatone-thisone-2
	org	thatone
	endm

;note that the two words previous to the given verb must be the offsets
;  (in the data segment!) of two routines.  The first (cs:put_byte_subr-4) is
;  a routine that puts the byte in al with a mask of 0ffh.  The second
;  (cs:put_byte_subr-2) is a routine that puts the byte in al using the mask
;  in dl.

put_byte_subr	dw	?		;our transfer mode.

count		dw	?

smaller_delta	dw	?
larger_delta	dw	?
epsilon		dw	?

new_x_size	dw	?
old_x_size	dw	?
smaller_line	dw	?
larger_line	dw	?
compression	db	?
not_compression	db	?

bit_count	dw	?		;count of bits in source bitmap.
line_count	dw	?		;count of lines in source bitmap.
scan_line_count	dw	?		;count of lines so far done.

;we precompute several things:

src_align	dw	?		;source bit alignment, 0..7
src_seg		dw	?		;segment of source bitmap
src_bytes	dw	?		;width of source bitmap in bytes
src_left_bit	db	?		;leftmost bit in source bitmap

dest_align	dw	?		;destination bit alignment, 0..7
dest_bytes	dw	?		;width of dest bitmap in bytes
dest_left_bit	db	?		;leftmost bit in dest bitmap

;this following table is used to provide shifts of differing counts.
;  On a V20, and 80x86; x=1,2,3 we could use the shift with immediate count
;  instruction, but then we're screwed on 808x processors.

get_byte_ptr	dw	?
get_ptrs	label	word
	dw	0			;shift count of zero - not used.
	dw	shifted_1_get		;special case - shift count of 1.
	dw	shifted_get
	dw	shifted_get
	dw	shifted_get
	dw	shifted_get
	dw	shifted_get
	dw	shifted_7_get		;special case = shift count of -1 mod 8.

shifted_get	label	byte
	count_begin
	mov	ax,[si]			;get the next two bytes.
	inc	si
	rol	ax,cl			;align to screen byte.
	count_end

shifted_1_get	label	byte
	count_begin
	mov	ax,[si]			;get the next two bytes.
	inc	si
	rol	ax,1			;align to screen byte.
	count_end

shifted_7_get	label	byte
	count_begin
	mov	ax,[si]			;get the next two bytes.
	inc	si
	xchg	ah,al			;rol ax,7 == xchg ah,al;ror ax,1
	ror	ax,1			;align to screen byte.
	count_end

load_verb_1	label	byte
	count_begin
	stosb
	count_end
load_verb_2	label	byte
	count_begin
	xor	al,es:[di]
	and	al,dl
	xor	es:[di],al
	inc	di
	count_end

or_verb_1	label	byte
	count_begin
	or	es:[di],al
	inc	di
	count_end
or_verb_2	label	byte
	count_begin
	and	al,dl			;only set the bits given in al.
	or	es:[di],al
	inc	di
	count_end

and_verb_1	label	byte
	count_begin
	and	es:[di],al
	inc	di
	count_end
and_verb_2	label	byte
	count_begin
	not	dl
	or	al,dl
	and	es:[di],al
	inc	di
	count_end

xor_verb_1	label	byte
	count_begin
	xor	es:[di],al
	inc	di
	count_end
xor_verb_2	label	byte
	count_begin
	and	al,dl			;only xor the bits given in al.
	xor	es:[di],al
	inc	di
	count_end

load_not_verb_1   label   byte
	count_begin
	not	al
	stosb
	count_end
load_not_verb_2   label   byte
	count_begin
	not	al
	xor	al,es:[di]
	and	al,dl
	xor	es:[di],al
	inc	di
	count_end

or_not_verb_1	label	byte
	count_begin
	not	al
	or	es:[di],al
	inc	di
	count_end
or_not_verb_2	label	byte
	count_begin
	not	al
	and	al,dl			;only set the bits given in al.
	or	es:[di],al
	inc	di
	count_end

and_not_verb_1  label   byte
	count_begin
	not	al
	and	es:[di],al
	inc	di
	count_end
and_not_verb_2	label	byte
	count_begin
	not	al
	not	dl
	or	al,dl
	and	es:[di],al
	inc	di
	count_end

xor_not_verb_1	label	byte
	count_begin
	not	al
        xor     es:[di],al
	inc	di
	count_end
xor_not_verb_2	label	byte
	count_begin
	not	al
        and     al,dl                   ;only xor the bits given in al.
	xor	es:[di],al
	inc	di
	count_end

zero_verb_1	label	byte
	count_begin
	mov	al,0
	stosb
	count_end
zero_verb_2	label	byte
	count_begin
	not	dl
	and	es:[di],dl
	inc	di
	count_end

nand_not_verb_1 label	byte
	count_begin
	not	byte ptr es:[di]
	or	es:[di],al
	inc	di
	count_end
nand_not_verb_2 label	byte
	count_begin
	and	al,dl
	xor	es:[di],dl
	or	es:[di],al
	inc	di
	count_end

nor_not_verb_1	label	byte
	count_begin
	not	byte ptr es:[di]
	and	es:[di],al
	inc	di
	count_end
nor_not_verb_2	label	byte
	count_begin
	and	al,dl
	xor	es:[di],dl
	and	es:[di],al
	inc	di
	count_end

invert_verb_1	label	byte
	count_begin
	not	byte ptr es:[di]
	inc	di
	count_end
invert_verb_2	label	byte
	count_begin
	xor	es:[di],dl
	inc	di
	count_end

one_verb_1	label	byte
	count_begin
	mov	al,0ffh
	stosb
	count_end
one_verb_2	label	byte
	count_begin
	or	es:[di],dl
	inc	di
	count_end

nand_verb_1	label	byte
	count_begin
	and	es:[di],al
	not	byte ptr es:[di]
	inc	di
	count_end
nand_verb_2	label	byte
	count_begin
	not	al
	and	al,dl
	xor	es:[di],dl
	or	es:[di],al
        inc     di
	count_end

nor_verb_1	label	byte
	count_begin
	or	es:[di],al
	not	byte ptr es:[di]
	inc	di
	count_end
nor_verb_2	label	byte
	count_begin
	not	dl
	or	al,dl
	or	al,es:[di]
	not	al
	and	es:[di],dl
	or	es:[di],al
	inc	di
	count_end

nop_verb_1	label	byte
	count_begin
	inc	di
	count_end
nop_verb_2	label	byte
	count_begin
	inc	di			;go to the next byte.
	count_end

modetable label byte
	dw load_verb
	dw or_verb
	dw and_verb
	dw xor_verb
	dw load_not_verb
	dw or_not_verb
	dw and_not_verb
	dw xor_not_verb
	dw zero_verb
	dw nand_not_verb
	dw nor_not_verb
	dw invert_verb
	dw one_verb
	dw nand_verb
	dw nor_verb
	dw nop_verb

put_sized:
	mov	compression,1		;assume we're compressing zeroes.
	mov	not_compression,0
	cmp	put_byte_subr,offset load_verb
	jne	put_sized_1
	mov	compression,-1		;we're compressing ones
	mov	not_compression,1
put_sized_1:

	mov	ax,bit_count
	mov	old_x_size,ax		;remember the old h size.

	mov	cx,src_align		;compute the src left bit.
	mov	al,80h
	shr	al,cl
	mov	src_left_bit,al

	mov	ax,[di].right		;compute the new h size.
	sub	ax,[di].left
	mov	new_x_size,ax		;remember the new h size.

	mov	dest_align,bp		;compute the dest left bit.
	mov	cx,bp
	mov	al,80h
	shr	al,cl
	mov	dest_left_bit,al

	mov	ax,[di].bot		;compute the new v size.
	sub	ax,[di].top

	cmp	ax,line_count		;which is larger?
	jb	put_shrink_1		;go if we're shrinking
;expand it here.  We have more lines in the dest than the source.
	mov	bx,line_count		;don't include the last scan line.
	mov	smaller_delta,bx

	mov	larger_delta,ax
	mov	line_count,ax
	mov	epsilon,0

	call	blit_setup
	mov	src_seg,ax

	mov	bx,src_bytes
	mov	scan_line_count,bx
put_expand_2:
	push	si
	push	di
	call	put_sized_line
	pop	di
	pop	si

	mov	bx,epsilon
	mov	dx,larger_delta
	add	bx,smaller_delta
	cmp	bx,dx			;past the larger yet?
	jl	put_expand_3		;no.
	sub	bx,dx			;yes - subtract it.
	add	si,src_bytes		;advance to next line.
put_expand_3:
	mov	epsilon,bx

	add	di,dest_bytes
	dec	line_count
	jne	put_expand_2
	ret

put_shrink_1:
;shrink it here.  We have more lines in the source than in the dest.
	mov	smaller_delta,ax

	mov	ax,line_count
	mov	larger_delta,ax
	mov	epsilon,0

	call	blit_setup
	mov	src_seg,ax

	mov	scan_line_count,0

put_shrink_2:
	mov	bx,src_bytes
	add	scan_line_count,bx	;include another scan line in the processing.

	mov	bx,epsilon
	mov	dx,larger_delta
	add	bx,smaller_delta
	mov	epsilon,bx
	cmp	bx,dx			;past the larger yet?
	jl	put_shrink_3		;no.
	sub	bx,dx			;yes - subtract it off.
	mov	epsilon,bx

	push	si
	push	di
	call	put_sized_line
	pop	di
	pop	si

	add	si,scan_line_count	;move the source down a line.
	mov	scan_line_count,0

	add	di,dest_bytes		;move to the next line.

put_shrink_3:
	dec	line_count
	jne	put_shrink_2
	ret


put_sized_line:
;ds:si->array, es:di->screen, bp=destination alignment,
;  scan_line_count=number of scan lines to process.
;don't destroy bp.

	mov	ax,new_x_size		;are we changing the x size?
	cmp	ax,old_x_size
	jb	put_smaller_line	;yes - it's shorter.
	ja	put_larger_line		;yes - it's longer.
	mov	bx,ax
	mov	bp,dest_align		;get the destination alignment.
	jmp	put_scan_line		;no - same size.

put_larger_line:
	mov	larger_line,ax		;new is larger.
	mov	bit_count,ax
	xor	bx,bx

	mov	ax,old_x_size
	mov	smaller_line,ax

	mov	dl,dest_left_bit
	mov	dh,src_left_bit		;dh=source mask.

	mov	cx,bit_count

	push	ds
	mov	ds,src_seg

	mov	ah,[si]			;get the first source byte.
	inc	si
put_larger_line_1:

	xor	al,al
	test	dh,ah			;is the source bit set?
	je	put_larger_line_2	;no.
	mov	al,dl			;yes - get the dest bit in question.
put_larger_line_2:
	call	put_byte_subr		;put this byte.

	add	bx,smaller_line
	cmp	bx,larger_line
	jb	put_larger_line_3
	sub	bx,larger_line

	ror	dh,1			;move over a source bit.
	jnc	put_larger_line_3
	mov	ah,[si]
	inc	si
put_larger_line_3:

	ror	dl,1			;move over a dest bit.
	adc	di,0			;if cy, move over in di.
	loop	put_larger_line_1	;no.

	cmp	dh,80h			;did we use any of the source bits?
	jne	put_larger_line_5
	dec	si			;no - backup.
put_larger_line_5:
	pop	ds
	ret


put_smaller_line:
	mov	smaller_line,ax

	mov	ax,old_x_size
	mov	larger_line,ax
	mov	bit_count,ax
	xor	bx,bx

	mov	cx,bit_count

	mov	dl,dest_left_bit
	mov	dh,src_left_bit		;dh=source mask.

	push	ds
	mov	ds,src_seg

	mov	ah,7fh			;init the sampling sum.
put_smaller_line_1:

	push	bx

	mov	bx,0
put_smaller_line_6:
	add	ah,not_compression
	test	[si+bx],dh		;is the source bit set?
	je	put_smaller_line_2	;no.
	add	ah,compression		;yes - count this bit.
put_smaller_line_2:
	add	bx,src_bytes		;move down a scan line.
	cmp	bx,scan_line_count	;have we done all of them?
	jne	put_smaller_line_6	;no.

	pop	bx

	add	bx,smaller_line
	cmp	bx,larger_line
	jb	put_smaller_line_4
	sub	bx,larger_line

	xor	al,al			;assume not set.
	xor	ah,compression		;flip the sense if necessary.
	test	ah,80h			;more ones than zeroes?
	je	put_smaller_line_3	;no.
	mov	al,dl			;yes - set this bit.
put_smaller_line_3:
	call	put_byte_subr		;put this byte.
	mov	ah,7fh			;init the sampling sum.

	ror	dl,1			;move over a dest bit.
	adc	di,0			;if cy, move over in di.
put_smaller_line_4:

	ror	dh,1			;move over a source bit.
	adc	si,0
	loop	put_smaller_line_1	;no.

	cmp	dh,80h			;did we use any of the dest bits?
	je	put_smaller_line_5	;no.
	inc	si			;yes - skip to next byte.
put_smaller_line_5:
	pop	ds
	ret

bmsrc	bitmap <>
bmdest	bitmap <>

; MODES: 0-load 1-or 2-and 3-xor 4-load_not 5-or_not 6-and_not 7-xor_not

	PUBLIC	C blit
blit	PROC C far	src:DATAPTR,dest:DATAPTR,mode:WORD
	push	ds si di
	mov	ax,cs
	mov	es,ax
if @datasize
	lds	si,src
else
	mov	si,src
endif
	mov	di,offset bmsrc
	mov	cx,(size rect + size bytes)/2
	rep	movsw
	lodsw
	add	ax,10h
	stosw
	lodsw
	dec	ax
	stosw
if @datasize
	lds	si,dest
else
	mov	si,dest
endif
	mov	di,offset bmdest
	mov	cx,(size rect + size bytes)/2
	rep	movsw
	lodsw
	add	ax,10h
	stosw
	lodsw
	dec	ax
	stosw
        mov     ax,cs
	mov	ds,ax
	mov	si,offset modetable
	mov	bx,mode
	shl	bx,1
	mov	ax,[si+bx]
	mov	put_byte_subr,ax
	mov	si,offset bmsrc
	mov	di,offset bmdest
	call	blitter
	pop	di si ds
	ret
blit	endp

blit_1:
	ret

blitter proc
;enter with si->source bitmap, di->dest bitmap, put_byte_subr=transfer mode.
	mov	ax,[si].right		;compute the h size.
	sub	ax,[si].left
	je	blit_1			;if empty, exit now.
	mov	bit_count,ax
	mov	ax,[si].bot		;compute the v size.
	sub	ax,[si].top
	je	blit_1			;if empty, exit now.
	mov	line_count,ax

	mov	bp,[di].left		;compute the destination alignment.
	and	bp,7

	mov	ax,[si].left		;compute the source alignment.
	and	ax,7
	mov	src_align,ax

	mov	ax,[si].bytes		;get the source width.
	mov	src_bytes,ax

	mov	ax,[di].bytes		;get the destination width.
	mov	dest_bytes,ax

	mov	ax,[di].right		;are we changing the h size?
	sub	ax,[di].left
	cmp	ax,bit_count
	jne	put_sized		;yes.
	mov	ax,[di].bot		;are we changing the v size?
	sub	ax,[di].top
	cmp	ax,line_count
	jne	put_sized		;yes.

	cmp	bit_count,8		;does it fit in one byte?
	ja	compile_blit		;no - do it "slowly"
blit_2: 				;yes - do it "quickly"
	call	blit_setup

	mov	dx,00ffh		;compute the mask.
	mov	cx,bit_count
	ror	dx,cl			;make the necessary number of bits.

	mov	dl,0			;get rid of the unnecessary bits.
	mov	cx,bp
	shr	dx,cl			;shift the mask to where it should be.

	mov	cx,bp			;shift count is dest align-src align.
	sub	cx,src_align
	and	cl,16-1			;only 16 bits in a register.

	mov	bx,put_byte_subr	;get the byte store routine.
	mov	bp,dest_bytes
	dec	bp
	push	ds			;save our data segment,
	mov	ds,ax			;  and get the source segment.
blit_3:
	mov	ax,[si]			;get the byte into ax
	add	si,cs:src_bytes 	;move down a line.
	ror	ax,cl			;shift it to where it should be.
	xchg	dh,dl
;put the byte in al at es:di using the mask in dl
	call	bx			;bx=put_byte_subr
	inc	di			;move over one byte.
	xchg	dh,dl			;get the right mask.
	mov	al,ah			;get the right byte.
	call	bx			;bx=put_byte_subr
	add	di,bp			;bp=dest_bytes.
	dec	cs:line_count
	jne	blit_3

	pop	ds
	ret
blitter endp

copy_code	macro
	lodsw
	mov	cx,ax
	rep	movsb
	endm

compile_blit:
	push	si
	push	di

	push	cs
	pop	es
	mov	di,offset put_rect_subr

;in the following code, bp is the destination alignment,
;  dx is the byte count, si and cx are scratch, bx is used temporarily,
;  and es:di->the code that we're compiling.

	cmp	bp,src_align
	jne	compile_shifted
compile_aligned:
	push	di			;remember where to loop back to.

	mov	bx,bit_count		;get the number of bits left to do.

	or	bp,bp			;dest alignment zero?
	je	compile_aligned_2	;yes - don't mask on the left.

	mov	al,0b2h			;opcode of "mov dl,immed8"
	mov	cx,bp			;store the mask.
	mov	ah,0ffh
	shr	ah,cl
	stosw

	mov	al,0ach			;opcode of lodsb
	stosb

	mov	si,put_byte_subr	;compile the masked version.
	mov	si,cs:[si-2]
	copy_code

	add	bx,bp			;say that we've done the first few bits.
	sub	bx,8			;. .
compile_aligned_2:
	shr	bx,1			;truncate to an even number of bytes.
	shr	bx,1
	shr	bx,1
	cmp	put_byte_subr,offset load_verb ;are we doing pset?
	jne	compile_aligned_7	;no - have to do it "slowly"

	shr	bx,1			;prepare to move words.
	jnc	compile_aligned_8	;is the count odd? go if not.
	mov	al,0a4h			;opcode of "movsb"
	stosb
compile_aligned_8:
	mov	al,0b9h			;opcode of "mov cx,immed16"
	stosb
	mov	ax,bx
	stosw
	mov	ax,0f3h + 0a5h*256	;opcode of "rep movsw"
	stosw
	jmp	short compile_aligned_5
compile_aligned_7:
	mov	dx,bx			;remember the total number of bytes.
	inc	bx			;round up.
	shr	bx,1			;remember the number of loop iterations.
	or	bx,bx			;are there any iterations at all?
	je	compile_aligned_5	;no - skip the loop.
	mov	al,0b9h			;opcode of "mov cx,immed16"
	stosb
	mov	ax,bx
	stosw

	test	dx,1			;do we need to jump to the second store?
	je	compile_aligned_6	;no.
	mov	ax,0ebh + 256*0		;opcode of "jmp short $+2"
	stosw
compile_aligned_6:

	mov	bx,di			;remember where the jump is.
;bx now holds the offset of the jump into the loop, which is also
;  the beginning of the loop.

	mov	al,0ach			;opcode of lodsb
	stosb

	mov	si,put_byte_subr	;compile the unmasked version.
	mov	si,cs:[si-4]		;get the address of it.
	copy_code

	test	dx,1			;are we jumping into the loop here?
	je	compile_aligned_4	;no.
	mov	ax,di			;yes - compute the jump offset.
	sub	ax,bx
	mov	cs:[bx-1],al		;store it.
compile_aligned_4:

	mov	al,0ach			;opcode of lodsb
	stosb

	mov	si,put_byte_subr	;compile the unmasked version.
	mov	si,cs:[si-4]		;get the address of it.
	copy_code

	mov	al,0e2h			;opcode of "loop"
	stosb

	mov	ax,bx			;compute the jump offset.
	sub	ax,di
	dec	ax			;because bx->jump offset, not afterward.
	stosb

compile_aligned_5:
	mov	cx,bit_count
	add	cx,bp			;dest_align
	and	cx,7			;does it align to a right edge?
	je	compile_aligned_1	;yes - skip the right mask.

;cx now holds the right mask bit count.
	mov	ax,00ffh		;rotate the bits into ah.
	ror	ax,cl
	mov	al,0b2h			;opcode of "mov dl,immed8"
	stosw

	mov	al,0ach			;opcode of lodsb
	stosb

	mov	si,put_byte_subr	;compile the masked version.
	mov	si,cs:[si-2]
	copy_code

compile_aligned_1:
	jmp	compile_blit_2		;join with the shifting code.


compile_shifted:
	mov	si,src_align		;use the proper get byte routine.
	sub	si,bp
	and	si,7			;only eight different ones.
	shl	si,1			;index into word table.
	mov	si,get_ptrs[si]
	mov	get_byte_ptr,si

	mov	al,0b1h			;opcode of "mov cl,immed8"
	stosb
	mov	ax,src_align		;shift count is src align-dest align.
	sub	ax,bp
	and	al,7			;don't shift too far.
	stosb

	cmp	bp,src_align		;if we're shifting right, we need to
	jbe	compile_shifted_0	;  backup the source by one.
	mov	al,4eh			;opcode of "dec si"
	stosb
compile_shifted_0:

	push	di			;remember where the loop code starts.

	mov	bx,bit_count		;get the bit count.

	or	bp,bp			;is dest alignment zero?
	je	compile_shifted_2	;yes - don't bother masking the left.

	mov	al,0b2h			;opcode of "mov dl,immed8"
	mov	cx,bp			;store the mask.
	mov	ah,0ffh
	shr	ah,cl
	stosw

	mov	si,get_byte_ptr		;compile the code to get a byte.
	copy_code

	mov	si,put_byte_subr	;compile the masked version.
	mov	si,cs:[si-2]
	copy_code

	add	bx,bp			;say that we've done the first few bits.
	sub	bx,8			;. .
compile_shifted_2:

	shr	bx,1			;truncate to an even number of bytes.
	shr	bx,1
	shr	bx,1
	mov	dx,bx			;remember the total number of bytes.
	inc	bx			;round up.
	shr	bx,1			;remember the number of loop iterations.
	or	bx,bx			;are there any iterations at all?
	je	compile_shifted_5	;no - skip the loop.

	mov	al,0bbh			;opcode of "mov bx,immed16"
	stosb
	mov	ax,bx
	stosw

	test	dx,1			;do we need to jump to the second store?
	je	compile_shifted_6	;no.
	mov	ax,0ebh + 256*0		;opcode of "jmp short $+2"
	stosw
compile_shifted_6:

	mov	bx,di			;remember where the jump is.
;bx now holds the offset of the jump into the loop, which is also
;  the beginning of the loop.

	mov	si,get_byte_ptr		;compile the code to get a byte.
	copy_code

	mov	si,put_byte_subr	;compile the unmasked version.
	mov	si,cs:[si-4]		;get the address of it.
	copy_code

	test	dx,1			;are we jumping into the loop here?
	je	compile_shifted_4	;no.
	mov	ax,di			;yes - compute the jump offset.
	sub	ax,bx
	mov	cs:[bx-1],al		;store it.
compile_shifted_4:

	mov	si,get_byte_ptr		;compile the code to get a byte.
	copy_code

	mov	si,put_byte_subr	;compile the unmasked version.
	mov	si,cs:[si-4]		;get the address of it.
	copy_code

	mov	ax,4bh + 256*75h	;opcodes of "dec bx" and "jne"
	stosw

	mov	ax,bx			;compute the jump offset.
	sub	ax,di
	dec	ax			;because bx->jump offset, not afterward.
	stosb

compile_shifted_5:
	mov	cx,bit_count
	add	cx,bp			;dest_align
	and	cx,7			;does it align to a right edge?
	je	compile_blit_2		;yes - skip the right mask.

;bx now holds the right mask bit count.
	mov	ax,00ffh		;rotate the bits into ah.
	ror	ax,cl
	mov	al,0b2h			;opcode of "mov dl,immed8"
	stosw

	mov	si,get_byte_ptr		;compile the code to get a byte.
	copy_code

	mov	si,put_byte_subr	;compile the masked version.
	mov	si,cs:[si-2]
	copy_code

compile_blit_2:
;compute the number of bytes that we've affected.
	mov	ax,81h+11000111b*256	;opcode of "add di,immed16"
	stosw

	mov	bx,bit_count		;get the bit count.
	add	bx,bp			;add align (take care of left edge)
	add	bx,7			;round up (take care of right edge)
	shr	bx,1
	shr	bx,1
	shr	bx,1

	mov	ax,dest_bytes		;get the width of the dest bitmap.
	sub	ax,bx			;sub the number of bytes we've done.
	stosw				;ax=# bytes to next line.

	mov	ax,81h+11000110b*256	;opcode of "add si,immed16"
	stosw

	mov	ax,src_bytes		;get the width of the dest bitmap.
	sub	ax,bx			;sub the number of bytes we've done.
	stosw				;ax=# bytes to next line.

	mov	ax,4dh + 256*75h	;opcodes of "dec bp" and "jne"
	stosw

	pop	ax			;jump back to the beginning.
	sub	ax,di			;subtract target-(di+1),
	dec	ax			;  because di->after opcode, not operand
	stosb				;store the jump offset

;if we're shifting right, include the following code:
	cmp	bp,src_align		;are we shifting right?
	jbe	compile_blit_3		;no.
	mov	al,46h			;opcode of "inc si"
	stosb
compile_blit_3:

	mov	ax,01fh + 0c3h*256	;opcodes of "pop ds" and  "ret"
	stosw

	pop	di			;restore the bitmap pointers.
	pop	si

	mov	bp,line_count		;get the scan line count.
	call	blit_setup
	push	ds
	mov	ds,ax

put_rect_subr:
	db	100h dup(90h)

blit_setup:
;enter with ds:si->source bitmap, ds:di->dest bitmap.
;exit with ax:si->source bits, es:di->dest bits
	mov	bx,[di].left		;get x
	shr	bx,1			;get rid of bit position
	shr	bx,1
	shr	bx,1
	mov	ax,[di].top		;compute y-position*dest_bytes
	mul	[di].bytes
	add	bx,ax
	les	di,[di].pntr		;get the pointer to the bitmap.
	add	di,bx			;add the offset into the bitmap.

	mov	bx,[si].left		;get x
	shr	bx,1			;get rid of bit position
	shr	bx,1
	shr	bx,1
	mov	ax,[si].top		;compute y-position*src_bytes
	mul	[si].bytes
	add	bx,ax
	mov	ax,[si].pntr.segm	;get the segment into ax.
	mov	si,[si].pntr.offs	;get the offset into si.
	add	si,bx			;add the offset into the bitmap.
	ret


put_scan_line:
;ds:si->array, es:di->screen, bx=bit count, bp=destination alignment
;don't destroy bp.
	mov	cx,bp			;get destination alignment.
	jcxz	put_noshift		;go if it aligns.
	mov	dl,0ffh			;al=source mask
	shr	dl,cl
	mov	al,[si]			;dh=source byte
	shr	al,cl			;align to screen byte.
	add	bx,bp			;pretend that we've done a whole byte.
	sub	bx,8			;more bytes?
	jle	put_scan_line_2
	mov	cx,8			;make cl=8-shift count.
	sub	cx,bp
	cmp	put_byte_subr,offset load_verb
	je	put_scan_line_8
	call	put_byte_subr
	inc	di			;go to the next byte.
	mov	dl,0ffh			;eight bits in the rest of the bytes.
	jmp	short put_scan_line_5
put_scan_line_8:
	mov	ah,es:[di]		;get the dest byte.
	xor	al,ah			;flip the pattern using the dest bits.
	and	al,dl			;get rid of the bits we won't change.
	xor	al,ah			;flip using only the bits that change.
put_scan_line_7:
	stosb
	mov	ax,[si]			;get the next two bytes.
	inc	si			;go to the this byte.
	rol	ax,cl			;align to screen byte.
	sub	bx,8			;more bytes?
	ja	put_scan_line_7		;yes - keep doing them
	mov	dl,0ffh			;eight bits in the next byte.
	jmp	short put_scan_line_2	;no - finish off the last.
put_scan_line_4:
;put the byte in al at es:di using the mask in dl
	call	put_byte_subr
	inc	di
put_scan_line_5:
	mov	ax,[si]			;get the next two bytes.
	inc	si			;go to the next byte.
	rol	ax,cl			;align to screen byte.
	sub	bx,8			;more bytes?
	ja	put_scan_line_4		;yes - keep doing them
put_scan_line_2:
	add	bx,8
	mov	cl,bl
	shr	dl,cl
	not	dl			;we're not including the bits to the right.
	call	put_byte_subr
	cmp	bp,bx			;did we use any bits from the right byte.
	jae	put_scan_line_3		;no.
	inc	si			;yes - skip past it.
put_scan_line_3:
	ret


put_noshift:
;ds:si->array, es:di->screen, bx=bit count, bp=destination alignment (0).
	mov	dl,0ffh			;eight bits in the rest of the bytes.
	mov	cx,bx
	shr	cx,1
	shr	cx,1
	shr	cx,1
	and	bx,7
	jcxz	put_noshift_2
	cmp	put_byte_subr,offset load_verb
	jne	put_noshift_4
	shr	cx,1			;move words.
	jnc	put_noshift_1
	movsb
put_noshift_1:
	rep	movsw
	jmp	short put_noshift_2
put_noshift_4:
;put the byte in al at es:di using the mask in dl
	lodsb
	call	put_byte_subr
	inc	di
	loop	put_noshift_4
put_noshift_2:
	mov	cx,bx			;get the number of bits in the next byte.
	jcxz	put_noshift_3		;if none, just skip.
	mov	al,[si]
	inc	si
	mov	dx,0ff00h		;shift the bits in from ah.
	shr	dx,cl
	call	put_byte_subr
put_noshift_3:
	ret

;note that the two words previous to the given verb must be the offsets
;  (in the data segment!) of two routines.  The first (cs:put_byte_subr-4) is
;  a routine that puts the byte in al with a mask of 0ffh.  The second
;  (cs:put_byte_subr-2) is a routine that puts the byte in al using the mask
;  in dl.

	dw	load_verb_1
	dw	load_verb_2
load_verb proc			;new	old
	xor	al,es:[di]	;    | 0   1
	and	al,dl		;-----------
	xor	es:[di],al	;  0 | 0   0
	ret			;  1 | 1   1
load_verb endp

	dw	or_verb_1
	dw	or_verb_2
or_verb proc			;new	old
	and	al,dl		;    | 0   1
	or	es:[di],al	;-----------
	ret			;  0 | 0   1
or_verb endp			;  1 | 1   1

	dw	and_verb_1
	dw	and_verb_2
and_verb proc
	not	dl		;new	old
	or	al,dl		;    | 0   1
	not	dl		;-----------
	and	es:[di],al	;  0 | 0   0
	ret			;  1 | 0   1
and_verb endp

	dw	xor_verb_1
	dw	xor_verb_2
xor_verb proc			;new	old
	and	al,dl		;    | 0   1
	xor	es:[di],al	;-----------
	ret			;  0 | 0   1
xor_verb endp			;  1 | 1   0

	dw	load_not_verb_1
	dw	load_not_verb_2
load_not_verb proc
	not	al		;new	old
	xor	al,es:[di]	;    | 0   1
	and	al,dl		;-----------
	xor	es:[di],al	;  0 | 1   1
	ret			;  1 | 0   0
load_not_verb endp

	dw	or_not_verb_1
	dw	or_not_verb_2
or_not_verb proc		;new	old
	not	al		;    | 0   1
	and	al,dl		;-----------
	or	es:[di],al	;  0 | 1   1
	ret			;  1 | 0   1
or_not_verb endp

        dw      and_not_verb_1
	dw	and_not_verb_2
and_not_verb proc
	not	al		;new	old
	not	dl		;    | 0   1
	or	al,dl		;-----------
	not	dl		;  0 | 0   1
	and	es:[di],al	;  1 | 0   0
	ret
and_not_verb endp

	dw	xor_not_verb_1
	dw	xor_not_verb_2
xor_not_verb proc
	not	al		;new	old
        and     al,dl           ;    | 0   1
	xor	es:[di],al	;-----------
	ret			;  0 | 1   0
xor_not_verb endp		;  1 | 0   1

	dw	zero_verb_1
	dw	zero_verb_2
zero_verb proc			;new	old
	not	dl		;    | 0   1
	and	es:[di],dl	;-----------
	not	dl		;  0 | 0   0
	ret			;  1 | 0   0
zero_verb endp

	dw	nand_not_verb_1
	dw	nand_not_verb_2
nand_not_verb proc		;new	old
	and	al,dl		;    | 0   1
	xor	es:[di],dl	;-----------
	or	es:[di],al	;  0 | 1   0
	ret			;  1 | 1   1
nand_not_verb endp

	dw	nor_not_verb_1
	dw	nor_not_verb_2
nor_not_verb proc
	and	al,dl		;new	old
	xor	es:[di],dl	;    | 0   1
	and	es:[di],al	;-----------
	ret			;  0 | 0   0
nor_not_verb endp		;  1 | 1   0

	dw	invert_verb_1
	dw	invert_verb_2
invert_verb proc		;new	old
	;			;    | 0   1
	xor	es:[di],dl	;-----------
	ret			;  0 | 1   0
invert_verb endp		;  1 | 1   0

	dw	one_verb_1
	dw	one_verb_2
one_verb proc			;new	old
	;			;    | 0   1
	or	es:[di],dl	;-----------
	ret			;  0 | 1   1
one_verb endp			;  1 | 1   1

	dw	nand_verb_1
	dw	nand_verb_2
nand_verb proc
	not	al		;new	old
	and	al,dl		;    | 0   1
	xor	es:[di],dl	;-----------
	or	es:[di],al	;  0 | 1   0
	ret			;  1 | 0   0
nand_verb endp

	dw	nor_verb_1
	dw	nor_verb_2
nor_verb proc
	not	dl
	or	al,dl		;new	old
	or	al,es:[di]	;    | 0   1
	not	al		;-----------
	and	es:[di],dl	;  0 | 1   1
	or	es:[di],al	;  1 | 1   0
	not	dl
        ret
nor_verb endp

	dw	nop_verb_1
	dw	nop_verb_2
nop_verb proc			;new	old
	;			;    | 0   1
	;			;-----------
	ret			;  0 | 0   1
nop_verb endp			;  1 | 0   1

	END

