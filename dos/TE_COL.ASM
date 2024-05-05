locals
jumps

.MODEL LARGE,C

if @datasize NE 1
%OUT This program assumes that all data pointers are far
%OUT The memory models must be compact or large
ERR
endif

.DATA

	PUBLIC C color_bw
color_bw        dw      0       ; 1 means color and 0 b&w screen

defpal  label byte
	db      0               ;Black
	db      1               ;Blue
	db      2               ;Green
	db      3               ;Cyan
	db      4               ;Red
	db      5               ;Magenta
	db      20              ;Brown
	db      7               ;Light Gray
	db      56              ;Dark  Gray
	db      57              ;Light Blue
	db      58              ;Light Green
	db      59              ;Light Cyan
	db      60              ;Light Red
	db      61              ;Light Magenta
	db      62              ;Yellow
	db      63              ;White

pallet_rgb label byte
	db      00h,00h,00h     ;Black          ;  0%
	db      00h,00h,2ah     ;Blue           ;  7%
	db      00h,2ah,00h     ;Green          ; 39%
	db      00h,2ah,2ah     ;Cyan           ; 47%
	db      2ah,00h,00h     ;Red            ; 20%
	db      2ah,00h,2ah     ;Magenta        ; 27%
	db      2ah,15h,00h     ;Brown          ; 40%
	db      15h,15h,15h     ;Dark  Gray     ; 33%
	db      2ah,2ah,2ah     ;Light Gray     ; 67%
	db      15h,15h,3fh     ;Light Blue     ; 41%
	db      15h,3fh,15h     ;Light Green    ; 73%
	db      15h,3fh,3fh     ;Light Cyan     ; 80%
	db      3fh,15h,15h     ;Light Red      ; 53%
	db      3fh,15h,3fh     ;Light Magenta  ; 61%
	db      3fh,3fh,15h     ;Yellow         ; 93%
	db      3fh,3fh,3fh     ;White          ;100%

; Luminosity 0Fh,0Eh,0Bh,0Ah,08h,0Dh,0Ch,03h,09h,06h,02h,07h,05h,04h,01h,00h

pallet_buf      db 256 dup (3 dup (?))
video_mode      db      ?
grmode  dw      3

printer_online  dw ?
stseq   db 1BH,'3',18H,0AH,0
gracod  db 1BH,'*',4,0
crcod   db 0DH,0AH,0
endseq  db 1BH,'3',24H,0AH,0cH,0
	even
valid24 dw 0
old24h  dw ?,?

printer_pattern label byte
;          col0  col1  col2  col3  col4  col5  col6  col7
	db 0000b,1000b,1010b,1010b,1010b,0101b,0101b,0010b
	db 0000b,0000b,0000b,1101b,0101b,0010b,1010b,0101b
	db 0000b,0010b,1010b,1010b,1010b,0101b,0101b,1010b
	db 0000b,0000b,0000b,1111b,0100b,0010b,0010b,0101b
;          col8  col9  colA  colB  colC  colD  colE  colF
	db 1000b,0000b,0100b,0000b,0101b,0100b,0100b,1111b
	db 0000b,0101b,1010b,0100b,0000b,1010b,1010b,1111b
	db 1010b,0010b,0100b,1010b,0101b,0100b,0100b,1111b
	db 0000b,0101b,0000b,0100b,0000b,0010b,1010b,1111b
	even

.CODE

;=======
; ifEGA
;=======

;     Check if it is at least EGA (return 1 if so)

	PUBLIC ifEGA
ifEGA   PROC C
	mov ah,12h
	mov bl,10h
	int 10h
	mov ax,0
	cmp bl,10h
	jz @@notEGA
	inc ax
@@notEGA:
	and ax,ax       ; set the flags
	ret
ifEGA   endp



;============
;querry_video
;============

;     get info about the graphic card

	PUBLIC querry_video
querry_video    PROC C monitor:DATAPTR,vmodes:DATAPTR
	push si di
if @datasize
	les     di,monitor
else
	push ds
	pop es
	mov     di,monitor
