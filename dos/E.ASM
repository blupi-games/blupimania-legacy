
son_1	db 48,48,48,48,48,52,52,52,52,52,55,55,55,55,55
	db 60,60,60,60,60,60,60,60,60,60
	db 36,36,36,36,36,36,36,36,36,36,-1
son_2	glis <117,400,1500>
	db -1

vit equ 103
BEG EQU 100
EEND EQU 200
PAS EQU 10
son_3   glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	glis <vit, beg + 2 * PAS ,Eend + 2 * PAS>
	glis <vit, beg + 3 * PAS ,Eend + 3 * PAS>
	glis <vit, beg + 4 * PAS ,Eend + 4 * PAS>
	glis <vit, beg + 5 * PAS ,Eend + 5 * PAS>
	glis <vit, beg + 6 * PAS ,Eend + 6 * PAS>
	glis <vit, beg + 7 * PAS ,Eend + 7 * PAS>
	glis <vit, beg + 8 * PAS ,Eend + 8 * PAS>
	glis <vit, beg + 9 * PAS ,Eend + 9 * PAS>
	glis <vit, beg + 10 * PAS ,Eend + 10 * PAS>



;	,<vit,60, 260>,<vit,80, 280>
;	glis <vit,100,300>,<vit,120,320>,<vit,140,340>
;	glis <vit,160,360>,<vit,180,380>,<vit,200,400>
;
;	glis <102,300,1200>,<102,400,1300>,<102,500,1400>
;	glis <120,1000,1100>,<120,1000,1100>,<120,1000,1100>
	db -1
son_4	db 8 dup (15)
	db 8 dup (10)
	db -1

;	glis <108,400,700>
;	glis <107,700,500>
	db -1
son_5	db 0,-1

	db 205,210,215,220,225,230,235,240,245,250,254
	db -1

son_7	glis <101,50, 200>
	glis <101,200,400>
	glis <101,400,600>
	glis <101,600,800>
	glis <101,800,1000>
	glis <101,1000,1200>
	glis <101,1200,1400>
	glis <101,1400,1600>
	glis <101,1600,1800>
	glis <101,1800,2000>
	glis <101,2300,2800>
	glis <101,3400,3800>
	db   0,0,0,0,0
	glis <102,50, 200>
	glis <101,100,300>
	glis <101,200,400>
	glis <101,300,500>
	glis <102,400,600>
	glis <101,500,700>
	glis <101,600,800>
	glis <101,800,1000>
	db   0,0,0,0,0
	glis <102,800,1000>
	glis <102,700,900>
	glis <102,600,800>
	glis <102,500,700>
	glis <102,400,600>
	glis <102,300,500>
	glis <102,200,400>
	glis <102,100,300>
	glis <102,50, 200>
	db -1


son_8	db 12,12,12,12,24,24,24,24
	db 36,36,36,36,48,48,48,48,60,60,60,60
	db -1
son_9	glis <150,1000,800>
son_14	glis <103,800,1000>
	glis <103,700,900>
	glis <103,600,800>
	glis <103,500,700>
	glis <103,400,600>
	glis <103,300,500>
	glis <103,200,400>
	glis <103,100,300>
	glis <103,50, 200>
	db -1

son_10	glis <101,100,150>
	glis <101,125,175>
	glis <101,150,200>
	glis <101,175,225>
	glis <101,200,250>
	glis <101,225,275>
	glis <101,250,300>
	glis <101,275,325>
	glis <101,300,350>
	glis <101,325,375>
	db -1


son_11	db 48,50,52,53,55,57,59,60
	db -1

son_13	glis <101,275,325>
	glis <101,300,350>
	glis <101,325,375>
	glis <101,350,400>
	db -1

son_15	glis <117, 1500,400>
	db -1

