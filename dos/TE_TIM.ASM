
; set the variable below to limit the diskette size
; from which the game can still be runned
MIN_SECTORS     = 2 * 80 * 18    ; (720 K)


;DEBUG  =       1

locals
jumps

.MODEL LARGE,C

if @datasize NE 1
%OUT This program assumes that all data pointers are far
%OUT The memory models must be compact or large
ERR
endif

.DATA

old_int1b       dd     0
old_int8        dd     0
old_int9        dd     0

int_port        dw      0
int_mask        db      0ffh
trigger         db      0

	PUBLIC C cntime
cntime          dw      0,0
mtime           dw      0


	PUBLIC C keyison
keyison         db      1

	PUBLIC C filsson
filsson         dw      0       ; son a entendre
	PUBLIC C filsrep
filsrep         dw      0       ; pas de repetition
	PUBLIC C Key_Code
Key_Code        db     0        ; code of the last pressed / released key

	PUBLIC C state_up
state_up	db     0        ;
	PUBLIC C state_down
state_down	db     0        ;

	PUBLIC C state_right
state_right     db      0       ;
	PUBLIC C state_left
state_left      db     0        ;
	PUBLIC C sound_onoff
IFDEF   DEBUG
sound_onoff     db      0
ELSE
sound_onoff     db      1
ENDIF
	PUBLIC C music_onoff
music_onoff     db      0
	PUBLIC C speed_onoff
IFDEF   DEBUG
speed_onoff     db      1
ELSE
speed_onoff     db      0
ENDIF
	PUBLIC C demo_onoff
demo_onoff      db      0

;pitch table (octave 2)
notes   dw 1047    ; do
	dw 1109    ;
	dw 1175    ; re
	dw 1245    ;
	dw 1319    ; mi
	dw 1397    ; fa
	dw 1480    ;
	dw 1568    ; sol
	dw 1661    ;
	dw 1760    ; la
	dw 1865    ;
	dw 1976    ; si

music_time      dw      0
sound_time      dw      0
sound_point     dw      0
glis_freq       dw      0
glis_inc        dw      0
glis_time       db      0
pause           db      0
pauseend        db      0


glis    STRUC
	db ?    ;time
	dw ?    ;freq1
	dw ?    ;freq2
	ends

music   db 22,17,24,17,25,17,24,17,22,17,27,17,25,17,24,17,22,17,24,17,25,17
	db 27,17,29,17,27,17,25,17,24,17
	db 22,17,24,17,25,17,24,17,22,17,27,17,25,17,24,17,21,17,22,17,24,17,25,17
	db 27,17,29,17,25,17,24,17

	db 22,22,24,24,25,25,24,24,22,22,27,27,25,25,24,24,22,22,24,24,25,25
	db 27,27,29,29,27,27,25,25,24,24
	db 22,22,24,24,25,25,24,24,22,22,27,27,25,25,24,24,21,21,22,22,24,24,25,25
	db 27,27,29,29,25,25,24,24

	db 24,19,26,19,27,19,26,19,24,19,29,19,27,19,26,19,24,19,26,19,27,19
	db 29,19,31,19,29,19,27,19,26,19
	db 24,19,26,19,27,19,26,19,24,19,29,19,27,19,26,19,23,19,24,19,26,19,27,19
	db 29,19,31,19,27,19,26,19,-1

tabl_snd label word
	dw  son_1, son_2,  son_3,  son_4
	dw  son_5,  son_6,  son_7,  son_8
	dw  son_9,  son_10,  son_11,  son_12
	dw  son_13,  son_14,  son_15,  son_16
	dw  son_17,  son_18,  son_19,  son_20
	dw  son_21,  son_22,  son_23,  son_24
	dw  son_25,  son_26,  son_27,  son_28
	dw  son_29,  son_30,  son_31,  son_32
	dw  son_33,  son_34,  son_35,  son_36
	dw  son_37,  son_38, son_39, son_40, son_41

son_40 db -1

son_41 db -1



son_1	db 48,50,52,53,55,57,59,60
	db -1

son_2	glis <101,25,75>
	glis <101,50,100>
	glis <101,75,125>
	glis <101,100,150>
	glis <101,125,175>
;	glis <101,150,200>
	db -1


son_3	glis <180,700,600>
	db -1

son_4	glis <150,1000,800>
	glis <103,800,1000>
	glis <103,700,900>
	glis <103,600,800>
	glis <103,500,700>
	glis <103,400,600>
	glis <103,300,500>
	glis <103,200,400>
	glis <103,100,300>
	glis <103,50, 200>
	db -1