endif
	mov ax,1a00h
	int 10h
	cmp al,1ah
	jnz @@tryEGA
	mov ax,bx
	stosw
	mov ah,1bh
	xor bx,bx
	mov di,offset hash
	push ds
	pop es
	int 10h
	cmp al,1bh
	jnz @@type
	push ds
	lds si,es:[di]
if @datasize
	les     di,vmodes
else
	pop es
	push es
	mov     di,vmodes
endif
	inc si
	lodsw
	shl ax,4
	mov al,[si-3]
	stosw
	pop ds
	jmp @@type
@@tryEGA:
	call ifEGA
	jz @@ret
	mov ah,12h
	mov bl,10h
	int 10h
	mov al,4
	add al,bh
	cbw
	stosw

@@type:
if @datasize
	les     di,monitor
else
	push ds
	pop es
	mov     di,monitor
endif
	mov ax,es:[di]
	and ax,ax
	jz @@ret
	not ax
	and ax,1
	mov color_bw,ax
	add ax,0fh
;add ax,2
	mov grmode,ax           ; mode 0fh for monocrome and 10h for color

@@ret:  pop di si
	ret
querry_video    endp

;=======
;ifcolor
;=======

;     Indique si la machine dispose d'un ecran couleur.
;     Retourne != 0 si oui (vrai).

	PUBLIC ifcolor
ifcolor PROC C
	mov ax,color_bw
	and ax,ax
	ret
ifcolor endp



;=======
; ifVGA
;=======

;     Detect if the graphic card is VGA (return 1 if it is)
;     That is esential for the pallet registers
;     if VGA all registers are readable
;     there are 6 bit/fundamental color

	PUBLIC ifVGA
ifVGA   PROC C
	mov ax,1a00h
	int 10h
	cmp al,1ah
	mov ax,0
	jnz @@notvga
	mov ax,1
@@notvga:
	and ax,ax       ; set the flags
	ret
ifVGA   endp

;=====================
;wait the retrace line
;=====================

; local routine

	PUBLIC wait_r
wait_r  PROC C
	mov dx,3dah     ; Input Status 1
rt:     in al,dx
	test al,8       ; are we in a retrace?
	jnz rt          ; if so, look for non-retrace
n_rt:   in al,dx        ; no, now look for next
	test al,8
	jz n_rt
	ret
wait_r  endp

;========
;modcolor
;========

;     Modifie les composantes rouge/vert/bleu d'une couleur.

	PUBLIC modcolor
modcolor PROC C color:WORD, red:WORD, green:WORD, blue:WORD
	push di
	push si
	mov ax,DGROUP
	mov es,ax
	mov bx,color
	add di,bx

	call wait_r             ; all changes made only during retrace

@@vga:  mov dx,3c8h
	mov bx,color
	mov ax,15
	sub ax,bx
	mov bx,ax
	mov al,es:defpal[bx]
	out dx,al
	inc dx
	mov ax,red
	shr ax,2
	out dx,al
	mov ax,green
	shr ax,2
	out dx,al
	mov ax,blue
	shr ax,2
	out dx,al
@@exit: pop si
	pop di
	ret
modcolor endp

;=============
;save_palet
;=============

	PUBLIC save_palet
save_palet PROC C
	mov ax,DGROUP
	mov es,ax
	call ifcolor
	jz @@exit
	call ifVGA
	jz @@exit
	mov bx,0
	mov cx,100h
	mov dx,offset pallet_buf
	mov ax,1017h      ; read pallet
	int 10h
@@exit:
	ret
save_palet endp

;=============
;restore_palet
;=============

	PUBLIC restore_palet
restore_palet PROC C
	mov ax,DGROUP
	mov es,ax
	call ifcolor
	jz @@exit
	call ifVGA
	jz @@exit
	mov bx,0
	mov cx,100h
	mov dx,offset pallet_buf
	mov ax,1012h      ; read pallet
	int 10h
@@exit:
	ret
restore_palet endp




;=============
;get_palet
;=============

	PUBLIC get_palet
get_palet PROC C  buf:DATAPTR

	call ifcolor
	jz @@exit
	call ifVGA
	jz @@exit
	les dx,buf
	mov bx,0
	mov cx,100h
	mov ax,1017h      ; read pallet
	int 10h
@@exit:
	ret
get_palet endp