son_16	glis <vit, beg + 10 * PAS ,Eend + 10 * PAS>
	glis <vit, beg + 9 * PAS ,Eend + 9 * PAS>
	glis <vit, beg + 8 * PAS ,Eend + 8 * PAS>
	glis <vit, beg + 7 * PAS ,Eend + 7 * PAS>
	glis <vit, beg + 6 * PAS ,Eend + 6 * PAS>
	glis <vit, beg + 5 * PAS ,Eend + 5 * PAS>
	glis <vit, beg + 4 * PAS ,Eend + 4 * PAS>
	glis <vit, beg + 3 * PAS ,Eend + 3 * PAS>
	glis <vit, beg + 2 * PAS ,Eend + 2 * PAS>
	glis <vit, beg + 1 * PAS ,Eend + 1 * PAS>
	db -1

son_17	db 5 dup (40), 5 dup (39), 5 dup (37), 5 dup (39),5 dup (40),-1
son_18	db 5 dup (40), 5 dup (39), 5 dup (37), 5 dup (35), 5 dup (33),-1
son_19	glis <101,25,75>
	glis <101,50,100>
	glis <101,75,125>
	glis <101,100,150>
	glis <101,125,175>
	glis <101,150,200>
	db -1

	db -1
son_20	glis <160,1000,900>
	db -1
son_21	db 13,14,14,14,13,-1
son_22	db 16,5,4,3,2,-1
son_23	db 210,-1
son_24	db 60,60,60,-1
son_25	db 48,48,48,-1
son_26	db 2,8,2,8,-1
son_27	db 2
        db -1
son_28	db 36,36,36,36,40,40,40,40,43,43,43,43
	db 48,48,48,48,-1
son_29	db 12,12,12,12,12,12,12,12,12,12,12,12
	db 11,11,11,11,11,11,11,11,11,11,11,11
	db 10,10,10,10,10,10,10,10,10,10,10,10
	db 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
	db -1
son_30	db 24,24,24,24,24,24,24,24,24,24,24,24
	db 24,24,24,24,24,24,24,24,24,24,24,24
	db 19,19,19,19,19,19,19,19,19,19,19,19
        db 19,19,19,19,19,19,19,19,19,19,19,19,-1
	even

.CODE

	PUBLIC C timer_int
timer_int proc far
	push es
	push ds
	push dx
	push cx
	push bx
	push ax
	mov ax,DGROUP
	mov ds,ax
	inc cntime

IF 0	; ce n'est plus la peine avec la musique
	inc trigger
	test trigger,3
	jnz @@mine
	pushf
	call dword ptr [old_int8]
@@mine:
ENDIF
	mov al,20h
	out 20h,al
	test sound_onoff,1
	jz @@exit
        test music_onoff,1
	jz @@moff
	mov bx,music_time
	shr bx,3
	mov al,music[bx]
	cmp al,-1
	jnz @@play
	mov music_time,0
@@play: call pitch
	call toneset
	inc music_time
@@moff: cmp filsson,0
	jz @@exit
	cmp sound_time,0
	jnz @@not_init
	test music_onoff,1
	jnz @@non
	call toneon
@@non:	mov bx,filsson
	dec bx
	shl bx,1
	mov bx,tabl_snd[bx]
	mov sound_point,bx
@@not_init:
	mov bx,sound_point
        mov al,[bx]
	cmp al,-1		; final tone
	jnz @@norm
	mov sound_time,0	; recycle
	cmp filsrep,0
	jz @@stopit
	cmp filsrep,-1
	jz @@exit
	dec filsrep
	jmp @@exit
@@stopit:
	mov filsson,0
	test music_onoff,1
	jnz @@noff
        call toneoff
@@noff: jmp @@exit
@@norm: cmp al,100
	jc @@note
	cmp al,200
	jc @@glis
	; generate white noise (this will slow down the proccesor)
	sub al,200
	mov ch,al
	shl cx,2
	mov ax,0f000h	; Bios ROM
	mov es,ax
	mov bx,0a000h
	in al,61h