son_5   glis <106,201,300>
	glis <106,201+10,300+10>
	glis <106,201+20,300+20>
	glis <106,201+30,300+30>
	glis <106,201+40,300+40>
	glis <106,201+50,300+50>
	glis <106,201+60,300+60>
	glis <106,201+70,300+70>
	glis <106,201+80,300+80>
	glis <106,201+90,300+90>
	glis <106,201+100,300+100>
	glis <106,201+110,300+110>
	glis <106,201+120,300+120>
	glis <106,201+130,300+130>
	glis <106,201+140,300+140>
	glis <106,201+150,300+150>
	glis <106,201+160,300+160>
	glis <106,201+170,300+170>
	glis <106,201+180,300+180>
	glis <106,201+190,300+190>
	glis <106,201+200,300+200>
	glis <106,201+210,300+210>
	glis <106,201+220,300+220>
	glis <106,201+230,300+230>
	glis <106,201+240,300+240>
	glis <106,201+250,300+250>
	glis <106,201+260,300+260>

	db -1



son_6	db 6 dup (33)
	db 6 dup (30)
	db 6 dup (35)
	db 6 dup (30)
	db -1


son_7   glis <109, 400, 900>
	db   3 dup (0)
	glis <109, 400, 900>
	db   10 dup (0)
	glis <109, 400, 900>
	db -1

son_8   glis <102,33, 100>
	glis <102,50, 200>
	glis <102,100,300>
	glis <102,200,400>
	glis <102,300,500>
	glis <102,400,600>
	glis <102,500,700>
	glis <102,600,800>

	glis <102,50, 200>
	glis <102,100,300>
	glis <102,200,400>
	glis <102,300,500>
	glis <102,400,600>
	glis <102,500,700>
	glis <102,600,800>
	glis <102,700,900>

	glis <102,200,400>
	glis <102,300,500>
	glis <102,400,600>
	glis <102,500,700>
	glis <102,700,900>
	glis <102,800,1000>

	glis <102,600,800>
	glis <102,700,900>
	glis <102,800,1000>
	glis <102,900,1100>
	glis <102,1000,1200>
	glis <102,1100,1300>
	glis <102,1200,1400>

	glis <102,700,900>
	glis <102,800,1000>
	glis <102,900,1100>
	glis <102,1000,1200>
	glis <102,1100,1300>
	glis <102,1200,1400>
	glis <102,1300,1500>

	glis <102,800,1000>
	glis <102,900,1100>
	glis <102,1000,1200>
	glis <102,1100,1300>
	glis <102,1200,1400>
	glis <102,1300,1500>
	glis <102,1400,1600>

	db -1


son_9   glis <107,1000,1100>
	glis <107,900,1000>
	glis <107,800,900>
	glis <107,700,800>
	glis <107,650,750>
	glis <107,550,650>
	glis <107,500,550>
	db -1


VIT1 equ 103
BEG1 EQU 100
EEND1 EQU 400
PAS1 EQU 40
son_10  glis <vit1, beg1 + 1 * PAS1 ,Eend1 + 1 * PAS1>
	glis <vit1, beg1 + 2 * PAS1 ,Eend1 + 2 * PAS1>
	glis <vit1, beg1 + 3 * PAS1 ,Eend1 + 3 * PAS1>
	glis <vit1, beg1 + 4 * PAS1 ,Eend1 + 4 * PAS1>
	glis <vit1, beg1 + 5 * PAS1 ,Eend1 + 5 * PAS1>
	glis <vit1, beg1 + 6 * PAS1 ,Eend1 + 6 * PAS1>
	glis <vit1, beg1 + 7 * PAS1 ,Eend1 + 7 * PAS1>
	glis <vit1, beg1 + 8 * PAS1 ,Eend1 + 8 * PAS1>
	glis <vit1, beg1 + 9 * PAS1 ,Eend1 + 9 * PAS1>
	glis <vit1, beg1 + 10 * PAS1 ,Eend1 + 10 * PAS1>
	glis <vit1, beg1 + 11 * PAS1 ,Eend1 + 11 * PAS1>
	glis <vit1, beg1 + 12 * PAS1 ,Eend1 + 12 * PAS1>
	glis <vit1, beg1 + 13 * PAS1 ,Eend1 + 13 * PAS1>
	glis <vit1, beg1 + 14 * PAS1 ,Eend1 + 14 * PAS1>
	glis <vit1, beg1 + 15 * PAS1 ,Eend1 + 15 * PAS1>

	db -1