;=============
;put_palet
;=============

	PUBLIC put_palet
put_palet PROC C buf:DATAPTR

	call ifcolor
	jz @@exit
	call ifVGA
	jz @@exit
	les dx,buf
	mov bx,0
	mov cx,100h
	mov ax,1012h      ; read pallet
	int 10h
@@exit:
	ret
put_palet endp

;========
;getcolor
;========

;     Donne les composantes rouge/vert/bleu d'une couleur.
;     warning this is done different if only EGA is available

	PUBLIC getcolor
getcolor PROC C color:WORD, pred:DATAPTR, pgreen:DATAPTR, pblue:DATAPTR
	push ds
	call ifcolor
	jz @@bw
	call ifVGA
	jnz @@vga
@@bw:
@@ega:  mov si,offset pallet_rgb
	mov bx,color
	add si,bx
	shl bx,1
	add si,bx       ; si + 3*bx
	les bx,pred
	lodsb
	shl ax,10
	mov es:[bx],ax
	les bx,pgreen
	lodsb
	shl ax,10
	mov ds:[bx],ax
	les bx,pblue
	lodsb
	shl ax,10
	mov es:[bx],ax
	jmp @@exit
@@vga:  call wait_r
	mov dx,3c7h     ; read pallete entry
	mov bx,color
	mov al,defpal[bx]
	out dx,al
	inc dx
	inc dx
	lds bx,pred
	in al,dx
	shl ax,10
	mov [bx],ax
	lds bx,pgreen
	in al,dx
	shl ax,10
	mov [bx],ax
	lds bx,pblue
	in al,dx
	shl ax,10
	mov [bx],ax
@@exit: pop ds
	ret
getcolor endp

;-------------
;tcol_loadclut
;-------------

;     Modifie la clut en fonction de la table d'une image.

	PUBLIC tcol_loadclut
tcol_loadclut PROC C ptable:DATAPTR
	push ds
	push si
	call ifcolor
	jz @@exit
	mov ax,DGROUP
	mov es,ax
	call wait_r
	lds si,ptable
	mov cx,16
	mov dx,3c8h
	xor bx,bx
@@rgb:  mov al,es:defpal[bx]
	out dx,al
	inc dx
	lodsb
	out dx,al
	lodsb
	out dx,al
	lodsb
	out dx,al
	dec dx
	inc bx
	loop @@rgb
@@exit: pop si
	pop ds
	ret
tcol_loadclut endp


sendchar macro char
	push dx
	mov ah,5
	mov dl,char
	int 21h
	pop dx
	endm

;=======================
;send cod seq to printer
;=======================
sendcod proc near
@@ncod: mov ah,5
	mov dl,[si]
	cmp dl,0
	jz @@ecod
	int 21h
	inc si
	jmp @@ncod
@@ecod: ret
sendcod endp

;=========================
; do nothing error handler

do_nothing_int24h  proc far
	mov al,0
	iret
do_nothing_int24h  endp

;============================
;enable/disable error handler
;============================
	PUBLIC error_handler
error_handler PROC C on_off:WORD
	cmp word ptr on_off,1
	jz @@on
@@off:  cli
	cmp valid24,0
	jnz @@exit
	xor ax,ax
	mov es,ax
	mov bx,4 * 24h
	mov ax,es:[bx]
	mov old24h,ax
	mov ax,es:[bx+2]
	mov old24h+2,ax
	mov ax,offset do_nothing_int24h
	mov es:[bx],ax
	mov ax,cs
	mov es:[bx+2],ax
	sti
	mov valid24,1
	jmp @@exit
@@on:   cmp valid24,1
	jnz @@exit
	cli
	xor ax,ax
	mov es,ax
	mov bx,4 * 24h
	mov ax,old24h
	mov es:[bx],ax
	mov ax,old24h+2
	mov es:[bx+2],ax
	sti
	mov valid24,0
@@exit: ret
error_handler endp

;=========================
; printer error handler

int24h  proc far
	push ds
	mov ax,DGROUP
	mov ds,ax
	mov printer_online,0
	pop ds
	mov al,0
	iret
int24h  endp

;=========================
;test if printer is online
;=========================
	PUBLIC C inittestprinter