@@lp:	test byte ptr es:[bx],1
	jz @@off
	or al,3
	jmp @@on
@@off:	and al,NOT 3
@@on:	out 61h,al
	inc bx
	loop @@lp
	or al,3
	out 61h,al
	jmp @@next
@@glis: cmp glis_time,0
	jnz @@glisit
	sub al,100		; al length in 55/4 ms
        xor cx,cx
	xor dx,dx
	mov cl,al
        mov glis_time,cl
	mov ax,[bx+3]
	sub ax,[bx+1]
	sbb dx,0
	idiv cx
	mov glis_inc,ax
	mov ax,[bx+1]
	mov glis_freq,ax
@@glisit:mov cx,glis_freq
	call freq
	call toneset
	mov ax,glis_inc
	add glis_freq,ax
	dec glis_time
	jnz @@inc
	add sound_point,5	; skip command
	jmp @@inc
@@note: call pitch
	call toneset
@@next: inc sound_point
@@inc:	inc sound_time
@@exit: pop ax
	pop bx
	pop cx
	pop dx
	pop ds
	pop es
	ret
timer_int endp



keyboard_int proc far
	push ds
	push ax
	push dx
	mov ax,DGROUP
	mov ds,ax
	in al,60h


;	cmp al,02ah
;	jne nosh
;
;lll:    in al,60h
;	cmp al,01ch
;	jne lll
;
;nosh:

	push es
	push ax
	xor ax, ax
	mov es, ax
	mov al, byte ptr es:[0417h]
	and al,0dfh
	mov byte ptr es:[0417h], al
	pop ax
	pop es

	mov dx, 1
	cmp al, 039h
	je  spon
	mov dx, 0
	cmp al, 0b9h
	jne spoff
spon:	mov byte ptr state_space, dl
	call clearfifo
spoff:

	mov dx, 1
	cmp al, 04bh
	je  lon
	mov dx, 0
	cmp al, 0cbh
	jne loff
lon:	mov byte ptr state_left, dl
	call clearfifo
loff:

	mov dx, 1
	cmp al, 04dh
	je  ron
	mov dx, 0
	cmp al, 0cdh
	jne roff
ron:	mov byte ptr state_right, dl
	call clearfifo
roff:

	mov byte ptr Key_Code,al
	pushf

	cmp byte ptr keyison, 0
	jne kkeyon
	call clearfifo


kkeyon:
	call dword ptr [old_int9]

endkey:
	pop dx
	pop ax
	pop ds
	iret
keyboard_int endp


clearfifo:
	push es
	mov ax, 40h
	mov es, ax
	mov ax, es:[01ch]
        mov es:[01ah], ax
	pop es
	ret

;routine to select tone
toneset proc near
;load the time period into the timer
	mov al,cl	;lower byte
	out 042h,al	;out to timer
	mov al,ch	;upper byte
	out 042h,al	;out to timer
	ret
toneset endp

	PUBLIC toneon
;routine to turn on tone
toneon	proc C
;turn speaker and timer on
	in al,061h	;get contents of system port B
	or al,3 	;turn speaker and timer on
	out 061h,al	;send out new values to port B
	ret
toneon	endp

	PUBLIC toneoff
;routine to turn tone off
toneoff proc C
;turn off timer2 and speaker
	in al,061h		;get port B
	and al,11111100b	;turn off timer and speaker
	out 061h,al
	ret
toneoff endp

freq	proc near
	push dx
	mov dx,12h
	mov ax,34deh
	div cx
	mov cx,ax
	pop dx
	ret
freq	endp

pitch	proc near
	mov ah,0
	mov cl,12
	div cl
	mov dl,al
	mov al,ah
	cbw
	sal ax,1
	mov bx,ax
	mov cx,notes[bx]
	call freq
	xchg cx,dx
	sub cl,4
	jnc @@sr
	neg cl
	and cl,7
	shl dx,cl
	jmp @@dd