son_11	db -1
son_12	db -1


son_13  glis <119, 400,1800>
	db -1

son_14	glis <111,500,900>
	glis <111,400,800>
	glis <111,300,700>
	glis <115,200,600>
	glis <115,150,550>
	db  -1

son_15	glis <108,500,900>
	glis <107,800,400>
	db -1



son_16	glis <101,100,150>
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

son_17	glis <108,700,1000>
	glis <110,1000,700>
	db -1

VIT1 equ 103
BEG1 EQU 100
EEND1 EQU 400
PAS1 EQU 40

son_18  glis <vit1, beg1 + 15 * PAS1 ,Eend1 + 15 * PAS1>
	glis <vit1, beg1 + 14 * PAS1 ,Eend1 + 14 * PAS1>
	glis <vit1, beg1 + 13 * PAS1 ,Eend1 + 13 * PAS1>
	glis <vit1, beg1 + 12 * PAS1 ,Eend1 + 12 * PAS1>
	glis <vit1, beg1 + 11 * PAS1 ,Eend1 + 11 * PAS1>
	glis <vit1, beg1 + 10 * PAS1 ,Eend1 + 10 * PAS1>
	glis <vit1, beg1 + 9 * PAS1 ,Eend1 + 9 * PAS1>
	glis <vit1, beg1 + 8 * PAS1 ,Eend1 + 8 * PAS1>
	glis <vit1, beg1 + 7 * PAS1 ,Eend1 + 7 * PAS1>
	glis <vit1, beg1 + 6 * PAS1 ,Eend1 + 6 * PAS1>
	glis <vit1, beg1 + 5 * PAS1 ,Eend1 + 5 * PAS1>
	glis <vit1, beg1 + 4 * PAS1 ,Eend1 + 4 * PAS1>
	glis <vit1, beg1 + 3 * PAS1 ,Eend1 + 3 * PAS1>
	glis <vit1, beg1 + 2 * PAS1 ,Eend1 + 2 * PAS1>
	glis <vit1, beg1 + 1 * PAS1 ,Eend1 + 1 * PAS1>
	db -1

son_19 db -1


son_20	db 5 dup (40), 5 dup (39), 5 dup (37), 5 dup (39),5 dup (40),-1

son_21	glis <101,100,150>
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

son_22 db 26,26,26,26,26,26
	db 29,29,29,29,29,29
	db 27,27,27,27,27,27
	db 25,25,25,25,25,25
	db 28,28,28,28,28,28,28
	db,-1

	glis <101,325,375>
	glis <101,300,350>
	glis <101,275,325>
	glis <101,250,300>
	glis <101,225,275>
	glis <101,200,250>
	glis <101,175,225>
	glis <101,150,200>
	glis <101,125,175>
	glis <101,100,150>
	db -1


son_23  glis <101,100,150>
	glis <101,125,175>
	glis <101,150,200>
	glis <101,175,225>
	glis <101,200,250>
	glis <101,225,275>
	glis <101,250,300>
	glis <101,275,325>
	glis <101,300,350>
;	glis <101,100,150>
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

son_24 glis <106,200,400>
	glis <106,300,500>
	db -1


son_25   glis <103,201,300>
	glis <102,201+10,300+10>
	glis <102,201+30,300+30>
	glis <102,201+50,300+50>
	glis <102,201+70,300+70>
	glis <102,201+90,300+90>
	glis <102,201+110,300+110>
	glis <102,201+130,300+130>
	glis <102,201+140,300+140>
	glis <102,201+160,300+160>
	glis <102,201+170,300+170>
	glis <102,201+190,300+190>
	glis <102,201+200,300+200>
	glis <102,201+220,300+220>
	glis <102,201+230,300+230>
	glis <102,201+250,300+250>
	glis <102,201+260,300+260>
	db -1


son_26	db 10,10,10,10,10,10,10
	db 09,09,09,09,09,9,9
	db -1

son_27	db 20
	db -1

son_28  glis <105,100,150>
	glis <105,150,100>
	db -1

son_29  glis <103,100,150>
	glis <103,150,100>
	db -1

son_30	glis <110,120,100>
	db -1


son_31  db 40,40,-1

son_32	glis <103,100,150>
	glis <102,125,175>
	glis <102,150,200>
	glis <102,175,225>
	glis <102,200,250>
	glis <102,225,275>
	glis <102,250,300>