inittestprinter proc
	mov printer_online,1
	cli
	xor ax,ax
	mov es,ax
	mov bx,4 * 24h
	mov ax,es:[bx]
	mov old24h,ax
	mov ax,es:[bx+2]
	mov old24h+2,ax
	mov ax,offset int24h
	mov es:[bx],ax
	mov ax,cs
	mov es:[bx+2],ax

	sti
	sendchar 0dh    ; try to send a CR
	sti

	mov ax, printer_online
	ret
inittestprinter endp



;=========================
;test if printer is online
;=========================
	PUBLIC C testprinter

testprinter proc
;	sendchar 0dh    ; try to send a CR
	sti
	mov ax, printer_online
	ret
testprinter endp




;=========================
;deinit printer test
;=========================
	PUBLIC C endtestprinter
endtestprinter proc
	cli
	xor ax,ax
	mov es,ax
	mov bx,4 * 24h
	mov ax,old24h
	mov es:[bx],ax
	mov ax,old24h+2
	mov es:[bx+2],ax
	sti
	ret
endtestprinter endp




;================================
;decide if the pixel is on or off
;================================
pixcolor proc near
	mov ah,0dh      ; read pixel dot
	mov bh,0        ; page number
	add dx,y
	cmp dx,dry
	jnc @@exit
	mov cx,x
	int 10h
	and dl,3        ; 4 rows patterns
	mov bl,dl
	shl bx,3
	add bx,offset printer_pattern
	and ax,0fh      ; only 16 colors available
	add bx,ax
	test ax,8
	jz @@nadd
	add bx,3*8
@@nadd: mov al,[bx]
	and cl,3        ; 4 columns patterns
	inc cl
	shr al,cl
@@exit: ret
pixcolor endp

;=======================================
;compute each byte to be sent to printer
;=======================================
each_byte proc near
	mov dx,0
@@pix:  push dx
	call pixcolor
	pop dx
	rcl pixbyte,1
	inc dx
	cmp dx,8
	jnz @@pix
	sendchar pixbyte
	ret
each_byte endp

;===========
;printscreen
;===========

;       Imprime une copie de l'ecran.
;       imprime la sous-fenetre

	PUBLIC printscreen
printscreen PROC C ulx:WORD,uly:WORD,drx:WORD,dry:WORD
	local x:WORD,y:WORD,pixbyte:BYTE
	call testprinter
	jc @@exit
	mov si,offset stseq
	call sendcod

	mov ax,uly
	mov y,ax
	mov cx,dry
	sub cx,uly
	shr cx,3
	inc cx                  ; nr of passages
gr_lp:  push cx
	mov ax,ulx
	mov x,ax

	mov cx,630
	add cx,ulx
	sub cx,drx
	jc @@no_left_margin
	shr cx,1                ; compute left margin
	mov si,offset gracod
	call sendcod
	sendchar cl
	sendchar ch
@@l_10:
	sendchar 0
	loop @@l_10             ; left margin
@@no_left_margin:

	mov si,offset gracod
	call sendcod
	mov cx,drx
	sub cx,ulx
	sendchar cl
	sendchar ch
@@l_11:
	push cx
	call each_byte
	pop cx
	inc x
	loop @@l_11
	mov si,offset crcod
	call sendcod

	add y,8
	pop cx
	loop gr_lp

	mov si,offset endseq
	call sendcod
@@exit: ret
printscreen endp


;================
; screen on / off
;================

	PUBLIC screen
screen PROC C on_off:WORD,bcol:WORD
	mov dx,3dah
	in al,dx        ; reset register to address mode
	xchg bx,bx
	xchg bx,bx
	mov dx,3c0h
	mov al,11h
	out dx,al
	xchg bx,bx
	xchg bx,bx
	mov ax,bcol     ; border color
	out dx,al
	xchg bx,bx
	xchg bx,bx
	mov ax,on_off
	mov cl,5
	shl ax,cl
	out dx,al
	xchg bx,bx
	xchg bx,bx
	mov dx,3dah
	in al,dx        ; reset register to address mode
	ret
screen ENDP

normalize MACRO point
	mov ax,word ptr point
	shr ax,4
	add word ptr point+2,ax
	and word ptr point,0fh
	endm