@@sr:	shr dx,cl
@@dd:	xchg cx,dx
        ret
pitch	endp

	PUBLIC trap_interrupts
trap_interrupts PROC C

	xor ax,ax
	mov es,ax
	cli

	mov ax,es:[4*8]
	mov word ptr old_int8,ax
	mov ax,es:[4*8+2]
	mov word ptr old_int8+2,ax

; on n'initialise plus l'interrupt, il est appel‚
; par FMISR
;	mov ax,offset timer_int
;	mov es:[4*8],ax
;	mov ax,cs
;	mov es:[4*8+2],ax


        mov ax,es:[4*9]
	mov word ptr old_int9,ax
	mov ax,es:[4*9+2]
	mov word ptr old_int9+2,ax
	mov ax,offset keyboard_int
	mov es:[4*9],ax
	mov ax,cs
	mov es:[4*9+2],ax

;	mov al,36h
;	out 43h,al	; counter 0 in mode 3

;	mov al,0B6h
;	out 43h,al	; counter 2 in mode 3

;	mov ax,4000h    ; constant for 55/4 ms
;	out 40h,al
;	mov al,ah
;	out 40h,al

        sti
        ret
trap_interrupts ENDP

	PUBLIC release_interrupts
release_interrupts PROC C
        xor ax,ax
	mov es,ax
	cli
	mov ax,0	; constant for 55 ms
	out 40h,al
	mov al,ah
	out 40h,al
	mov ax,0554h	; constant for beep
	out 42h,al
	mov al,ah
	out 42h,al

;	mov ax,word ptr old_int8
;	mov es:[4*8],ax
;	mov ax,word ptr old_int8+2
;	mov es:[4*8+2],ax

	mov ax,word ptr old_int9
	mov es:[4*9],ax
	mov ax,word ptr old_int9+2
	mov es:[4*9+2],ax

	sti
        ret
release_interrupts ENDP

;========
;opentime
;========

;	 Indique le debut d'une operation plus ou moins longue
;	 (ne fait rien, enregistre simplement le temps absolu).

	PUBLIC opentime
opentime PROC C
	mov ax,cntime
	mov mtime,ax
	ret
opentime endp

;=========
;closetime
;=========

;	 Indique la fin d'une operation plus on moins longue,
;	 avec attente si la duree etait plus petite que le temps total souhaite.

	PUBLIC closetime
closetime PROC C t:WORD
	test speed_onoff,1
	jnz @@return
	cmp word ptr t,0
	jz @@return
	mov cx,t
	add cx,mtime
@@more: mov ax,cntime
	sub ax,cx	; ax = diff in 20 ms
	jge @@return
	cmp ax,-50
	jnc @@more	; do not wait more than 1 sec
@@return:
	ret
closetime endp

	PUBLIC vfy_mouse
vfy_mouse PROC C
	mov ax,0	; int mouse
	int 33h
	cmp ax,-1
	jnz not_supported_mouse
	mov int_port,21h
	mov ax,24h	; querry IRQ and type
	int 33h
	cmp cl,0
	jnz ok_irq
	cmp ch,4
	jnz not_supported_mouse
	mov int_port,0A1h
        mov cl,4
ok_irq: mov al,1
	shl al,cl
	mov int_mask,al
	mov ax,1
	jmp @@return
not_supported_mouse:
	mov ax,-1
@@return:
        ret
vfy_mouse endp

	PUBLIC disable_mouse
disable_mouse PROC C
	ret

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
	ret

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


; Gestion de la protection
; ------------------------


.DATA
oint78  dw ?,?
para3inch db 0DFh,2,25h,1,0Fh,0Eh,0FFh,36h,6Fh,0Fh,8
para5inch db 0DFh,2,25h,1,10h,20h,0FFh,32h,6Fh,0Fh,8
ident   db 'Emil Laurentiu',0
buffer  db 512 dup (?)