;	glis <102,275,325>
;	glis <102,300,350>
;	glis <102,300,350>
;	glis <102,275,325>
	glis <102,250,300>
	glis <102,225,275>
	glis <102,200,250>
	glis <102,175,225>
	glis <102,150,200>
	glis <102,125,175>
	glis <102,100,150>
	db -1

son_33	glis <101,50, 200>
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

son_34	glis <102,300,600>
	glis <102,300,600>
	db -1

vit equ 103
BEG EQU 100
EEND EQU 200
PAS EQU 10

son_35 	glis <vit, beg + 10 * PAS ,Eend + 10 * PAS>
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

son_36	db 34,34,38,38,28,28,29,29,34,34,44,44,22,22,33,33
		db 32,32,34,34,27,27,27,32,32,24,24,34,34,29,29
		db 34,34,44,44,22,22,33,33
		db 34,27,27,27,32,32,24,24,34,34,29,29
		db -1

son_37	db -1


son_38	glis <170,800,500>
	db -1

son_39	glis <101,800,400>
	db -1


.CODE

	PUBLIC C timer_int
timer_int proc

	push es
	push ds
	push dx
	push cx
	push bx
	push ax
	mov ax,DGROUP
	mov ds,ax

	inc cntime
	jnz @@nov
	inc cntime+2
@@nov:

IF 0
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
@@non:  mov bx,filsson
	dec bx
	shl bx,1
	mov bx,tabl_snd[bx]
	mov sound_point,bx
@@not_init:
	mov bx,sound_point
	mov al,[bx]
	cmp al,-1               ; final tone
	jnz @@norm
	mov sound_time,0        ; recycle
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
	mov ax,0f000h   ; Bios ROM
	mov es,ax
	mov bx,0a000h
	in al,61h
@@lp:   test byte ptr es:[bx],1
	jz @@off
	or al,3
	jmp @@on
@@off:  and al,NOT 3
@@on:   out 61h,al
	inc bx
	loop @@lp
	or al,3
	out 61h,al
	jmp @@next
@@glis: cmp glis_time,0
	jnz @@glisit
	sub al,100              ; al length in 55/4 ms
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
@@glisit:
	mov cx,glis_freq
	cmp pause,1
	jne @@frq
	mov pauseend, 1
@@frq:
	call freq
	call toneset

	cmp pauseend, 1
	jne @@next1
	mov pause, 0
	mov pauseend, 0
	call toneon

@@next1:
	mov ax,glis_inc
	add glis_freq,ax
	dec glis_time
	jnz @@inc
	add sound_point,5       ; skip command
	jmp @@inc


@@note:
	cmp  al,0
	jne  @@nopause
	call toneoff
	mov  pause,1
	jmp  @@pit

@@nopause:
	cmp pause,1
	jne @@pit
	mov pauseend, 1
@@pit:
	call pitch
	call toneset

	cmp pauseend, 1
	jne @@next
	mov pause, 0
	mov pauseend, 0
	call toneon

@@next: inc sound_point
@@inc:  inc sound_time


@@exit: pop ax
	pop bx
	pop cx
	pop dx
	pop ds
	pop es
	ret
timer_int endp


clrfif proc near


	ret
clrfif	endp

extrn modetelecom:word

keyboard_int proc far
	push ds
	push ax
	push dx
	mov ax,DGROUP
	mov ds,ax
	in al,60h

if 0
	push dx
	mov dx,0300h
	out dx,al
	pop dx

	cmp al,0f1h
	je  dopause
	cmp al,0e5h
	jne nopause

dopause:
	push ax
	mov al,0
	out 60h,al
	pop ax

nopause:
endif
	push es
	push ax
	xor ax, ax
	mov es, ax
	mov al, byte ptr es:[0417h]
;	and al,0dfh
	or  al,020h
	mov byte ptr es:[0417h], al
	pop ax
	pop es

	mov byte ptr keyison, 1

	mov dx, 1
	cmp al, 048h
	je  upon
	cmp al, 049h
	je  upon
;	cmp modetelecom,0
;	jne upoff
	mov dx, 0
	cmp al, 0c8h
	je   upon
	cmp al, 0c9h
	jne upoff

upon:   mov byte ptr state_up, dl
	mov byte ptr keyison, 0
upoff:
	mov dx, 1
	cmp al, 050h
	je  downon
	cmp al, 04fh
	je  downon
	mov dx, 0
	cmp al, 0d0h
	je  downon
	cmp al, 0cfh
	jne downoff
downon:	mov byte ptr state_down, dl
	mov byte ptr keyison, 0