;=============================================
; Expand a loaded image b&w or color in memory
;=============================================

	PUBLIC decode_image
decode_image PROC C sourcedata:DATAPTR, destdata:DATAPTR, bits:WORD
	push di si
	les di,sourcedata
	mov word ptr source_pt,di
	mov word ptr source_pt+2,es
	les di,destdata
	mov word ptr dest_pt,di
	mov word ptr dest_pt+2,es
	mov cx,bits
@@blocks:
	push cx
	normalize source_pt
	normalize dest_pt
	les di,source_pt
	mov ax,es:[di]  ; block count
	mov cmplgt,ax
;       mov ax,es:[di+2]; block exp length
	add word ptr source_pt,4
	mov ax,ds
	mov es,ax
	push bp
	call lzdecompress
	pop bp
	pop cx
	loop @@blocks
	pop si di
	ret
decode_image endp


;============
;select_plane
;============

	PUBLIC select_plane
select_plane PROC C plane:WORD
	mov cx,plane
	mov ah,cl
	mov al,4        ; read map select register
	mov dx,3ceh
	out dx,ax
	mov ah,1
	shl ah,cl
	mov al,2        ; map mask (write plane in al)
	mov dx,3c4h     ; sequencer
	out dx,ax
	ret
select_plane endp



;=================================================
; Expand a loaded image b&w or color on the screen
;=================================================

	PUBLIC decode_screen
decode_screen PROC C sourcedata:DATAPTR, bits:WORD
	push di si
	les di,sourcedata
	mov word ptr source_pt,di
	mov word ptr source_pt+2,es
	mov word ptr dest_pt + 2,0a000h  ; video segment
	xor cx,cx
@@blocks:
	push cx
	cmp bits,1
	jz @@noplane
	call select_plane
@@noplane:
	les di,source_pt
	mov ax,es:[di]  ; block count
	mov cmplgt,ax
;       mov ax,es:[di+2]; block exp length
	add word ptr source_pt,4
	mov word ptr dest_pt,0
	mov ax,ds
	mov es,ax
	push bp
	call lzdecompress
	pop bp
	pop cx
	inc cx
	cmp cx,bits
	jnz @@blocks

	pop si di
	ret
decode_screen endp


	PUBLIC select_all_planes
select_all_planes PROC C
;	mov cx,plane
;	mov ah,cl
;	mov al,4        ; read map select register
;	mov dx,3ceh
;	out dx,ax

	mov ah,0fh
	mov al,2        ; map mask (write plane in al)
	mov dx,3c4h     ; sequencer
	out dx,ax
	ret
select_all_planes endp




	PUBLIC zap_screen
zap_screen PROC C
	call	select_all_planes
	mov	ax,0a000h
	mov	es,ax
	xor	bx,bx
	mov	dx, 00h

	mov	ax, 14000 * 2

@@zap:
	mov	es: word ptr [bx], dx
	add	bx, 2
	cmp	bx, ax
	jne	@@zap

	ret
zap_screen endp




	PUBLIC graphic_mode
graphic_mode PROC C
	call ifEGA
	mov ax,1        ; signal error if not at least EGA
	jz @@exit
	mov ax,grmode   ; mode 0fh for monocrome and 10h for color
	int 10h
	mov ax,0        ; border color
	push ax
	mov ax,1        ; screen on
	push ax
	call screen
	add sp,4
	xor ax,ax       ; no error
@@exit:
	ret
graphic_mode endp

	PUBLIC text_mode
text_mode PROC C
	xor ax,ax       ; restore col 0 to black
	call modcolor C,ax,ax,ax,ax
	mov ax,3
	int 10h         ; text mode
	ret
text_mode endp

	PUBLIC text2_mode
text2_mode PROC C
	xor ax,ax       ; restore col 0 to black
	call modcolor C,ax,ax,ax,ax
	mov ax,1
	int 10h         ; text mode
	mov ah,1
	mov cx,2000h
	int 10h         ; hide cursor
	ret
text2_mode endp

	PUBLIC save_video_mode
save_video_mode PROC C
	mov ah,0fh
	int 10h         ; querry video mode
	mov video_mode,al
	ret
