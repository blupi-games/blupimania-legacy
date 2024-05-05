; Reset routine for Soundblaster
; Coded for the SBF by millerje
; Modified (to replace sbp.asm) by cmb.

DSP_RESET	equ	6
DSP_DATA_AVAIL	equ	0Eh
DSP_READ_DATA	equ	0Ah

		.MODEL	LARGE,C

		.DATA
PUBLIC SbIOaddr, SbIRQ, SbDMAchan, SbType

SbIOaddr  dw	  220h
SbIRQ	  dw	  7
SbDMAchan dw	  1
SbType	  dw	  2

		.CODE
		PUBLIC	Sb_Init
Sb_Init		PROC

; Reset the DSP by sending 1, (delay), then 0
		mov	al,1
		mov	dx,[SbIOaddr]
		add	dx,DSP_RESET
		out	dx,al

; Do a wait for I/O (each bus access takes 1 microsecond on a standard ISA)
; Must be at least 3.3 microseconds
		in	al,dx
		in	al,dx
		in	al,dx
		in	al,dx

		mov	al,0
		mov	dx,[SbIOaddr]
		add	dx,DSP_RESET
		out	dx,al

		mov	cx,64h
DataWait:
		mov	dx,[SbIOaddr]
		add	dx,DSP_DATA_AVAIL
		in	al,dx
		test	al,80h
		jnz	YesData			;a byte is waiting...
		loop	DataWait

; Timed out- there's no data there
		jmp	short exit

; Data is waiting, if = 0AAh, there's a SB here!
YesData:
		mov	dx,[SbIOaddr]
		add	dx,DSP_READ_DATA
		in	al,dx
		cmp	al,0AAh
		je	YepSB			;Found the ID byte
		loop	DataWait		;No, wait for next byte

; timed out- can't find signature
		jmp	short exit

YepSB:
		mov	ax,0
		ret

exit:
		mov	ax,1
		ret

Sb_Init		ENDP

		END