downoff:
	mov dx, 1
	cmp al, 04bh
	je  lon
	cmp al, 047h
	je  lon
	mov dx, 0
	cmp al, 0cbh
	je  lon
	cmp al, 0c7h
	jne loff
lon:    mov byte ptr state_left, dl
	mov byte ptr keyison, 0
loff:
	mov dx, 1
	cmp al, 04dh
	je  ron
	cmp al, 051h
	je  ron
	mov dx, 0
	cmp al, 0cdh
	je ron
	cmp al, 0d1h
	jne roff
ron:    mov byte ptr state_right, dl
	mov byte ptr keyison, 0
roff:

	mov byte ptr Key_Code,al
	pushf

	cmp byte ptr keyison, 0
	jne kkeyon

	push es
	mov ax, 40h
	mov es, ax
	mov ax, es:[01ch]
	mov es:[01ah], ax
	mov byte ptr keyison, 1
	pop es
kkeyon:
	call dword ptr [old_int9]

endkey:
	pop dx
	pop ax
	pop ds
	iret
keyboard_int endp




;routine to select tone
toneset proc near
;load the time period into the timer
	mov al,cl       ;lower byte
	out 042h,al     ;out to timer
	mov al,ch       ;upper byte
	out 042h,al     ;out to timer
	ret
toneset endp

	PUBLIC toneon
;routine to turn on tone
toneon  proc C
;turn speaker and timer on
	in al,061h      ;get contents of system port B
	or al,3         ;turn speaker and timer on
	out 061h,al     ;send out new values to port B
	ret
toneon  endp

	PUBLIC toneoff
;routine to turn tone off
toneoff proc C
;turn off timer2 and speaker
	in al,061h              ;get port B
	and al,11111100b        ;turn off timer and speaker
	out 061h,al
	ret
toneoff endp



freq    proc near
	push dx
	mov dx,12h
	mov ax,34deh
	div cx
	mov cx,ax
	pop dx
	ret
freq    endp


; in    AL

pitch   proc near
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
@@sr:   shr dx,cl
@@dd:   xchg cx,dx
	ret
pitch   endp

	PUBLIC trap_interrupts
trap_interrupts PROC C
	xor ax,ax
	mov es,ax
	cli

	mov ax,es:[4*8]
	mov word ptr old_int8,ax
	mov ax,es:[4*8+2]
	mov word ptr old_int8+2,ax

;       mov ax,offset timer_int
;       mov es:[4*8],ax
;       mov ax,cs
;       mov es:[4*8+2],ax

	mov ax,es:[4*9]
	mov word ptr old_int9,ax
	mov ax,es:[4*9+2]
	mov word ptr old_int9+2,ax
	mov ax,offset keyboard_int
	mov es:[4*9],ax
	mov ax,cs
	mov es:[4*9+2],ax

	mov ax,es:[4*01bh]
	mov word ptr old_int1b,ax
	mov ax,es:[4*01bh+2]
	mov word ptr old_int1b+2,ax
	mov ax,offset break_int
	mov es:[4*01bh],ax
	mov ax,cs
	mov es:[4*01bh+2],ax


;       mov al,36h
;       out 43h,al      ; counter 0 in mode 3
;       mov al,0B6h
;       out 43h,al      ; counter 2 in mode 3
;       mov ax,4000h    ; constant for 55/4 ms
;       out 40h,al
;       mov al,ah
;       out 40h,al



	sti
	ret
trap_interrupts ENDP

break_int proc far
	iret
break_int endp


	PUBLIC release_interrupts
release_interrupts PROC C
	xor ax,ax
	mov es,ax
	cli
	mov ax,0        ; constant for 55 ms
	out 40h,al
	mov al,ah
	out 40h,al
	mov ax,0554h    ; constant for beep
	out 42h,al
	mov al,ah
	out 42h,al

;       mov ax,word ptr old_int8
;       mov es:[4*8],ax
;       mov ax,word ptr old_int8+2
;       mov es:[4*8+2],ax

	mov ax,word ptr old_int1b
	mov es:[4*01bh],ax
	mov ax,word ptr old_int1b+2
	mov es:[4*01bh+2],ax


	mov ax,word ptr old_int9
	mov es:[4*9],ax
	mov ax,word ptr old_int9+2
	mov es:[4*9+2],ax
	sti
	ret
release_interrupts ENDP



;========
;gettimems
;========

; rend le temps ‚coul‚ en ms

	PUBLIC gettimems
gettimems PROC C
	mov ax,cntime
	mov dx,cntime+2
	ret
gettimems endp




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