save_video_mode endp

	PUBLIC restore_video_mode
restore_video_mode PROC C
	xor ax,ax       ; restore col 0 to black
	call modcolor C,ax,ax,ax,ax
	mov ah,0
	mov al,video_mode
	int 10h         ; restore video mode
	ret
restore_video_mode endp

;====================
; Decompression routine
;====================
;;;;;;;;;;;;;;;;;;;;;;;; limpel-ziv algorithm ;;;;;;;;;;;;;;;;;;;;;
;Constants
CLEAR           equ     256             ;Clear code
EOF             equ     257             ;End of file marker
FIRST_FREE      equ     258             ;First free code
MAXMAX          equ     4096            ;Max code + 1

.DATA
input_data      db      1024 dup (?)
input_offset    dw      0
input_size      dw      0

output_data     db      1024 dup (?)
output_offset   dw      0

hash            db      3*1000h dup (?)

cur_code        dw      ?
old_code        dw      ?
in_code         dw      ?
free_code       dw      FIRST_FREE
stack_count     dw      0
nbits           dw      9
max_code        dw      512
fin_char        db      ?
k               db      ?

masks           dw      1ffh,3ffh,7ffh,0fffh
bit_offset      dw      0

cmplgt   dw ?
uncmplgt dw ?

dest_pt   dd ?
source_pt dd ?

.CODE
lzhd_read proc near
	cmp cx,cmplgt
	jna @@no_dep
	mov cx,cmplgt
@@no_dep:
	push ds cx
	lds si,source_pt
	rep movsb
	pop  cx ds
	add word ptr source_pt,cx
	sub cmplgt,cx
	ret
lzhd_read endp

lzhd_write proc near
	push es cx
	les di,dest_pt
	rep movsb
	pop cx es
	add word ptr dest_pt,cx
	ret
lzhd_write endp

init_lzh proc near
	xor ax,ax
	mov input_offset,ax
	mov input_size,ax
	mov output_offset,ax
	mov stack_count,ax
	mov bit_offset,ax
	mov free_code,FIRST_FREE
	mov nbits,9
	mov max_code,512
	ret
init_lzh endp

;;;;;;;;;;;;;;;;;;;;;;; decompress limpel-ziev algorithm ;;;;;;;;;;;;;;;;;;;

;Hash table entry
dhash_rec       struc
dnext   dw      ?                       ; prefix code
dchar   db      ?                       ; suffix char
dhash_rec       ends

lzdecompress    proc    near
	call    init_lzh
	lea     di,input_data           ;Read from input
	mov     cx,1024
	call    lzhd_read
@@l1:   call    read_code               ;Get a code
	cmp     ax,EOF                  ;End of file?
	jne     @@l2                    ;no

	cmp     output_offset,0         ;Data in output buffer?
	je      @@l1a                   ;no
	lea     si,output_data          ;Flush buffer
	mov     cx,output_offset
	call    lzhd_write
@@l1a:  ret                             ;done

@@l2:   cmp     ax,CLEAR                ;Clear code?
	jne     @@l7                    ;no

	call    init_tab                ;Initialize table
	call    read_code               ;Read next code
	mov     cur_code,ax             ;Initialize variables
	mov     old_code,ax
	mov     k,al
	mov     fin_char,al
	call    write_char              ;Write character
	jmp     @@l1                    ;Get next code

@@l7:   mov     cur_code,ax             ;Save new code
	mov     in_code,ax
	cmp     ax,free_code            ;Code in table? (k<w>k<w>k)
	jl      @@l11                   ;yes
	mov     ax,old_code             ;get previous code
	mov     cur_code,ax             ;make current
	mov     al,fin_char             ;get old last char
	push    ax                      ;push it
	inc     stack_count
@@l11:  cmp     cur_code,255            ;Code or character?
	jle     @@l15                   ;Char

	mov     bx,cur_code             ;Convert code to address
	mov     bp,bx                   ;bx = bx * 3 (3 byte entries)
	shl     bx,1                    ;bp = bx
	add     bx,bp                   ;bx = bx * 2 + bp
	add     bx,offset hash
	mov     al,[bx+2]               ;Get suffix char
	push    ax                      ;push it
	inc     stack_count
	mov     ax,[bx]                 ;Get prefix code
	mov     cur_code,ax             ;Save it
	jmp     @@l11                   ;Translate again