.CODE
	PUBLIC vfy_prot
vfy_prot PROC C
IFNDEF  DEBUG
	local drive:BYTE

	push ds
	pop es                  ; es = ds
; code ident string
	mov si,offset ident
	cmp byte ptr [si],'E'
	jnz @@fin
@@more1:lodsb
	cmp al,0
	jz @@fin
	xor al,55h
	mov [si-1],al
	jmp @@more1
@@fin:  mov ah,19h              ; get default drive
	int 21h
	cmp al,2
	jc diskette
; hard disk verify code
	mov cx,3                ; retries number
@@lp1:  push cx
	mov ah,2                ; read sector 3
	mov dl,80h              ; hard disk
	mov cx,3
	mov dh,ch
	mov al,1
	mov bx,offset buffer
	int 13h
	pop cx
	jnc oksec3
	loop @@lp1
	jmp ans_demo
oksec3:
	mov si,offset ident
	add bx,20h              ; !! changer ici la valeur
				; en fonction de chaque logiciel
				; BLUPI-M = 0, BLUPI-S = 10h
@@more2:lodsb
	cmp al,0
	jz ans_cont
	cmp al,[bx]
	jnz ans_demo
	inc bx
	jmp @@more2
diskette:
	mov drive,al
; read boot sector
	mov cx,3        ; retries
@@lpb:  push cx
	mov ah,2        ; read sector
	mov dl,drive
	mov cx,1
	mov dh,ch
	mov al,cl
	mov bx,offset buffer
	int 13h
	pop cx
	jnc okboot
	loop @@lpb
okboot:
	cmp [bx+13h],MIN_SECTORS
	jb ans_quit
	cmp [bx+13h],2 * 40 * 9         ; (360K 5")
	jz valueok
	cmp [bx+13h],2 * 80 * 15        ; (1.2M 5")
	jz valueok
	cmp [bx+13h],2 * 80 * 9         ; (720K 3")
	jz valueok
	cmp [bx+13h],2 * 80 * 18        ; (1.4M 3")
	jz valueok
	jmp ans_quit
valueok:
	xor ax,ax       ; save original para table
	mov es,ax
	mov di,4*1eh
	mov ax,es:[di]
	mov oint78,ax
	mov ax,es:[di+2]
	mov oint78+2,ax
	mov ax,offset para3inch
	cmp [bx+13h],2 * 80 * 9         ; (720K 3")
	jz tableok
	cmp [bx+13h],2 * 80 * 18        ; (1.4M 3")
	jz tableok
	mov ax,offset para5inch
tableok:
	stosw           ; change table
	mov ax,ds
	stosw
	push ds
	pop es          ; restore es
; read sector 3 and verify ident string
	mov cx,3        ; retries
@@lp2:  push cx
	mov ah,2        ; read sector
	mov dl,drive
	mov dh,1        ; head 1
	mov ch,79       ; track
	mov cl,3        ; sector
	mov al,1        ; read one sector
	mov bx,offset buffer
	int 13h
	pop cx
	jnc readok
	loop @@lp2
	mov ax,0        ; answer demo
	jmp restore
readok:
	mov si,offset ident
@@more3:lodsb
	cmp al,0
	jz vfyok
	cmp al,[bx]
	jnz vfyfailed
	inc bx
	jmp @@more3
vfyfailed:
	mov ax,0        ; answer demo
	jmp restore
vfyok:  mov ax,1        ; answer continue
restore:push ax
	xor ax,ax       ; restore parameter table
	mov es,ax
	mov di,4*1eh
	mov ax,oint78
	stosw
	mov ax,oint78+2
	stosw
	pop ax
	ret
ans_quit:
	mov ax,-1
	ret
ans_demo:
	mov ax,0
	ret
ans_cont:
ENDIF
	mov ax,1
	ret
vfy_prot endp

	END