@@l15:
	mov     ax,cur_code             ;Get code
	mov     fin_char,al             ;Save as final, k
	mov     k,al
	push    ax                      ;Push it
	inc     stack_count
	mov     cx,stack_count          ;Pop stack
	jcxz    @@l18                   ;If anything there
@@l17:  pop     ax
	call    write_char
	loop    @@l17
@@l18:  mov     stack_count,cx          ;Clear count on stack
	call    dadd_code               ;Add new code to table
	mov     ax,in_code              ;Save input code
	mov     old_code,ax
	mov     bx,free_code            ;Hit table limit?
	cmp     bx,max_code
	jl      @@l23                   ;Less means no
	cmp     nbits,12                ;Still within twelve bits?
	je      @@l23                   ;no (next code should be clear)
	inc     nbits                   ;Increase code size
	shl     max_code,1              ;Double max code
@@l23:  jmp     @@l1                    ;Get next code
lzdecompress    endp

read_code       proc    near
	mov     ax,bit_offset           ;Get bit offset
	add     ax,nbits                ;Adjust by code size
	xchg    bit_offset,ax           ;Swap

	mov     dx,ax                   ;Calculate byte offset
	and     dx,7
	mov     cx,3
	shr     ax,cl

	cmp     ax,1021                 ;Approaching end of buffer?
	jl      @@rd0                   ;no

	push    dx                      ;Save offset in byte
	add     dx,nbits                ;Calculate new bit offset
	mov     bit_offset,dx
	mov     cx,1024                 ;1k buffer
	mov     bp,ax                   ;save byte offset
	sub     cx,ax                   ;Calculate bytes left
	mov     di,offset input_data    ;TH Point to beginning of buffer
	add     ax,di                   ;TH Point to char

	mov     si,ax
rep     movsb                           ;Move last chars down
	mov     cx,bp
	call    lzhd_read
	xor     ax,ax                   ;Clear ax
	pop     dx                      ;Restore offset in byte
@@rd0:  add     ax,offset input_data    ;Point to char
	mov     si,ax
	lodsw                           ;Get word
	mov     bx,ax                   ;Save in AX
	lodsb                           ;Next byte
	mov     cx,dx                   ;Offset in byte
	jcxz    @@rd2                   ;If zero, skip shifts
@@rd1:  shr     al,1                    ;Put code in low (code size) bits of BX
	rcr     bx,1
	loop    @@rd1
@@rd2:  mov     ax,bx                   ;put code in ax
	mov     bx,nbits                ;mask off unwanted bits
	sub     bx,9
	shl     bx,1
	and     ax,masks[bx]
	ret
read_code       endp

init_tab        proc    near
	mov     nbits,9                 ;Initialize variables
	mov     max_code,512
	mov     free_code,FIRST_FREE
	ret
init_tab        endp

write_char      proc    near
	mov     di,output_offset        ;Get offset in buffer
	cmp     di,1024                 ;Full?
	jl      @@wc1                   ;no
	push    ax                      ;Save registers
	push    cx
	lea     si,output_data          ;Write buffer to file
	mov     cx,di
	call    lzhd_write
	pop     cx
	pop     ax
	xor     di,di                   ;Point to beginning of buffer
	mov     output_offset,di
@@wc1:  lea     di,output_data[di]      ;Point into buffer
	stosb                           ;Store char
	inc     output_offset           ;Increment number of chars in buffer
	ret
write_char      endp

dadd_code       proc    near
	mov     bx,free_code            ;Get new code
	mov     bp,bx                   ;bx = bx * 3 (3 byte entries)
	shl     bx,1                    ;bp = bx
	add     bx,bp                   ;bx = bx * 2 + bp
	add     bx,offset hash
	mov     al,k                    ;get suffix char
	mov     [bx].dchar,al           ;save it
	mov     ax,old_code             ;get prefix code
	mov     [bx].dnext,ax           ;save it
	inc     free_code               ;set next code
	ret
dadd_code       endp

	END
