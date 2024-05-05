	.286p
	ifndef	??version
?debug	macro
	endm
$comm	macro	name,dist,size,count
	comm	dist name:BYTE:count*size
	endm
	else
$comm	macro	name,dist,size,count
	comm	dist name[size]:BYTE:count
	endm
	endif
	?debug	S "BMSMAKY.C"
	?debug	C E92284661F09424D534D414B592E43
	?debug	C E9A47D3B1F122E2E5C424C414E475C5F4344494E53542E48
	?debug	C E920083A1516433A5C54435C494E434C5544455C5354444C49422E+
	?debug	C 48
	?debug	C E920083A1515433A5C54435C494E434C5544455C535444494F2E48
	?debug	C E920083A1516433A5C54435C494E434C5544455C535452494E472E+
	?debug	C 48
	?debug	C E920083A1515433A5C54435C494E434C5544455C414C4C4F432E48
	?debug	C E920083A1512433A5C54435C494E434C5544455C494F2E48
	?debug	C E920083A1516433A5C54435C494E434C5544455C5354444152472E+
	?debug	C 48
	?debug	C E920083A1515433A5C54435C494E434C5544455C4552524E4F2E48
	?debug	C E920083A1515433A5C54435C494E434C5544455C434F4E494F2E48
	?debug	C E920083A1515433A5C54435C494E434C5544455C46434E544C2E48
	?debug	C E920083A1513433A5C54435C494E434C5544455C444F532E48
	?debug	C E920083A1515433A5C54435C494E434C5544455C46434E544C2E48
	?debug	C E9CD82661F04424D2E48
	?debug	C E920083A1515433A5C54435C494E434C5544455C535444494F2E48
	?debug	C E9F1845E1F102E2E5C424C414E475C5F4C414E472E48
	?debug	C E9D163271F05584D532E48
	?debug	C E920083A1513433A5C54435C494E434C5544455C444F532E48
	?debug	C E920083A1515433A5C54435C494E434C5544455C414C4C4F432E48
	?debug	C E9D163271F08494346494C452E48
	?debug	C E9D163271F094B4559535F50432E48
	?debug	C E9025F2C1F074D5553504C2E48
	?debug	C E98985341F09424C50494E464F2E48
BMSMAKY_TEXT	segment byte public 'CODE'
BMSMAKY_TEXT	ends
DGROUP	group	_DATA,_BSS
	assume	cs:BMSMAKY_TEXT,ds:DGROUP
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
_BSS	ends
_DATA	segment word public 'DATA'
_blpinfo	label	word
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	20 dup (0)
atime	label	word
	db	0
	db	0
	db	0
	db	0
colormode	label	word
	db	0
	db	0
visumouse	label	word
	db	1
	db	0
lastmouse	label	word
	db	0
	db	0
	db	0
	db	0
demo	label	byte
	db	0
pim	label	dword
	dd	DGROUP:imPC
lastimage	label	word
	db	255
	db	255
_DATA	ends
BMSMAKY_TEXT	segment byte public 'CODE'
	?debug	C E80009424D534D414B592E432284661F
	?debug	L 198
	assume	cs:BMSMAKY_TEXT
_GetRandom	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	?debug	C E6036D6178040A0A00036D696E040A0800016704+
	?debug	C 0A0600
	mov	si,word ptr [bp+6]
	?debug	B
	?debug	L 200
	mov	bx,si
	shl	bx,2
	mov	cx,word ptr DGROUP:nextrand[bx+2]
	mov	bx,word ptr DGROUP:nextrand[bx]
	mov	dx,16838
	mov	ax,20077
	call	far ptr F_LXMUL@
	add	ax,12345
	adc	dx,0
	mov	bx,si
	shl	bx,2
	mov	word ptr DGROUP:nextrand[bx],ax
	mov	word ptr DGROUP:nextrand[bx+2],dx
	?debug	L 201
	mov	ax,word ptr [bp+10]
	sub	ax,word ptr [bp+8]
	cwd	
	push	dx
	push	ax
	mov	bx,si
	shl	bx,2
	push	0
	push	word ptr DGROUP:nextrand[bx+2]
	call	far ptr F_LUMOD@
	push	ax
	mov	ax,word ptr [bp+8]
	pop	dx
	add	ax,dx
	?debug	L 202
	pop	si
	pop	bp
	ret	
	?debug	C E6036D6178040A0A00036D696E040A0800016704+
	?debug	C 0C06
	?debug	E
	?debug	E
_GetRandom	endp
	?debug	L 213
	assume	cs:BMSMAKY_TEXT
_InitRandomEx	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	push	di
	?debug	C E318000400160200
	?debug	C E603706578180A0C00036D6178040A0A00036D69+
	?debug	C 6E040A08000167040A0600
	mov	dx,word ptr [bp+8]
	mov	di,word ptr [bp+10]
	?debug	B
	?debug	L 217
	xor	si,si
	jmp	short @2@98
@2@50:
	?debug	L 219
	les	bx,dword ptr [bp+12]
	mov	byte ptr es:[bx+si],0
	?debug	L 217
	inc	si
@2@98:
	mov	ax,di
	sub	ax,dx
	cmp	ax,si
	jg	short @2@50
	?debug	L 221
	pop	di
	pop	si
	pop	bp
	ret	
	?debug	C E6016904040603706578180A0C00036D6178040C+
	?debug	C 07036D696E040C020167040A0600
	?debug	E
	?debug	E
_InitRandomEx	endp
	?debug	L 233
	assume	cs:BMSMAKY_TEXT
_GetRandomEx	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	dec	sp
	dec	sp
	push	si
	push	di
	?debug	C E319000400160200
	?debug	C E603706578190A0C00036D6178040A0A00036D69+
	?debug	C 6E040A08000167040A0600
	mov	di,word ptr [bp+8]
	?debug	B
	?debug	L 237
	mov	ax,word ptr [bp+10]
	sub	ax,di
	push	ax
	push	0
	push	word ptr [bp+6]
	push	cs
	call	near ptr _GetRandom
	add	sp,6
	mov	si,ax
	?debug	L 239
	mov	word ptr [bp-2],0
	jmp	short @3@170
@3@50:
	?debug	L 241
	les	bx,dword ptr [bp+12]
	cmp	byte ptr es:[bx+si],0
	jne	short @3@98
	jmp	short @3@218
@3@98:
	?debug	L 248
	inc	si
	?debug	L 249
	mov	ax,word ptr [bp+10]
	sub	ax,di
	cmp	ax,si
	jne	short @3@146
	xor	si,si
@3@146:
	?debug	L 239
	inc	word ptr [bp-2]
@3@170:
	mov	ax,word ptr [bp+10]
	sub	ax,di
	cmp	ax,word ptr [bp-2]
	jg	short @3@50
	?debug	L 253
	push	word ptr [bp+14]
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	push	di
	push	word ptr [bp+6]
	push	cs
	call	near ptr _InitRandomEx
	add	sp,10
	?debug	L 254
	mov	ax,word ptr [bp+10]
	sub	ax,di
	push	ax
	push	0
	push	word ptr [bp+6]
	push	cs
	call	near ptr _GetRandom
	add	sp,6
	mov	si,ax
	?debug	L 255
@3@218:
	les	bx,dword ptr [bp+12]
	mov	byte ptr es:[bx+si],1
	?debug	L 256
	mov	ax,di
	add	ax,si
	?debug	L 257
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E60376616C04040601690402FEFF03706578190A+
	?debug	C 0C00036D6178040A0A00036D696E040C07016704+
	?debug	C 0A0600
	?debug	E
	?debug	E
_GetRandomEx	endp
	?debug	C E920083A1514433A5C54435C494E434C5544455C54494D452E48
	?debug	C E801
	?debug	L 272
	assume	cs:BMSMAKY_TEXT
_StartRandom	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,4
	?debug	C E6046D6F6465040A08000167040A0600
	?debug	B
	?debug	L 275
	cmp	word ptr [bp+8],0
	jne	short @4@74
	?debug	L 277
	mov	bx,word ptr [bp+6]
	shl	bx,2
	mov	word ptr DGROUP:nextrand[bx],65497
	mov	word ptr DGROUP:nextrand[bx+2],511
	?debug	L 278
	jmp	short @4@98
@4@74:
	?debug	L 281
	push	ss
	lea	ax,word ptr [bp-4]
	push	ax
	call	far ptr _time
	add	sp,4
	mov	bx,word ptr [bp+6]
	shl	bx,2
	mov	word ptr DGROUP:nextrand[bx],ax
	mov	word ptr DGROUP:nextrand[bx+2],dx
@4@98:
	?debug	L 283
	leave	
	ret	
	?debug	C E602746D0602FCFF046D6F6465040A0800016704+
	?debug	C 0A0600
	?debug	E
	?debug	E
_StartRandom	endp
	?debug	L 297
	assume	cs:BMSMAKY_TEXT
_ifhidemousex	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E31C000400160201
	?debug	C E200046C656674040003746F7004000572696768+
	?debug	C 74040003626F740400056279746573048004706E+
	?debug	C 74721C
	?debug	C E31B066269746D61700E001E
	?debug	C E31A000400161B00
	?debug	C E601721A0A0600
	?debug	B
	?debug	L 309
	pop	bp
	ret	
	?debug	C E601721A0A0600
	?debug	E
	?debug	E
_ifhidemousex	endp
	?debug	L 328
	assume	cs:BMSMAKY_TEXT
_PlayStartStop	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E6046D6F6465040A0600
	?debug	B
	?debug	L 330
	mov	al,byte ptr [bp+6]
	mov	byte ptr DGROUP:_sound_onoff,al
	?debug	L 331
	pop	bp
	ret	
	?debug	C E6046D6F6465040A0600
	?debug	E
	?debug	E
_PlayStartStop	endp
	?debug	L 343
	assume	cs:BMSMAKY_TEXT
_IfPlayReady	proc	far
	?debug	B
	?debug	B
	?debug	L 345
	mov	ax,1
	?debug	L 346
	ret	
	?debug	E
	?debug	E
_IfPlayReady	endp
	?debug	L 361
	assume	cs:BMSMAKY_TEXT
_PlaySoundLoop	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E6046D6F6465040A0600
	?debug	B
	?debug	L 363
	pop	bp
	ret	
	?debug	C E6046D6F6465040A0600
	?debug	E
	?debug	E
_PlaySoundLoop	endp
BMSMAKY_TEXT	ends
_DATA	segment word public 'DATA'
	db	105
	db	0
	db	107
	db	0
	db	111
	db	0
_DATA	ends
_BSS	segment word public 'BSS'
	db	2 dup (?)
_BSS	ends
BMSMAKY_TEXT	segment byte public 'CODE'
	?debug	L 374
	assume	cs:BMSMAKY_TEXT
_PlaySound	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	?debug	C E605736F756E64040A0600
	mov	si,word ptr [bp+6]
	?debug	B
	?debug	L 380
	cmp	si,41
	jle	short @9@122
	cmp	si,101
	je	short @9@122
	cmp	si,109
	je	short @9@122
	cmp	si,105
	jne	short @9@338
@9@122:
	?debug	L 383
	cmp	word ptr DGROUP:have_sbcard,0
	je	short @9@290
	?debug	L 385
	cmp	byte ptr DGROUP:_sound_onoff,0
	je	short @9@338
	?debug	L 387
	cmp	si,105
	jne	short @9@242
	?debug	B
	?debug	L 391
	mov	bx,word ptr DGROUP:b@w+0
	shl	bx,1
	mov	si,word ptr DGROUP:d@w+47[bx]
	inc	word ptr DGROUP:b@w+0
	?debug	L 392
	cmp	word ptr DGROUP:b@w+0,3
	jne	short @9@242
	?debug	L 393
	mov	word ptr DGROUP:b@w+0,0
@9@242:
	?debug	C E31D0006001A04
	?debug	C E60169040000030000037461621D0000022F00
	?debug	E
	?debug	L 395
	push	si
	call	far ptr _playsoundblast
	inc	sp
	inc	sp
	?debug	L 397
	jmp	short @9@338
@9@290:
	?debug	L 400
	cmp	si,39
	jg	short @9@338
	?debug	L 401
	mov	word ptr DGROUP:_filsson,si
@9@338:
	?debug	L 410
	pop	si
	pop	bp
	ret	
	?debug	C E605736F756E64040C06
	?debug	E
	?debug	E
_PlaySound	endp
	?debug	L 413
	assume	cs:BMSMAKY_TEXT
_sbsound	proc	far
	?debug	B
	?debug	B
	?debug	L 415
	mov	ax,word ptr DGROUP:have_sbcard
	?debug	L 416
	ret	
	?debug	E
	?debug	E
_sbsound	endp
	?debug	L 434
	assume	cs:BMSMAKY_TEXT
_OpenTime	proc	far
	?debug	B
	?debug	B
	?debug	L 436
	call	far ptr _gettimems
	mov	word ptr DGROUP:mtime,ax
	mov	word ptr DGROUP:mtime+2,dx
	?debug	L 437
	ret	
	?debug	E
	?debug	E
_OpenTime	endp
	?debug	L 450
	assume	cs:BMSMAKY_TEXT
_CloseTime	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	?debug	C E60164040A0600
	?debug	B
	?debug	L 452
	mov	ax,word ptr [bp+6]
	inc	ax
	mov	si,ax
@12@50:
	?debug	L 453
	call	far ptr _gettimems
	sub	ax,word ptr DGROUP:mtime
	sbb	dx,word ptr DGROUP:mtime+2
	push	ax
	mov	ax,si
	push	dx
	cwd	
	pop	bx
	cmp	bx,dx
	pop	dx
	jl	short @12@50
	jne	short @12@122
	cmp	dx,ax
	jb	short @12@50
@12@122:
	?debug	L 454
	pop	si
	pop	bp
	ret	
	?debug	C E60364656C0404060164040A0600
	?debug	E
	?debug	E
_CloseTime	endp
	?debug	L 464
	assume	cs:BMSMAKY_TEXT
mouseon	proc	far
	?debug	B
	?debug	B
	?debug	L 466
	inc	word ptr DGROUP:mouse_on
	?debug	L 467
	mov	ax,1
	int	51
	?debug	L 468
	ret	
	?debug	E
	?debug	E
mouseon	endp
	?debug	L 471
	assume	cs:BMSMAKY_TEXT
mouseoff	proc	far
	?debug	B
	?debug	B
	?debug	L 473
	dec	word ptr DGROUP:mouse_on
	?debug	L 474
	mov	ax,2
	int	51
	?debug	L 475
	ret	
	?debug	E
	?debug	E
mouseoff	endp
	?debug	L 490
	assume	cs:BMSMAKY_TEXT
getmousepos	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,4
	?debug	B
	?debug	L 494
	mov	ax,3
	int	51
	?debug	L 495
	mov	word ptr [bp-2],cx
	?debug	L 496
	mov	word ptr [bp-4],dx
	?debug	L 497
	mov	word ptr DGROUP:mousebuttons,bx
	?debug	L 498
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	?debug	L 499
	leave	
	ret	
	?debug	C E20001790480017804
	?debug	C E31E0004001E
	?debug	C E6037265741E02FCFF
	?debug	E
	?debug	E
getmousepos	endp
	?debug	L 509
	assume	cs:BMSMAKY_TEXT
_PosMouse	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E603706F731E0A0600
	?debug	B
	?debug	L 511
	mov	cx,word ptr [bp+8]
	?debug	L 512
	mov	dx,word ptr [bp+6]
	?debug	L 513
	mov	ax,4
	int	51
	?debug	L 514
	pop	bp
	ret	
	?debug	C E603706F731E0A0600
	?debug	E
	?debug	E
_PosMouse	endp
	?debug	L 528
	assume	cs:BMSMAKY_TEXT
_IfMouse	proc	far
	?debug	B
	?debug	B
	?debug	L 530
	mov	ax,1
	?debug	L 531
	ret	
	?debug	E
	?debug	E
_IfMouse	endp
BMSMAKY_TEXT	ends
_DATA	segment word public 'DATA'
hiddenmouse	label	word
	db	0
	db	0
_DATA	ends
BMSMAKY_TEXT	segment byte public 'CODE'
	?debug	L 546
	assume	cs:BMSMAKY_TEXT
_HideMouse	proc	far
	?debug	B
	?debug	B
	?debug	L 548
	cmp	word ptr DGROUP:hiddenmouse,0
	jne	short @18@50
	?debug	L 550
	push	cs
	call	near ptr mouseoff
	?debug	L 551
	mov	word ptr DGROUP:hiddenmouse,1
@18@50:
	?debug	L 553
	ret	
	?debug	E
	?debug	E
_HideMouse	endp
	?debug	L 564
	assume	cs:BMSMAKY_TEXT
_ShowMouse	proc	far
	?debug	B
	?debug	B
	?debug	L 566
	cmp	word ptr DGROUP:hiddenmouse,0
	je	short @19@50
	?debug	L 568
	push	cs
	call	near ptr mouseon
	?debug	L 569
	mov	word ptr DGROUP:hiddenmouse,0
@19@50:
	?debug	L 571
	ret	
	?debug	E
	?debug	E
_ShowMouse	endp
	?debug	L 584
	assume	cs:BMSMAKY_TEXT
_HideMouseInt	proc	far
	?debug	B
	?debug	B
	?debug	L 586
	push	cs
	call	near ptr mouseoff
	?debug	L 587
	ret	
	?debug	E
	?debug	E
_HideMouseInt	endp
	?debug	L 598
	assume	cs:BMSMAKY_TEXT
_ShowMouseInt	proc	far
	?debug	B
	?debug	B
	?debug	L 601
	push	cs
	call	near ptr mouseon
	?debug	L 602
	ret	
	?debug	E
	?debug	E
_ShowMouseInt	endp
	?debug	L 630
	assume	cs:BMSMAKY_TEXT
_initmouse	proc	far
	?debug	B
	?debug	B
	?debug	L 632
	call	far ptr _vfy_mouse
	cmp	ax,65535
	je	short @22@50
	?debug	L 634
	mov	ax,1
	int	51
	?debug	L 635
	mov	word ptr DGROUP:visumouse,1
	?debug	L 636
	mov	ax,1
	jmp	short @22@74
@22@50:
	?debug	L 638
	xor	ax,ax
@22@74:
	?debug	L 639
	ret	
	?debug	E
	?debug	E
_initmouse	endp
	?debug	L 653
	assume	cs:BMSMAKY_TEXT
clrmouse	proc	far
	?debug	B
	?debug	B
	?debug	L 655
	mov	word ptr DGROUP:pushr,0
	?debug	L 656
	mov	word ptr DGROUP:relr,0
	?debug	L 657
	mov	word ptr DGROUP:pushl,0
	?debug	L 658
	mov	word ptr DGROUP:rell,0
	?debug	L 659
	mov	word ptr DGROUP:buttons,0
	?debug	L 660
	ret	
	?debug	E
	?debug	E
clrmouse	endp
	?debug	L 663
	assume	cs:BMSMAKY_TEXT
mousecode	proc	far
	?debug	B
	?debug	B
	?debug	L 666
	xor	bx,bx
	?debug	L 667
	mov	ax,6
	int	51
	?debug	L 668
	mov	word ptr DGROUP:rell,bx
	?debug	L 670
	cmp	word ptr DGROUP:rell,0
	jle	short @24@50
	?debug	L 672
	mov	word ptr DGROUP:pushl,0
	?debug	L 673
	mov	word ptr DGROUP:rell,0
	?debug	L 674
	mov	ax,11
	jmp	short @24@242
@24@50:
	?debug	L 677
	xor	bx,bx
	?debug	L 678
	mov	ax,5
	int	51
	?debug	L 679
	mov	word ptr DGROUP:pushl,bx
	?debug	L 680
	cmp	word ptr DGROUP:pushl,0
	jle	short @24@98
	?debug	L 681
	mov	ax,1
	jmp	short @24@242
@24@98:
	?debug	L 685
	cmp	word ptr DGROUP:pushr,0
	jne	short @24@170
	?debug	L 687
	mov	bx,1
	?debug	L 688
	mov	ax,5
	int	51
	?debug	L 689
	mov	word ptr DGROUP:pushr,bx
	?debug	L 690
	cmp	word ptr DGROUP:pushr,0
	jle	short @24@218
	?debug	L 691
	mov	ax,2
	jmp	short @24@242
@24@170:
	?debug	L 695
	mov	bx,1
	?debug	L 696
	mov	ax,6
	int	51
	?debug	L 697
	mov	word ptr DGROUP:relr,bx
	?debug	L 699
	cmp	word ptr DGROUP:relr,0
	jle	short @24@218
	?debug	L 701
	mov	word ptr DGROUP:pushr,0
	?debug	L 702
	mov	word ptr DGROUP:relr,0
	?debug	L 703
	mov	ax,12
	jmp	short @24@242
@24@218:
	?debug	L 706
	xor	ax,ax
@24@242:
	?debug	L 707
	ret	
	?debug	E
	?debug	E
mousecode	endp
	?debug	L 710
	assume	cs:BMSMAKY_TEXT
_clrfifo	proc	far
	?debug	B
	?debug	B
	?debug	L 712
	db	250
	?debug	L 713
	?debug	L 714
	mov	ax,64
	mov	es,ax
	mov	ax,word ptr es:[28]
	mov	dx,64
	mov	es,dx
	mov	word ptr es:[26],ax
	?debug	L 715
	db	251
	?debug	L 716
	ret	
	?debug	E
	?debug	E
_clrfifo	endp
	?debug	L 729
	assume	cs:BMSMAKY_TEXT
_ClrEvents	proc	far
	?debug	B
	?debug	B
	?debug	L 731
	push	cs
	call	near ptr _clrfifo
	?debug	L 732
	push	cs
	call	near ptr clrmouse
	?debug	L 733
	ret	
	?debug	E
	?debug	E
_ClrEvents	endp
BMSMAKY_TEXT	ends
_BSS	segment word public 'BSS'
	db	2 dup (?)
	db	2 dup (?)
_BSS	ends
BMSMAKY_TEXT	segment byte public 'CODE'
	?debug	L 752
	assume	cs:BMSMAKY_TEXT
_GetEvent	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,12
	push	si
	?debug	C E31F000400161E00
	?debug	C E60470706F731F0A0600
	?debug	B
	?debug	L 760
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr DGROUP:lastmouse+2
	mov	dx,word ptr DGROUP:lastmouse
	mov	word ptr es:[bx],dx
	mov	word ptr es:[bx+2],ax
	?debug	L 762
	push	cs
	call	near ptr getmousepos
	mov	word ptr DGROUP:lastmouse,ax
	mov	word ptr DGROUP:lastmouse+2,dx
	?debug	L 764
	mov	word ptr DGROUP:keystatus,0
	?debug	L 765
	cmp	byte ptr DGROUP:_state_left,0
	je	short @27@74
	?debug	L 766
	mov	word ptr DGROUP:keystatus,1
@27@74:
	?debug	L 767
	cmp	byte ptr DGROUP:_state_right,0
	je	short @27@122
	?debug	L 768
	mov	word ptr DGROUP:keystatus,2
@27@122:
	?debug	L 769
	cmp	byte ptr DGROUP:_state_up,0
	je	short @27@170
	?debug	L 770
	mov	word ptr DGROUP:keystatus,4
@27@170:
	?debug	L 771
	cmp	byte ptr DGROUP:_state_down,0
	je	short @27@218
	?debug	L 772
	mov	word ptr DGROUP:keystatus,8
@27@218:
	?debug	L 776
	cmp	word ptr DGROUP:b@w+2,0
	je	short @27@314
	test	word ptr DGROUP:mousebuttons,1
	jne	short @27@314
	?debug	L 778
	inc	word ptr DGROUP:b@w+4
	?debug	L 779
	cmp	word ptr DGROUP:b@w+4,5
	jne	short @27@314
	?debug	L 781
	mov	word ptr DGROUP:b@w+4,0
	mov	word ptr DGROUP:b@w+2,0
	?debug	L 782
	mov	ax,65514
	jmp	@27@4034
@27@314:
	?debug	L 787
	push	cs
	call	near ptr mousecode
	mov	si,ax
	?debug	L 788
	or	si,si
	je	short @27@482
	?debug	L 790
	cmp	ax,1
	je	short @27@410
	cmp	ax,2
	je	short @27@434
	jmp	short @27@458
@27@410:
	?debug	L 793
	mov	word ptr DGROUP:b@w+2,1
	?debug	L 794
	mov	ax,65516
	jmp	@27@4034
@27@434:
	?debug	L 796
	mov	ax,65515
	jmp	@27@4034
@27@458:
	?debug	L 798
	mov	word ptr DGROUP:b@w+2,0
	?debug	L 799
	mov	ax,65514
	jmp	@27@4034
@27@482:
	?debug	L 802
	push	1
	call	far ptr _bioskey
	inc	sp
	inc	sp
	or	ax,ax
	jne	short @27@530
	?debug	L 804
	xor	ax,ax
	jmp	@27@4034
@27@530:
	?debug	L 807
	push	0
	call	far ptr _bioskey
	inc	sp
	inc	sp
	cwd	
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	?debug	L 808
	push	cs
	call	near ptr _clrfifo
	?debug	L 810
	mov	ax,word ptr [bp-4]
	and	ax,255
	mov	word ptr [bp-8],ax
	mov	word ptr [bp-6],0
	?debug	L 811
	cmp	word ptr [bp-6],0
	jl	short @27@698
	jne	short @27@602
	cmp	word ptr [bp-8],97
	jb	short @27@698
@27@602:
	cmp	word ptr [bp-6],0
	jg	short @27@698
	jne	short @27@674
	cmp	word ptr [bp-8],122
	ja	short @27@698
@27@674:
	?debug	L 812
	sub	word ptr [bp-8],32
	sbb	word ptr [bp-6],0
@27@698:
	?debug	L 816
	cmp	word ptr [bp-2],0
	jne	short @27@746
	cmp	word ptr [bp-4],19200
	je	short @27@794
@27@746:
	cmp	word ptr [bp-2],0
	jne	short @27@818
	cmp	word ptr [bp-4],19252
	jne	short @27@818
@27@794:
	?debug	L 817
	mov	ax,65506
	jmp	@27@4034
@27@818:
	?debug	L 818
	cmp	word ptr [bp-2],0
	jne	short @27@866
	cmp	word ptr [bp-4],19712
	je	short @27@914
@27@866:
	cmp	word ptr [bp-2],0
	jne	short @27@938
	cmp	word ptr [bp-4],19766
	jne	short @27@938
@27@914:
	?debug	L 819
	mov	ax,65505
	jmp	@27@4034
@27@938:
	?debug	L 820
	cmp	word ptr [bp-2],0
	jne	short @27@986
	cmp	word ptr [bp-4],18432
	je	short @27@1034
@27@986:
	cmp	word ptr [bp-2],0
	jne	short @27@1058
	cmp	word ptr [bp-4],18488
	jne	short @27@1058
@27@1034:
	?debug	L 821
	mov	ax,65504
	jmp	@27@4034
@27@1058:
	?debug	L 822
	cmp	word ptr [bp-2],0
	jne	short @27@1106
	cmp	word ptr [bp-4],20480
	je	short @27@1154
@27@1106:
	cmp	word ptr [bp-2],0
	jne	short @27@1178
	cmp	word ptr [bp-4],20530
	jne	short @27@1178
@27@1154:
	?debug	L 823
	mov	ax,65503
	jmp	@27@4034
@27@1178:
	?debug	L 826
	and	word ptr [bp-4],65535
	and	word ptr [bp-2],0
	?debug	L 828
	cmp	word ptr [bp-2],0
	jne	short @27@1250
	cmp	word ptr [bp-4],283
	jne	short @27@1250
	?debug	L 829
	mov	ax,65535
	jmp	@27@4034
@27@1250:
	?debug	L 830
	cmp	word ptr [bp-2],0
	jne	short @27@1322
	cmp	word ptr [bp-4],15104
	jne	short @27@1322
	?debug	L 831
	mov	ax,65526
	jmp	@27@4034
@27@1322:
	?debug	L 832
	cmp	word ptr [bp-2],0
	jne	short @27@1394
	cmp	word ptr [bp-4],15360
	jne	short @27@1394
	?debug	L 833
	mov	ax,65525
	jmp	@27@4034
@27@1394:
	?debug	L 834
	cmp	word ptr [bp-2],0
	jne	short @27@1466
	cmp	word ptr [bp-4],15616
	jne	short @27@1466
	?debug	L 835
	mov	ax,65524
	jmp	@27@4034
@27@1466:
	?debug	L 836
	cmp	word ptr [bp-2],0
	jne	short @27@1538
	cmp	word ptr [bp-4],15872
	jne	short @27@1538
	?debug	L 837
	mov	ax,65523
	jmp	@27@4034
@27@1538:
	?debug	L 838
	cmp	word ptr [bp-2],0
	jne	short @27@1610
	cmp	word ptr [bp-4],16128
	jne	short @27@1610
	?debug	L 839
	mov	ax,65436
	jmp	@27@4034
@27@1610:
	?debug	L 840
	cmp	word ptr [bp-2],0
	jne	short @27@1682
	cmp	word ptr [bp-4],16384
	jne	short @27@1682
	?debug	L 841
	mov	ax,65435
	jmp	@27@4034
@27@1682:
	?debug	L 842
	cmp	word ptr [bp-2],0
	jne	short @27@1754
	cmp	word ptr [bp-4],16640
	jne	short @27@1754
	?debug	L 843
	mov	ax,65434
	jmp	@27@4034
@27@1754:
	?debug	L 844
	cmp	word ptr [bp-2],0
	jne	short @27@1826
	cmp	word ptr [bp-4],16896
	jne	short @27@1826
	?debug	L 845
	mov	ax,65433
	jmp	@27@4034
@27@1826:
	?debug	L 846
	cmp	word ptr [bp-2],0
	jne	short @27@1898
	cmp	word ptr [bp-4],17152
	jne	short @27@1898
	?debug	L 847
	mov	ax,65432
	jmp	@27@4034
@27@1898:
	?debug	L 848
	cmp	word ptr [bp-2],0
	jne	short @27@1970
	cmp	word ptr [bp-4],17408
	jne	short @27@1970
	?debug	L 849
	mov	ax,65431
	jmp	@27@4034
@27@1970:
	?debug	L 851
	cmp	word ptr [bp-2],0
	jne	short @27@2042
	cmp	word ptr [bp-4],26880
	jne	short @27@2042
	?debug	L 852
	mov	ax,65522
	jmp	@27@4034
@27@2042:
	?debug	L 853
	cmp	word ptr [bp-2],0
	jne	short @27@2114
	cmp	word ptr [bp-4],27136
	jne	short @27@2114
	?debug	L 854
	mov	ax,65521
	jmp	@27@4034
@27@2114:
	?debug	L 856
	cmp	word ptr [bp-2],0
	jne	short @27@2186
	cmp	word ptr [bp-4],21294
	jne	short @27@2186
	?debug	L 857
	mov	ax,65527
	jmp	@27@4034
@27@2186:
	?debug	L 872
	cmp	word ptr [bp-2],0
	jne	short @27@2258
	cmp	word ptr [bp-4],18176
	jne	short @27@2258
	?debug	L 873
	mov	ax,65534
	jmp	@27@4034
@27@2258:
	?debug	L 878
	cmp	word ptr [bp-2],0
	jne	short @27@2330
	cmp	word ptr [bp-4],3592
	jne	short @27@2330
	?debug	L 879
	mov	ax,65530
	jmp	@27@4034
@27@2330:
	?debug	L 880
	cmp	word ptr [bp-2],0
	jne	short @27@2402
	cmp	word ptr [bp-4],21248
	jne	short @27@2402
	?debug	L 881
	mov	ax,65530
	jmp	@27@4034
@27@2402:
	?debug	L 882
	cmp	word ptr [bp-2],0
	jne	short @27@2474
	cmp	word ptr [bp-4],7181
	jne	short @27@2474
	?debug	L 883
	mov	ax,65529
	jmp	@27@4034
@27@2474:
	?debug	L 889
	cmp	word ptr DGROUP:_typetext,1
	je	@@192
	jmp	@27@4010
@@192:
	?debug	L 891
	mov	ax,word ptr [bp-4]
	and	ax,255
	mov	word ptr [bp-12],ax
	mov	word ptr [bp-10],0
	?debug	L 893
	cmp	word ptr [bp-10],0
	jne	short @27@2570
	cmp	word ptr [bp-12],133
	jne	short @27@2570
	?debug	L 894
	mov	ax,65465
	jmp	@27@4034
@27@2570:
	?debug	L 895
	cmp	word ptr [bp-10],0
	jne	short @27@2642
	cmp	word ptr [bp-12],131
	jne	short @27@2642
	?debug	L 896
	mov	ax,65464
	jmp	@27@4034
@27@2642:
	?debug	L 897
	cmp	word ptr [bp-10],0
	jne	short @27@2714
	cmp	word ptr [bp-12],132
	jne	short @27@2714
	?debug	L 898
	mov	ax,65463
	jmp	@27@4034
@27@2714:
	?debug	L 899
	cmp	word ptr [bp-10],0
	jne	short @27@2786
	cmp	word ptr [bp-12],160
	jne	short @27@2786
	?debug	L 900
	mov	ax,65466
	jmp	@27@4034
@27@2786:
	?debug	L 902
	cmp	word ptr [bp-10],0
	jne	short @27@2858
	cmp	word ptr [bp-12],135
	jne	short @27@2858
	?debug	L 903
	mov	ax,65446
	jmp	@27@4034
@27@2858:
	?debug	L 905
	cmp	word ptr [bp-10],0
	jne	short @27@2930
	cmp	word ptr [bp-12],130
	jne	short @27@2930
	?debug	L 906
	mov	ax,65462
	jmp	@27@4034
@27@2930:
	?debug	L 907
	cmp	word ptr [bp-10],0
	jne	short @27@3002
	cmp	word ptr [bp-12],137
	jne	short @27@3002
	?debug	L 908
	mov	ax,65459
	jmp	@27@4034
@27@3002:
	?debug	L 909
	cmp	word ptr [bp-10],0
	jne	short @27@3074
	cmp	word ptr [bp-12],138
	jne	short @27@3074
	?debug	L 910
	mov	ax,65461
	jmp	@27@4034
@27@3074:
	?debug	L 911
	cmp	word ptr [bp-10],0
	jne	short @27@3146
	cmp	word ptr [bp-12],136
	jne	short @27@3146
	?debug	L 912
	mov	ax,65460
	jmp	@27@4034
@27@3146:
	?debug	L 914
	cmp	word ptr [bp-10],0
	jne	short @27@3218
	cmp	word ptr [bp-12],151
	jne	short @27@3218
	?debug	L 915
	mov	ax,65449
	jmp	@27@4034
@27@3218:
	?debug	L 916
	cmp	word ptr [bp-10],0
	jne	short @27@3290
	cmp	word ptr [bp-12],129
	jne	short @27@3290
	?debug	L 917
	mov	ax,65447
	jmp	@27@4034
@27@3290:
	?debug	L 918
	cmp	word ptr [bp-10],0
	jne	short @27@3362
	cmp	word ptr [bp-12],150
	jne	short @27@3362
	?debug	L 919
	mov	ax,65448
	jmp	@27@4034
@27@3362:
	?debug	L 920
	cmp	word ptr [bp-10],0
	jne	short @27@3434
	cmp	word ptr [bp-12],163
	jne	short @27@3434
	?debug	L 921
	mov	ax,65450
	jmp	@27@4034
@27@3434:
	?debug	L 924
	cmp	word ptr [bp-10],0
	jne	short @27@3506
	cmp	word ptr [bp-12],148
	jne	short @27@3506
	?debug	L 925
	mov	ax,65451
	jmp	@27@4034
@27@3506:
	?debug	L 926
	cmp	word ptr [bp-10],0
	jne	short @27@3578
	cmp	word ptr [bp-12],147
	jne	short @27@3578
	?debug	L 927
	mov	ax,65452
	jmp	short @27@4034
@27@3578:
	?debug	L 928
	cmp	word ptr [bp-10],0
	jne	short @27@3650
	cmp	word ptr [bp-12],162
	jne	short @27@3650
	?debug	L 929
	mov	ax,65454
	jmp	short @27@4034
@27@3650:
	?debug	L 930
	cmp	word ptr [bp-10],0
	jne	short @27@3722
	cmp	word ptr [bp-12],149
	jne	short @27@3722
	?debug	L 931
	mov	ax,65453
	jmp	short @27@4034
@27@3722:
	?debug	L 933
	cmp	word ptr [bp-10],0
	jne	short @27@3794
	cmp	word ptr [bp-12],139
	jne	short @27@3794
	?debug	L 934
	mov	ax,65455
	jmp	short @27@4034
@27@3794:
	?debug	L 935
	cmp	word ptr [bp-10],0
	jne	short @27@3866
	cmp	word ptr [bp-12],140
	jne	short @27@3866
	?debug	L 936
	mov	ax,65456
	jmp	short @27@4034
@27@3866:
	?debug	L 937
	cmp	word ptr [bp-10],0
	jne	short @27@3938
	cmp	word ptr [bp-12],161
	jne	short @27@3938
	?debug	L 938
	mov	ax,65458
	jmp	short @27@4034
@27@3938:
	?debug	L 939
	cmp	word ptr [bp-10],0
	jne	short @27@4010
	cmp	word ptr [bp-12],141
	jne	short @27@4010
	?debug	L 940
	mov	ax,65457
	jmp	short @27@4034
@27@4010:
	?debug	L 945
	mov	ax,255
	and	ax,word ptr [bp-4]
@27@4034:
	?debug	L 946
	pop	si
	leave	
	ret	
	?debug	C E6086C656674636C69630400000304000A6C6566+
	?debug	C 74627574746F6E040000030200046D6B65790404+
	?debug	C 0606616363656E740602F4FF036D616A0602F8FF+
	?debug	C 036B65790602FCFF0470706F731F0A0600
	?debug	E
	?debug	E
_GetEvent	endp
	?debug	L 959
	assume	cs:BMSMAKY_TEXT
_GetKeyStatus	proc	far
	?debug	B
	?debug	B
	?debug	L 961
	mov	ax,word ptr DGROUP:keystatus
	?debug	L 962
	ret	
	?debug	E
	?debug	E
_GetKeyStatus	endp
	?debug	L 974
	assume	cs:BMSMAKY_TEXT
_DuplPixel	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,4
	?debug	C E322000400160200
	?debug	C E20002647904000264780400036478620400036E+
	?debug	C 62700A000663636F6C6F7204000673636F6C6F72+
	?debug	C 0480046461746122
	?debug	C E3210010001E
	?debug	C E320000400162100
	?debug	C E323000400162100
	?debug	C E60470706D64230A0A000470706D73200A0600
	?debug	B
	?debug	L 978
	?debug	L 983
	push	0
	les	bx,dword ptr [bp+10]
	mov	ax,word ptr es:[bx]
	mov	word ptr [bp-4],ax
	mov	ax,word ptr es:[bx+2]
	mov	word ptr [bp-2],ax
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	mov	word ptr [bp-4],0
	mov	word ptr [bp-2],0
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	mov	word ptr [bp-4],0
	mov	word ptr [bp-2],0
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	call	far ptr _CopyPixel
	add	sp,22
	?debug	L 984
	leave	
	ret	
	?debug	C E601701E02FCFF0470706D64230A0A000470706D+
	?debug	C 73200A0600
	?debug	E
	?debug	E
_DuplPixel	endp
	?debug	L 1002
	assume	cs:BMSMAKY_TEXT
shiftx	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,16
	push	si
	push	di
	?debug	C E324000400162100
	?debug	C E6057368696674040A0A000370706D240A0600
	mov	di,word ptr [bp+10]
	?debug	B
	?debug	L 1004
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+4]
	cwd	
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	?debug	L 1005
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	mov	word ptr [bp-8],dx
	mov	word ptr [bp-6],ax
	?debug	L 1007
	push	es
	push	bx
	mov	ax,word ptr es:[bx]
	pop	bx
	pop	es
	imul	word ptr es:[bx+6]
	mov	word ptr [bp-14],ax
	?debug	L 1010
	mov	ax,di
	mov	bx,8
	cwd	
	idiv	bx
	mov	di,ax
	?debug	L 1012
	or	di,di
	jle	short @30@170
	?debug	L 1014
	mov	ax,word ptr [bp-4]
	sub	ax,di
	mov	word ptr [bp-16],ax
	?debug	L 1015
	xor	si,si
	jmp	short @30@122
@30@74:
	?debug	L 1017
	mov	ax,word ptr [bp-6]
	mov	dx,word ptr [bp-8]
	mov	word ptr [bp-12],dx
	mov	word ptr [bp-10],ax
	?debug	L 1018
	push	word ptr [bp-16]
	mov	ax,word ptr [bp-12]
	add	ax,di
	push	word ptr [bp-10]
	push	ax
	push	word ptr [bp-10]
	push	word ptr [bp-12]
	call	far ptr _memmove
	add	sp,10
	?debug	L 1019
	mov	cx,word ptr [bp-2]
	mov	bx,word ptr [bp-4]
	mov	dx,ss
	lea	ax,word ptr [bp-8]
	call	far ptr F_PADA@
	?debug	L 1015
	inc	si
@30@122:
	cmp	si,word ptr [bp-14]
	jl	short @30@74
	?debug	L 1021
	jmp	short @30@266
@30@170:
	?debug	L 1024
	mov	ax,di
	neg	ax
	mov	di,ax
	?debug	L 1025
	mov	ax,word ptr [bp-4]
	sub	ax,di
	mov	word ptr [bp-16],ax
	?debug	L 1026
	xor	si,si
	jmp	short @30@242
@30@194:
	?debug	L 1028
	mov	ax,word ptr [bp-6]
	mov	dx,word ptr [bp-8]
	mov	word ptr [bp-12],dx
	mov	word ptr [bp-10],ax
	?debug	L 1029
	push	word ptr [bp-16]
	push	word ptr [bp-10]
	push	word ptr [bp-12]
	mov	ax,word ptr [bp-12]
	add	ax,di
	push	word ptr [bp-10]
	push	ax
	call	far ptr _memmove
	add	sp,10
	?debug	L 1030
	mov	cx,word ptr [bp-2]
	mov	bx,word ptr [bp-4]
	mov	dx,ss
	lea	ax,word ptr [bp-8]
	call	far ptr F_PADA@
	?debug	L 1026
	inc	si
@30@242:
	cmp	si,word ptr [bp-14]
	jl	short @30@194
@30@266:
	?debug	L 1033
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E325000400160200
	?debug	C E326000400160201
	?debug	C E60169040406066C656E6774680402F0FF066865+
	?debug	C 696768740402F2FF01702502F4FF076261736570+
	?debug	C 74722602F8FF036478620602FCFF057368696674+
	?debug	C 040C070370706D240A0600
	?debug	E
	?debug	E
shiftx	endp
	?debug	L 1036
	assume	cs:BMSMAKY_TEXT
shifty	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,16
	push	si
	push	di
	?debug	C E327000400162100
	?debug	C E6057368696674040A0A000370706D270A0600
	mov	di,word ptr [bp+10]
	?debug	B
	?debug	L 1038
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+4]
	cwd	
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	?debug	L 1039
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	mov	word ptr [bp-8],dx
	mov	word ptr [bp-6],ax
	?debug	L 1041
	push	es
	push	bx
	mov	ax,word ptr es:[bx]
	pop	bx
	pop	es
	imul	word ptr es:[bx+6]
	mov	word ptr [bp-14],ax
	?debug	L 1044
	or	di,di
	jg	@@193
	jmp	@31@170
@@193:
	?debug	L 1046
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx]
	sub	ax,di
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	mov	word ptr [bp-16],ax
	?debug	L 1047
	mov	ax,di
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	mov	di,ax
	?debug	L 1048
	xor	si,si
	jmp	short @31@122
@31@74:
	?debug	L 1050
	mov	ax,word ptr [bp-6]
	mov	dx,word ptr [bp-8]
	mov	word ptr [bp-12],dx
	mov	word ptr [bp-10],ax
	?debug	L 1051
	push	word ptr [bp-16]
	mov	ax,word ptr [bp-12]
	add	ax,di
	push	word ptr [bp-10]
	push	ax
	push	word ptr [bp-10]
	push	word ptr [bp-12]
	call	far ptr _memmove
	add	sp,10
	?debug	L 1052
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx]
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	push	ax
	push	dx
	mov	dx,ss
	lea	ax,word ptr [bp-8]
	pop	cx
	pop	bx
	call	far ptr F_PADA@
	?debug	L 1048
	inc	si
@31@122:
	cmp	si,4
	jl	short @31@74
	?debug	L 1054
	jmp	@31@266
@31@170:
	?debug	L 1057
	mov	ax,di
	neg	ax
	mov	di,ax
	?debug	L 1058
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx]
	sub	ax,di
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	mov	word ptr [bp-16],ax
	?debug	L 1059
	mov	ax,di
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	mov	di,ax
	?debug	L 1060
	xor	si,si
	jmp	short @31@242
@31@194:
	?debug	L 1062
	mov	ax,word ptr [bp-6]
	mov	dx,word ptr [bp-8]
	mov	word ptr [bp-12],dx
	mov	word ptr [bp-10],ax
	?debug	L 1063
	push	word ptr [bp-16]
	push	word ptr [bp-10]
	push	word ptr [bp-12]
	mov	ax,word ptr [bp-12]
	add	ax,di
	push	word ptr [bp-10]
	push	ax
	call	far ptr _memmove
	add	sp,10
	?debug	L 1064
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx]
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	push	ax
	push	dx
	mov	dx,ss
	lea	ax,word ptr [bp-8]
	pop	cx
	pop	bx
	call	far ptr F_PADA@
	?debug	L 1060
	inc	si
@31@242:
	cmp	si,4
	jl	short @31@194
@31@266:
	?debug	L 1067
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E328000400160200
	?debug	C E329000400160201
	?debug	C E60169040406066C656E6774680402F0FF066865+
	?debug	C 696768740402F2FF01702802F4FF076261736570+
	?debug	C 74722902F8FF036478620602FCFF057368696674+
	?debug	C 040C070370706D270A0600
	?debug	E
	?debug	E
shifty	endp
	?debug	L 1070
	assume	cs:BMSMAKY_TEXT
_ScrollPixel	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	?debug	C E32A000400162100
	?debug	C E2000270311E800270321E
	?debug	C E32C0008001E
	?debug	C E32B000400162C00
	?debug	C E605707A6F6E652B0A100005636F6C6F72020A0E+
	?debug	C 000573686966741E0A0A000370706D2A0A0600
	?debug	B
	?debug	L 1073
	les	bx,dword ptr [bp+16]
	mov	word ptr es:[bx+2],0
	?debug	L 1074
	mov	word ptr es:[bx],0
	?debug	L 1075
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+2]
	les	bx,dword ptr [bp+16]
	mov	word ptr es:[bx+6],ax
	?debug	L 1076
	push	es
	les	si,dword ptr [bp+6]
	mov	ax,word ptr es:[si]
	pop	es
	mov	word ptr es:[bx+4],ax
	?debug	L 1078
	cmp	word ptr [bp+12],0
	jne	short @32@74
	cmp	word ptr [bp+10],0
	jne	@@194
	jmp	@32@410
@@194:
@32@74:
	?debug	L 1080
	cmp	word ptr [bp+12],0
	je	short @32@122
	cmp	word ptr [bp+10],0
	je	@@195
	jmp	@32@410
@@195:
@32@122:
	?debug	L 1083
	cmp	word ptr [bp+12],0
	jge	short @32@194
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+2]
	neg	ax
	cmp	ax,word ptr [bp+12]
	jge	short @32@194
	?debug	L 1085
	push	word ptr [bp+12]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr shiftx
	add	sp,6
	?debug	L 1086
	les	bx,dword ptr [bp+16]
	mov	ax,word ptr [bp+12]
	neg	ax
	mov	word ptr es:[bx+6],ax
@32@194:
	?debug	L 1088
	cmp	word ptr [bp+12],0
	jle	short @32@266
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+2]
	cmp	ax,word ptr [bp+12]
	jle	short @32@266
	?debug	L 1090
	push	word ptr [bp+12]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr shiftx
	add	sp,6
	?debug	L 1091
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+2]
	sub	ax,word ptr [bp+12]
	les	bx,dword ptr [bp+16]
	mov	word ptr es:[bx+2],ax
@32@266:
	?debug	L 1093
	cmp	word ptr [bp+10],0
	jge	short @32@338
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx]
	neg	ax
	cmp	ax,word ptr [bp+10]
	jge	short @32@338
	?debug	L 1095
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr shifty
	add	sp,6
	?debug	L 1096
	les	bx,dword ptr [bp+16]
	mov	ax,word ptr [bp+10]
	neg	ax
	mov	word ptr es:[bx+4],ax
@32@338:
	?debug	L 1098
	cmp	word ptr [bp+10],0
	jle	short @32@410
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx]
	cmp	ax,word ptr [bp+10]
	jle	short @32@410
	?debug	L 1100
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr shifty
	add	sp,6
	?debug	L 1101
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx]
	sub	ax,word ptr [bp+10]
	les	bx,dword ptr [bp+16]
	mov	word ptr es:[bx],ax
@32@410:
	?debug	L 1104
	mov	al,byte ptr [bp+14]
	push	ax
	push	0
	mov	dx,word ptr [bp+18]
	mov	ax,word ptr [bp+16]
	mov	cx,8
	call	far ptr F_SPUSH@
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	call	far ptr _DrawFillRect
	add	sp,16
	?debug	L 1106
	pop	si
	pop	bp
	ret	
	?debug	C E605707A6F6E652B0A100005636F6C6F72020A0E+
	?debug	C 000573686966741E0A0A000370706D2A0A0600
	?debug	E
	?debug	E
_ScrollPixel	endp
	?debug	L 1127
	assume	cs:BMSMAKY_TEXT
_spmemmove	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	push	di
	?debug	C E6066C656E677468040A0A0003737263040A0800+
	?debug	C 0464657374040A0600
	?debug	B
	?debug	L 1134
 	push	 ds 
	?debug	L 1135
 	push	 es 
	?debug	L 1136
 	push	 si 
	?debug	L 1137
 	push	 di 
	?debug	L 1138
 	push	 cx 
	?debug	L 1139
 	mov	 ax,0a000H 
	?debug	L 1140
 	mov	 es, ax 
	?debug	L 1141
 	mov	 ds, ax 
	?debug	L 1143
 	mov	 si,[bp+8] 
	?debug	L 1144
 	mov	 di,[bp+6] 
	?debug	L 1145
 	mov	 cx,[bp+10] 
	?debug	L 1147
	mov	ax,word ptr [bp+8]
	cmp	ax,word ptr [bp+6]
	jg	short @33@506
	?debug	L 1150
 	std	 
	?debug	L 1151
 	mov	 si,[bp+8] 
	?debug	L 1152
 	mov	 di,[bp+6] 
	?debug	L 1153
 	add	 si,cx 
	?debug	L 1154
 	add	 di,cx 
	?debug	L 1155
 	sub	 si,2 
	?debug	L 1156
 	sub	 di,2 
	?debug	L 1158
	jmp	short @33@530
@33@506:
	?debug	L 1162
 	cld	 
@33@530:
	?debug	L 1165
 	shr	 cx,1
	?debug	L 1166
 	rep movsw	 
	?debug	L 1168
 	cld	 
	?debug	L 1170
 	pop	 cx 
	?debug	L 1171
 	pop	 di 
	?debug	L 1172
 	pop	 si 
	?debug	L 1173
 	pop	 es 
	?debug	L 1174
 	pop	 ds 
	?debug	L 1180
	pop	di
	pop	si
	pop	bp
	ret	
	?debug	C E6066C656E677468040A0A0003737263040A0800+
	?debug	C 0464657374040A0600
	?debug	E
	?debug	E
_spmemmove	endp
	?debug	L 1182
	assume	cs:BMSMAKY_TEXT
shiftxpart	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,14
	push	si
	push	di
	?debug	C E32D000400162100
	?debug	C E6057368696674040A12000364696D1E0A0E0003+
	?debug	C 706F731E0A0A000370706D2D0A0600
	mov	di,word ptr [bp+18]
	?debug	B
	?debug	L 1184
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+4]
	cwd	
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	?debug	L 1186
	mov	ax,word ptr [bp+14]
	mov	word ptr [bp-10],ax
	?debug	L 1191
	push	cs
	call	near ptr _HideMouseInt
	?debug	L 1192
	mov	ax,di
	mov	bx,8
	cwd	
	idiv	bx
	mov	di,ax
	?debug	L 1194
	mov	ax,word ptr [bp+6]
	or	ax,word ptr [bp+8]
	jne	short @34@74
	?debug	L 1196
	mov	word ptr [bp-4],80
	mov	word ptr [bp-2],0
	?debug	L 1197
	mov	ax,word ptr [bp+10]
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	push	ax
	mov	ax,word ptr [bp+12]
	mov	bx,8
	cwd	
	idiv	bx
	pop	dx
	add	ax,dx
	mov	word ptr [bp-8],ax
@34@74:
	?debug	L 1200
	?debug	L 1204
	or	di,di
	jg	@@196
	jmp	@34@314
@@196:
	?debug	L 1206
	mov	ax,word ptr [bp+16]
	mov	bx,8
	cwd	
	idiv	bx
	sub	ax,di
	mov	word ptr [bp-12],ax
	?debug	L 1207
	mov	word ptr [bp-14],0
	jmp	@34@266
@34@122:
	?debug	L 1209
	xor	si,si
	jmp	short @34@194
@34@146:
	?debug	L 1211
	mov	ax,word ptr [bp-8]
	mov	word ptr [bp-6],ax
	?debug	L 1212
	push	si
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 1213
	push	word ptr [bp-12]
	mov	ax,word ptr [bp-6]
	add	ax,di
	push	ax
	push	word ptr [bp-6]
	push	cs
	call	near ptr _spmemmove
	add	sp,6
	?debug	L 1214
	mov	ax,word ptr [bp-6]
	add	ax,word ptr [bp-4]
	mov	word ptr [bp-6],ax
	?debug	L 1215
	push	word ptr [bp-12]
	add	ax,di
	push	ax
	push	word ptr [bp-6]
	push	cs
	call	near ptr _spmemmove
	add	sp,6
	?debug	L 1216
	mov	ax,word ptr [bp-6]
	add	ax,word ptr [bp-4]
	mov	word ptr [bp-6],ax
	?debug	L 1217
	push	word ptr [bp-12]
	add	ax,di
	push	ax
	push	word ptr [bp-6]
	push	cs
	call	near ptr _spmemmove
	add	sp,6
	?debug	L 1218
	mov	ax,word ptr [bp-6]
	add	ax,word ptr [bp-4]
	mov	word ptr [bp-6],ax
	?debug	L 1219
	push	word ptr [bp-12]
	add	ax,di
	push	ax
	push	word ptr [bp-6]
	push	cs
	call	near ptr _spmemmove
	add	sp,6
	?debug	L 1209
	inc	si
@34@194:
	cmp	si,4
	jl	short @34@146
	?debug	L 1222
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	dx,word ptr [bp-8]
	add	dx,ax
	mov	word ptr [bp-8],dx
	?debug	L 1207
	inc	word ptr [bp-14]
@34@266:
	mov	ax,word ptr [bp-10]
	mov	bx,4
	cwd	
	idiv	bx
	cmp	ax,word ptr [bp-14]
	jle	@@197
	jmp	@34@122
@@197:
	?debug	L 1224
	jmp	@34@506
@34@314:
	?debug	L 1227
	mov	ax,di
	neg	ax
	mov	di,ax
	?debug	L 1228
	mov	ax,word ptr [bp+16]
	mov	bx,8
	cwd	
	idiv	bx
	sub	ax,di
	mov	word ptr [bp-12],ax
	?debug	L 1229
	mov	word ptr [bp-14],0
	jmp	@34@482
@34@338:
	?debug	L 1231
	xor	si,si
	jmp	short @34@410
@34@362:
	?debug	L 1233
	mov	ax,word ptr [bp-8]
	mov	word ptr [bp-6],ax
	?debug	L 1234
	push	si
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 1235
	push	word ptr [bp-12]
	push	word ptr [bp-6]
	mov	ax,word ptr [bp-6]
	add	ax,di
	push	ax
	push	cs
	call	near ptr _spmemmove
	add	sp,6
	?debug	L 1236
	mov	ax,word ptr [bp-6]
	add	ax,word ptr [bp-4]
	mov	word ptr [bp-6],ax
	?debug	L 1237
	push	word ptr [bp-12]
	push	word ptr [bp-6]
	add	ax,di
	push	ax
	push	cs
	call	near ptr _spmemmove
	add	sp,6
	?debug	L 1238
	mov	ax,word ptr [bp-6]
	add	ax,word ptr [bp-4]
	mov	word ptr [bp-6],ax
	?debug	L 1239
	push	word ptr [bp-12]
	push	word ptr [bp-6]
	add	ax,di
	push	ax
	push	cs
	call	near ptr _spmemmove
	add	sp,6
	?debug	L 1240
	mov	ax,word ptr [bp-6]
	add	ax,word ptr [bp-4]
	mov	word ptr [bp-6],ax
	?debug	L 1241
	push	word ptr [bp-12]
	push	word ptr [bp-6]
	add	ax,di
	push	ax
	push	cs
	call	near ptr _spmemmove
	add	sp,6
	?debug	L 1231
	inc	si
@34@410:
	cmp	si,4
	jl	short @34@362
	?debug	L 1244
	mov	ax,word ptr [bp-4]
	shl	ax,2
	mov	dx,word ptr [bp-8]
	add	dx,ax
	mov	word ptr [bp-8],dx
	?debug	L 1229
	inc	word ptr [bp-14]
@34@482:
	mov	ax,word ptr [bp-10]
	mov	bx,4
	cwd	
	idiv	bx
	cmp	ax,word ptr [bp-14]
	jle	@@198
	jmp	@34@338
@@198:
@34@506:
	?debug	L 1247
	push	cs
	call	near ptr _ShowMouseInt
	?debug	L 1248
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E602706C04040601690402F2FF066C656E677468+
	?debug	C 0402F4FF066865696768740402F6FF0762617365+
	?debug	C 6F66730402F8FF01700402FAFF036478620602FC+
	?debug	C FF057368696674040C070364696D1E0A0E000370+
	?debug	C 6F731E0A0A000370706D2D0A0600
	?debug	E
	?debug	E
shiftxpart	endp
	?debug	L 1252
	assume	cs:BMSMAKY_TEXT
shiftypart	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,16
	push	si
	push	di
	?debug	C E32E000400162100
	?debug	C E6057368696674040A12000364696D1E0A0E0003+
	?debug	C 706F731E0A0A000370706D2E0A0600
	mov	di,word ptr [bp+18]
	?debug	B
	?debug	L 1254
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+4]
	cwd	
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	?debug	L 1255
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	mov	word ptr [bp-8],dx
	mov	word ptr [bp-6],ax
	?debug	L 1257
	mov	ax,word ptr [bp+14]
	mov	word ptr [bp-14],ax
	?debug	L 1261
	mov	ax,word ptr [bp+6]
	or	ax,word ptr [bp+8]
	jne	short @35@74
	?debug	L 1263
	mov	word ptr [bp-4],80
	mov	word ptr [bp-2],0
	?debug	L 1264
	mov	ax,word ptr [bp+10]
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	push	ax
	mov	ax,word ptr [bp+12]
	mov	bx,8
	cwd	
	idiv	bx
	pop	dx
	add	ax,dx
	add	ax,0
	mov	word ptr [bp-8],ax
	mov	word ptr [bp-6],40960
@35@74:
	?debug	L 1267
	mov	ax,word ptr [bp+14]
	sub	ax,di
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	mov	word ptr [bp-16],ax
	?debug	L 1269
	or	di,di
	jle	short @35@218
	?debug	L 1271
	mov	ax,di
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	mov	di,ax
	?debug	L 1272
	xor	si,si
	jmp	short @35@170
@35@122:
	?debug	L 1274
	mov	ax,word ptr [bp-6]
	mov	dx,word ptr [bp-8]
	mov	word ptr [bp-12],dx
	mov	word ptr [bp-10],ax
	?debug	L 1275
	push	word ptr [bp-16]
	mov	ax,word ptr [bp-12]
	add	ax,di
	push	word ptr [bp-10]
	push	ax
	push	word ptr [bp-10]
	push	word ptr [bp-12]
	call	far ptr _memmove
	add	sp,10
	?debug	L 1276
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx]
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	add	word ptr [bp-8],ax
	?debug	L 1272
	inc	si
@35@170:
	cmp	si,4
	jl	short @35@122
	?debug	L 1278
	jmp	short @35@314
@35@218:
	?debug	L 1281
	mov	ax,di
	neg	ax
	mov	di,ax
	?debug	L 1282
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	mov	di,ax
	?debug	L 1283
	xor	si,si
	jmp	short @35@290
@35@242:
	?debug	L 1285
	mov	ax,word ptr [bp-6]
	mov	dx,word ptr [bp-8]
	mov	word ptr [bp-12],dx
	mov	word ptr [bp-10],ax
	?debug	L 1286
	push	word ptr [bp-16]
	push	word ptr [bp-10]
	push	word ptr [bp-12]
	mov	ax,word ptr [bp-12]
	add	ax,di
	push	word ptr [bp-10]
	push	ax
	call	far ptr _memmove
	add	sp,10
	?debug	L 1287
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx]
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	add	word ptr [bp-8],ax
	?debug	L 1283
	inc	si
@35@290:
	cmp	si,4
	jl	short @35@242
@35@314:
	?debug	L 1290
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E32F000400160200
	?debug	C E330000400160200
	?debug	C E60169040406066C656E6774680402F0FF066865+
	?debug	C 696768740402F2FF01702F02F4FF076261736570+
	?debug	C 74723002F8FF036478620602FCFF057368696674+
	?debug	C 040C070364696D1E0A0E0003706F731E0A0A0003+
	?debug	C 70706D2E0A0600
	?debug	E
	?debug	E
shiftypart	endp
	?debug	L 1293
	assume	cs:BMSMAKY_TEXT
_ScrollPixelRect	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E331000400162100
	?debug	C E332000400162C00
	?debug	C E605707A6F6E65320A180005636F6C6F72020A16+
	?debug	C 000573686966741E0A12000364696D1E0A0E0003+
	?debug	C 706F731E0A0A000370706D310A0600
	?debug	B
	?debug	L 1297
	les	bx,dword ptr [bp+24]
	mov	ax,word ptr [bp+12]
	mov	word ptr es:[bx+2],ax
	?debug	L 1298
	mov	ax,word ptr [bp+10]
	mov	word ptr es:[bx],ax
	?debug	L 1299
	mov	ax,word ptr [bp+12]
	add	ax,word ptr [bp+16]
	mov	word ptr es:[bx+6],ax
	?debug	L 1300
	mov	ax,word ptr [bp+10]
	add	ax,word ptr [bp+14]
	mov	word ptr es:[bx+4],ax
	?debug	L 1302
	cmp	word ptr [bp+20],0
	jne	short @36@74
	cmp	word ptr [bp+18],0
	jne	@@199
	jmp	@36@410
@@199:
@36@74:
	?debug	L 1303
	cmp	word ptr [bp+20],0
	je	short @36@122
	cmp	word ptr [bp+18],0
	je	@@200
	jmp	@36@410
@@200:
@36@122:
	?debug	L 1305
	cmp	word ptr [bp+20],0
	jge	short @36@194
	mov	ax,word ptr [bp+16]
	neg	ax
	cmp	ax,word ptr [bp+20]
	jge	short @36@194
	?debug	L 1307
	push	word ptr [bp+20]
	push	word ptr [bp+16]
	push	word ptr [bp+14]
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr shiftxpart
	add	sp,14
	?debug	L 1308
	les	bx,dword ptr [bp+24]
	mov	ax,word ptr [bp+12]
	sub	ax,word ptr [bp+20]
	mov	word ptr es:[bx+6],ax
@36@194:
	?debug	L 1310
	cmp	word ptr [bp+20],0
	jle	short @36@266
	mov	ax,word ptr [bp+20]
	cmp	ax,word ptr [bp+16]
	jge	short @36@266
	?debug	L 1312
	push	word ptr [bp+20]
	push	word ptr [bp+16]
	push	word ptr [bp+14]
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr shiftxpart
	add	sp,14
	?debug	L 1313
	les	bx,dword ptr [bp+24]
	mov	ax,word ptr [bp+12]
	add	ax,word ptr [bp+16]
	sub	ax,word ptr [bp+20]
	mov	word ptr es:[bx+2],ax
@36@266:
	?debug	L 1315
	cmp	word ptr [bp+18],0
	jge	short @36@338
	mov	ax,word ptr [bp+14]
	neg	ax
	cmp	ax,word ptr [bp+18]
	jge	short @36@338
	?debug	L 1317
	push	word ptr [bp+20]
	push	word ptr [bp+16]
	push	word ptr [bp+14]
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr shiftypart
	add	sp,14
	?debug	L 1318
	les	bx,dword ptr [bp+24]
	mov	ax,word ptr [bp+10]
	sub	ax,word ptr [bp+18]
	mov	word ptr es:[bx+4],ax
@36@338:
	?debug	L 1320
	cmp	word ptr [bp+18],0
	jle	short @36@410
	mov	ax,word ptr [bp+18]
	cmp	ax,word ptr [bp+14]
	jge	short @36@410
	?debug	L 1322
	push	word ptr [bp+20]
	push	word ptr [bp+16]
	push	word ptr [bp+14]
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr shiftypart
	add	sp,14
	?debug	L 1323
	mov	ax,word ptr [bp+10]
	add	ax,word ptr [bp+14]
	sub	ax,word ptr [bp+18]
	les	bx,dword ptr [bp+24]
	mov	word ptr es:[bx],ax
@36@410:
	?debug	L 1327
	cmp	byte ptr [bp+22],255
	je	short @36@458
	?debug	L 1328
	mov	al,byte ptr [bp+22]
	push	ax
	push	0
	mov	dx,word ptr [bp+26]
	mov	ax,word ptr [bp+24]
	mov	cx,8
	call	far ptr F_SPUSH@
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	call	far ptr _DrawFillRect
	add	sp,16
@36@458:
	?debug	L 1329
	pop	bp
	ret	
	?debug	C E605707A6F6E65320A180005636F6C6F72020A16+
	?debug	C 000573686966741E0A12000364696D1E0A0E0003+
	?debug	C 706F731E0A0A000370706D310A0600
	?debug	E
	?debug	E
_ScrollPixelRect	endp
	?debug	L 1339
	assume	cs:BMSMAKY_TEXT
_chgmode	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	?debug	C E603736574040A0A0003636C72040A0800046D6F+
	?debug	C 6465040A0600
	mov	si,word ptr [bp+6]
	?debug	B
	?debug	L 1341
	test	word ptr [bp+10],1
	je	short @37@170
	?debug	L 1342
	test	word ptr [bp+8],1
	je	short @37@146
	?debug	L 1343
	or	si,si
	jne	short @37@122
	?debug	L 1344
	mov	ax,12
	jmp	short @37@338
@37@122:
	?debug	L 1346
	mov	ax,1
	jmp	short @37@338
@37@146:
	?debug	L 1348
	mov	ax,si
	jmp	short @37@338
@37@170:
	?debug	L 1350
	test	word ptr [bp+8],1
	je	short @37@266
	?debug	L 1351
	or	si,si
	jne	short @37@242
	?debug	L 1352
	mov	ax,4
	jmp	short @37@338
@37@242:
	?debug	L 1354
	mov	ax,si
	xor	ax,7
	jmp	short @37@338
@37@266:
	?debug	L 1356
	or	si,si
	jne	short @37@314
	?debug	L 1357
	mov	ax,8
	jmp	short @37@338
@37@314:
	?debug	L 1359
	mov	ax,6
@37@338:
	?debug	L 1360
	pop	si
	pop	bp
	ret	
	?debug	C E603736574040A0A0003636C72040A0800046D6F+
	?debug	C 6465040C06
	?debug	E
	?debug	E
_chgmode	endp
	?debug	L 1379
	assume	cs:BMSMAKY_TEXT
_CopyPixel	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,52
	push	si
	push	di
	?debug	C E333000400162100
	?debug	C E334000400162100
	?debug	C E400084D4F44454C4F4144000000064D4F44454F+
	?debug	C 52020000074D4F4445414E44050080074D4F4445+
	?debug	C 584F520700
	?debug	C E33500020022000080FF7F
	?debug	C E6046D6F6465350A1A000364696D1E0A1600026F+
	?debug	C 641E0A12000470706D64340A0E00026F731E0A0A+
	?debug	C 000470706D73330A0600
	mov	si,word ptr [bp+26]
	?debug	B
	?debug	L 1383
	les	bx,dword ptr [bp+6]
	push	es
	mov	di,word ptr [bp+6]
	mov	ax,word ptr es:[di]
	pop	es
	imul	word ptr es:[bx+4]
	cwd	
	mov	word ptr [bp-6],ax
	mov	word ptr [bp-4],dx
	?debug	L 1384
	les	bx,dword ptr [bp+14]
	push	es
	mov	es,word ptr [bp+8]
	mov	ax,word ptr es:[di]
	pop	es
	imul	word ptr es:[bx+4]
	cwd	
	mov	word ptr [bp-10],ax
	mov	word ptr [bp-8],dx
	?debug	L 1386
	mov	ax,word ptr [bp+14]
	or	ax,word ptr [bp+16]
	jne	@@201
	jmp	@38@386
@@201:
	?debug	L 1388
	cmp	word ptr [bp+20],0
	jge	short @38@146
	?debug	L 1390
	mov	ax,word ptr [bp+20]
	add	word ptr [bp+24],ax
	?debug	L 1391
	cmp	word ptr [bp+24],0
	jg	short @38@122
	?debug	L 1392
	mov	ax,1
	jmp	@38@1610
@38@122:
	?debug	L 1393
	mov	ax,word ptr [bp+20]
	sub	word ptr [bp+12],ax
	?debug	L 1394
	mov	word ptr [bp+20],0
@38@146:
	?debug	L 1396
	les	bx,dword ptr [bp+14]
	mov	ax,word ptr [bp+20]
	add	ax,word ptr [bp+24]
	cmp	word ptr es:[bx+2],ax
	jge	short @38@218
	?debug	L 1398
	mov	ax,word ptr [bp+20]
	add	ax,word ptr [bp+24]
	sub	ax,word ptr es:[bx+2]
	mov	dx,word ptr [bp+24]
	sub	dx,ax
	mov	word ptr [bp+24],dx
	?debug	L 1399
	cmp	word ptr [bp+24],0
	jg	short @38@218
	?debug	L 1400
	mov	ax,1
	jmp	@38@1610
@38@218:
	?debug	L 1403
	cmp	word ptr [bp+18],0
	jge	short @38@314
	?debug	L 1405
	mov	ax,word ptr [bp+18]
	add	word ptr [bp+22],ax
	?debug	L 1406
	cmp	word ptr [bp+22],0
	jg	short @38@290
	?debug	L 1407
	mov	ax,1
	jmp	@38@1610
@38@290:
	?debug	L 1408
	mov	ax,word ptr [bp+18]
	sub	word ptr [bp+10],ax
	?debug	L 1409
	mov	word ptr [bp+18],0
@38@314:
	?debug	L 1411
	mov	ax,word ptr [bp+18]
	add	ax,word ptr [bp+22]
	les	bx,dword ptr [bp+14]
	cmp	ax,word ptr es:[bx]
	jle	short @38@386
	?debug	L 1413
	mov	ax,word ptr [bp+18]
	add	ax,word ptr [bp+22]
	sub	ax,word ptr es:[bx]
	mov	dx,word ptr [bp+22]
	sub	dx,ax
	mov	word ptr [bp+22],dx
	?debug	L 1414
	cmp	word ptr [bp+22],0
	jg	short @38@386
	?debug	L 1415
	mov	ax,1
	jmp	@38@1610
@38@386:
	?debug	L 1419
	mov	ax,word ptr [bp+12]
	mov	word ptr [bp-38],ax
	?debug	L 1420
	mov	ax,word ptr [bp+10]
	mov	word ptr [bp-36],ax
	?debug	L 1421
	mov	ax,word ptr [bp+12]
	add	ax,word ptr [bp+24]
	mov	word ptr [bp-34],ax
	?debug	L 1422
	mov	ax,word ptr [bp+10]
	add	ax,word ptr [bp+22]
	mov	word ptr [bp-32],ax
	?debug	L 1423
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+4]
	mov	word ptr [bp-30],ax
	?debug	L 1424
	mov	ax,word ptr [bp+20]
	mov	word ptr [bp-52],ax
	?debug	L 1425
	mov	ax,word ptr [bp+18]
	mov	word ptr [bp-50],ax
	?debug	L 1426
	mov	ax,word ptr [bp+20]
	add	ax,word ptr [bp+24]
	mov	word ptr [bp-48],ax
	?debug	L 1427
	mov	ax,word ptr [bp+18]
	add	ax,word ptr [bp+22]
	mov	word ptr [bp-46],ax
	?debug	L 1428
	les	bx,dword ptr [bp+14]
	mov	ax,word ptr es:[bx+4]
	mov	word ptr [bp-44],ax
	?debug	L 1432
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	mov	word ptr [bp-28],dx
	mov	word ptr [bp-26],ax
	?debug	L 1433
	les	bx,dword ptr [bp+14]
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	mov	word ptr [bp-42],dx
	mov	word ptr [bp-40],ax
	?debug	L 1435
	mov	ax,word ptr [bp+6]
	or	ax,word ptr [bp+8]
	jne	short @38@530
	?debug	L 1437
	push	ss
	lea	ax,word ptr [bp-38]
	push	ax
	push	cs
	call	near ptr _ifhidemousex
	add	sp,4
	?debug	L 1438
	mov	word ptr [bp-30],80
	?debug	L 1439
	mov	word ptr [bp-28],0
	mov	word ptr [bp-26],40960
	?debug	L 1440
	push	cs
	call	near ptr _HideMouseInt
	?debug	L 1441
	mov	word ptr [bp-2],0
	jmp	short @38@482
@38@434:
	?debug	L 1443
	push	word ptr [bp-2]
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 1444
	push	si
	push	ss
	lea	ax,word ptr [bp-52]
	push	ax
	push	ss
	lea	ax,word ptr [bp-38]
	push	ax
	call	far ptr _blit
	add	sp,10
	?debug	L 1445
	les	bx,dword ptr [bp+14]
	mov	ax,word ptr es:[bx]
	imul	word ptr [bp-44]
	cwd	
	push	ax
	push	dx
	mov	dx,ss
	lea	ax,word ptr [bp-42]
	pop	cx
	pop	bx
	call	far ptr F_PADA@
	?debug	L 1441
	inc	word ptr [bp-2]
@38@482:
	cmp	word ptr [bp-2],4
	jl	short @38@434
	?debug	L 1447
	push	cs
	call	near ptr _ShowMouseInt
	?debug	L 1448
	jmp	@38@1586
@38@530:
	?debug	L 1451
	mov	ax,word ptr [bp+14]
	or	ax,word ptr [bp+16]
	je	@@202
	jmp	@38@1274
@@202:
	?debug	L 1453
	push	ss
	lea	ax,word ptr [bp-52]
	push	ax
	push	cs
	call	near ptr _ifhidemousex
	add	sp,4
	?debug	L 1454
	mov	word ptr [bp-44],80
	?debug	L 1455
	mov	word ptr [bp-42],0
	mov	word ptr [bp-40],40960
	?debug	L 1456
	les	bx,dword ptr [bp+6]
	cmp	word ptr es:[bx+6],4
	je	@@203
	jmp	@38@1154
@@203:
	?debug	L 1458
	push	cs
	call	near ptr _HideMouseInt
	?debug	L 1459
	cmp	word ptr [bp+24],180
	jg	@@204
	jmp	@38@1034
@@204:
	cmp	word ptr [bp+22],70
	jg	@@205
	jmp	@38@1034
@@205:
	?debug	B
	?debug	L 1463
	mov	ax,word ptr [bp-26]
	mov	dx,word ptr [bp-28]
	mov	word ptr [bp-14],dx
	mov	word ptr [bp-12],ax
	?debug	L 1464
	mov	ax,word ptr [bp-36]
	inc	ax
	inc	ax
	mov	word ptr [bp-32],ax
	?debug	L 1465
	mov	ax,word ptr [bp-50]
	inc	ax
	inc	ax
	mov	word ptr [bp-46],ax
	?debug	L 1467
	jmp	@38@746
@38@650:
	?debug	B
	?debug	L 1474
	mov	ax,word ptr [bp-18]
	mov	dx,word ptr [bp-20]
	mov	word ptr [bp-14],dx
	mov	word ptr [bp-12],ax
	?debug	L 1475
	push	0
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 1476
	push	word ptr [bp-16]
	push	word ptr [bp-18]
	push	word ptr [bp-20]
	push	word ptr [bp-22]
	push	word ptr [bp-24]
	call	far ptr _memcpy
	add	sp,10
	?debug	L 1477
	mov	cx,word ptr [bp-4]
	mov	bx,word ptr [bp-6]
	mov	dx,ss
	lea	ax,word ptr [bp-20]
	call	far ptr F_PADA@
	?debug	L 1478
	push	1
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 1479
	push	word ptr [bp-16]
	push	word ptr [bp-18]
	push	word ptr [bp-20]
	push	word ptr [bp-22]
	push	word ptr [bp-24]
	call	far ptr _memcpy
	add	sp,10
	?debug	L 1480
	mov	cx,word ptr [bp-4]
	mov	bx,word ptr [bp-6]
	mov	dx,ss
	lea	ax,word ptr [bp-20]
	call	far ptr F_PADA@
	?debug	L 1481
	push	2
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 1482
	push	word ptr [bp-16]
	push	word ptr [bp-18]
	push	word ptr [bp-20]
	push	word ptr [bp-22]
	push	word ptr [bp-24]
	call	far ptr _memcpy
	add	sp,10
	?debug	L 1483
	mov	cx,word ptr [bp-4]
	mov	bx,word ptr [bp-6]
	mov	dx,ss
	lea	ax,word ptr [bp-20]
	call	far ptr F_PADA@
	?debug	L 1484
	push	3
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 1485
	push	word ptr [bp-16]
	push	word ptr [bp-18]
	push	word ptr [bp-20]
	push	word ptr [bp-22]
	push	word ptr [bp-24]
	call	far ptr _memcpy
	add	sp,10
	?debug	L 1487
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+4]
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [bp-12]
	mov	ax,word ptr [bp-14]
	pop	cx
	pop	bx
	call	far ptr F_PADD@
	mov	word ptr [bp-20],ax
	mov	word ptr [bp-18],dx
	?debug	L 1488
	xor	cx,cx
	mov	bx,80
	mov	dx,ss
	lea	ax,word ptr [bp-24]
	call	far ptr F_PADA@
	?debug	L 1472
	inc	di
	cmp	di,word ptr [bp+22]
	jge	@@206
	jmp	@38@650
@@206:
	?debug	C E337000400160201
	?debug	C E338000400160201
	?debug	C E60270643702E8FF0270733802ECFF026C670402+
	?debug	C F0FF
	?debug	E
	?debug	L 1490
	jmp	short @38@938
@38@746:
	?debug	L 1493
	xor	di,di
	jmp	short @38@914
@38@770:
	?debug	L 1495
	mov	word ptr [bp-2],0
	jmp	short @38@842
@38@794:
	?debug	L 1497
	push	word ptr [bp-2]
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 1498
	push	si
	push	ss
	lea	ax,word ptr [bp-52]
	push	ax
	push	ss
	lea	ax,word ptr [bp-38]
	push	ax
	call	far ptr _blit
	add	sp,10
	?debug	L 1499
	mov	cx,word ptr [bp-4]
	mov	bx,word ptr [bp-6]
	mov	dx,ss
	lea	ax,word ptr [bp-28]
	call	far ptr F_PADA@
	?debug	L 1495
	inc	word ptr [bp-2]
@38@842:
	cmp	word ptr [bp-2],4
	jl	short @38@794
	?debug	L 1501
	mov	ax,word ptr [bp-12]
	mov	dx,word ptr [bp-14]
	mov	word ptr [bp-28],dx
	mov	word ptr [bp-26],ax
	?debug	L 1502
	add	word ptr [bp-36],2
	?debug	L 1503
	add	word ptr [bp-32],2
	?debug	L 1504
	add	word ptr [bp-50],2
	?debug	L 1505
	add	word ptr [bp-46],2
	?debug	L 1493
	inc	di
	inc	di
@38@914:
	cmp	di,word ptr [bp+22]
	jl	short @38@770
@38@938:
	?debug	L 1508
	cmp	word ptr [bp+22],340
	jne	short @38@1130
	cmp	word ptr [bp+24],640
	jne	short @38@1130
	?debug	L 1510
	push	cs
	call	near ptr _ClrEvents
	?debug	C E339000400160201
	?debug	C E6066F6C647074723902F2FF0179040407
	?debug	E
	?debug	L 1512
	jmp	short @38@1130
@38@1034:
	?debug	L 1514
	mov	word ptr [bp-2],0
	jmp	short @38@1106
@38@1058:
	?debug	L 1516
	push	word ptr [bp-2]
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 1517
	push	si
	push	ss
	lea	ax,word ptr [bp-52]
	push	ax
	push	ss
	lea	ax,word ptr [bp-38]
	push	ax
	call	far ptr _blit
	add	sp,10
	?debug	L 1518
	mov	cx,word ptr [bp-4]
	mov	bx,word ptr [bp-6]
	mov	dx,ss
	lea	ax,word ptr [bp-28]
	call	far ptr F_PADA@
	?debug	L 1514
	inc	word ptr [bp-2]
@38@1106:
	cmp	word ptr [bp-2],4
	jl	short @38@1058
@38@1130:
	?debug	L 1520
	push	cs
	call	near ptr _ShowMouseInt
	?debug	L 1521
	jmp	@38@1586
@38@1154:
	?debug	L 1525
	push	cs
	call	near ptr _HideMouseInt
	?debug	L 1526
	mov	word ptr [bp-2],0
	jmp	short @38@1226
@38@1178:
	?debug	L 1528
	push	word ptr [bp-2]
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 1529
	?debug	L 1530
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+10]
	mov	cl,byte ptr [bp-2]
	sar	ax,cl
	push	ax
	mov	ax,word ptr es:[bx+8]
	sar	ax,cl
	push	ax
	push	si
	push	cs
	call	near ptr _chgmode
	add	sp,6
	push	ax
	push	ss
	lea	ax,word ptr [bp-52]
	push	ax
	push	ss
	lea	ax,word ptr [bp-38]
	push	ax
	call	far ptr _blit
	add	sp,10
	?debug	L 1526
	inc	word ptr [bp-2]
@38@1226:
	cmp	word ptr [bp-2],4
	jl	short @38@1178
	?debug	L 1532
	push	cs
	call	near ptr _ShowMouseInt
	?debug	L 1533
	jmp	@38@1586
@38@1274:
	?debug	L 1537
	les	bx,dword ptr [bp+6]
	cmp	word ptr es:[bx+6],4
	jne	short @38@1418
	?debug	L 1539
	mov	word ptr [bp-2],0
	jmp	short @38@1370
@38@1322:
	?debug	L 1541
	push	si
	push	ss
	lea	ax,word ptr [bp-52]
	push	ax
	push	ss
	lea	ax,word ptr [bp-38]
	push	ax
	call	far ptr _blit
	add	sp,10
	?debug	L 1542
	mov	cx,word ptr [bp-4]
	mov	bx,word ptr [bp-6]
	mov	dx,ss
	lea	ax,word ptr [bp-28]
	call	far ptr F_PADA@
	?debug	L 1543
	les	bx,dword ptr [bp+14]
	mov	ax,word ptr es:[bx]
	imul	word ptr [bp-44]
	cwd	
	push	ax
	push	dx
	mov	dx,ss
	lea	ax,word ptr [bp-42]
	pop	cx
	pop	bx
	call	far ptr F_PADA@
	?debug	L 1539
	inc	word ptr [bp-2]
@38@1370:
	cmp	word ptr [bp-2],4
	jl	short @38@1322
	?debug	L 1546
	jmp	short @38@1586
@38@1418:
	?debug	L 1550
	les	bx,dword ptr [bp+14]
	cmp	word ptr es:[bx+6],4
	jne	short @38@1562
	?debug	L 1552
	mov	word ptr [bp-2],0
	jmp	short @38@1514
@38@1466:
	?debug	B
	?debug	L 1554
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+10]
	mov	cl,byte ptr [bp-2]
	sar	ax,cl
	push	ax
	mov	ax,word ptr es:[bx+8]
	sar	ax,cl
	push	ax
	push	si
	push	cs
	call	near ptr _chgmode
	add	sp,6
	mov	di,ax
	?debug	L 1555
	push	di
	push	ss
	lea	ax,word ptr [bp-52]
	push	ax
	push	ss
	lea	ax,word ptr [bp-38]
	push	ax
	call	far ptr _blit
	add	sp,10
	?debug	L 1556
	les	bx,dword ptr [bp+14]
	mov	ax,word ptr es:[bx]
	imul	word ptr [bp-44]
	cwd	
	push	ax
	push	dx
	mov	dx,ss
	lea	ax,word ptr [bp-42]
	pop	cx
	pop	bx
	call	far ptr F_PADA@
	?debug	C E60363686D040407
	?debug	E
	?debug	L 1552
	inc	word ptr [bp-2]
@38@1514:
	cmp	word ptr [bp-2],4
	jl	short @38@1466
	jmp	short @38@1586
@38@1562:
	?debug	L 1563
	push	si
	push	ss
	lea	ax,word ptr [bp-52]
	push	ax
	push	ss
	lea	ax,word ptr [bp-38]
	push	ax
	call	far ptr _blit
	add	sp,10
@38@1586:
	?debug	L 1567
	xor	ax,ax
@38@1610:
	?debug	L 1568
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E60A706C75737074726473740602F6FF07706C75+
	?debug	C 737074720602FAFF05706C616E650402FEFF0464+
	?debug	C 6573741B02CCFF037372631B02DAFF046D6F6465+
	?debug	C 350C060364696D1E0A1600026F641E0A12000470+
	?debug	C 706D64340A0E00026F731E0A0A000470706D7333+
	?debug	C 0A0600
	?debug	E
	?debug	E
_CopyPixel	endp
	?debug	L 1580
	assume	cs:BMSMAKY_TEXT
_OpenGraDesc	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E33A000400162100
	?debug	C E60370706D3A0A0600
	?debug	B
	?debug	L 1583
	pop	bp
	ret	
	?debug	C E60370706D3A0A0600
	?debug	E
	?debug	E
_OpenGraDesc	endp
	?debug	L 1595
	assume	cs:BMSMAKY_TEXT
_CloseGraDesc	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E33B000400162100
	?debug	C E60370706D3B0A0600
	?debug	B
	?debug	L 1597
	pop	bp
	ret	
	?debug	C E60370706D3B0A0600
	?debug	E
	?debug	E
_CloseGraDesc	endp
	?debug	L 1613
	assume	cs:BMSMAKY_TEXT
_DrawLine	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E33C000400162100
	?debug	C E605636F6C6F72020A1400046D6F6465350A1200+
	?debug	C 0270321E0A0E000270311E0A0A000370706D3C0A+
	?debug	C 0600
	?debug	B
	?debug	L 1615
	mov	ax,word ptr [bp+16]
	sub	ax,word ptr [bp+12]
	mov	word ptr [bp+16],ax
	?debug	L 1616
	mov	ax,word ptr [bp+14]
	sub	ax,word ptr [bp+10]
	mov	word ptr [bp+14],ax
	?debug	L 1617
	mov	al,byte ptr [bp+20]
	cbw	
	push	ax
	push	word ptr [bp+18]
	push	word ptr [bp+16]
	push	word ptr [bp+14]
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	call	far ptr __drawline
	add	sp,16
	?debug	L 1618
	pop	bp
	ret	
	?debug	C E605636F6C6F72020A1400046D6F6465350A1200+
	?debug	C 0270321E0A0E000270311E0A0A000370706D3C0A+
	?debug	C 0600
	?debug	E
	?debug	E
_DrawLine	endp
	?debug	L 1634
	assume	cs:BMSMAKY_TEXT
_DrawRect	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,10
	push	si
	?debug	C E33D000400162100
	?debug	C E605636F6C6F72020A1400046D6F6465350A1200+
	?debug	C 04726563742C0A0A000370706D3D0A0600
	mov	si,word ptr [bp+18]
	?debug	B
	?debug	L 1638
	mov	al,15
	sub	al,byte ptr [bp+20]
	mov	byte ptr [bp-9],al
	?debug	L 1640
	mov	ax,word ptr [bp+12]
	mov	dx,word ptr [bp+10]
	mov	word ptr [bp-4],dx
	mov	word ptr [bp-2],ax
	?debug	L 1641
	mov	ax,word ptr [bp+16]
	sub	ax,word ptr [bp+12]
	inc	ax
	mov	word ptr [bp-6],ax
	?debug	L 1642
	mov	word ptr [bp-8],0
	?debug	L 1643
	mov	al,byte ptr [bp-9]
	cbw	
	push	ax
	push	si
	push	word ptr [bp-6]
	push	word ptr [bp-8]
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	call	far ptr __drawline
	add	sp,16
	?debug	L 1645
	mov	ax,word ptr [bp+14]
	mov	word ptr [bp-4],ax
	?debug	L 1646
	mov	al,byte ptr [bp-9]
	cbw	
	push	ax
	push	si
	push	word ptr [bp-6]
	push	word ptr [bp-8]
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	call	far ptr __drawline
	add	sp,16
	?debug	L 1648
	mov	ax,word ptr [bp+10]
	inc	ax
	mov	word ptr [bp-4],ax
	?debug	L 1649
	mov	word ptr [bp-6],0
	?debug	L 1650
	mov	ax,word ptr [bp+14]
	sub	ax,word ptr [bp+10]
	dec	ax
	mov	word ptr [bp-8],ax
	?debug	L 1651
	mov	al,byte ptr [bp-9]
	cbw	
	push	ax
	push	si
	push	word ptr [bp-6]
	push	word ptr [bp-8]
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	call	far ptr __drawline
	add	sp,16
	?debug	L 1653
	mov	ax,word ptr [bp+16]
	mov	word ptr [bp-2],ax
	?debug	L 1654
	mov	al,byte ptr [bp-9]
	cbw	
	push	ax
	push	si
	push	word ptr [bp-6]
	push	word ptr [bp-8]
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	call	far ptr __drawline
	add	sp,16
	?debug	L 1656
	pop	si
	leave	
	ret	
	?debug	C E603636F6C0202F7FF0364696D1E02F8FF027031+
	?debug	C 1E02FCFF05636F6C6F72020A1400046D6F646535+
	?debug	C 0C0604726563742C0A0A000370706D3D0A0600
	?debug	E
	?debug	E
_DrawRect	endp
	?debug	L 1673
	assume	cs:BMSMAKY_TEXT
_DrawFillRect	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,8
	?debug	C E33E000400162100
	?debug	C E605636F6C6F72020A1400046D6F6465350A1200+
	?debug	C 04726563742C0A0A000370706D3E0A0600
	?debug	B
	?debug	L 1679
	cmp	word ptr [bp+18],0
	jne	short @43@74
	?debug	L 1682
	mov	ax,word ptr [bp+12]
	mov	dx,word ptr [bp+10]
	mov	word ptr [bp-4],dx
	mov	word ptr [bp-2],ax
	?debug	L 1683
	mov	ax,word ptr [bp+16]
	sub	ax,word ptr [bp+12]
	mov	word ptr [bp-6],ax
	?debug	L 1684
	mov	ax,word ptr [bp+14]
	sub	ax,word ptr [bp+10]
	mov	word ptr [bp-8],ax
	?debug	L 1686
	mov	al,byte ptr [bp+20]
	cbw	
	mov	dx,15
	sub	dx,ax
	push	dx
	push	word ptr [bp-6]
	push	word ptr [bp-8]
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	call	far ptr __clrrect
	add	sp,14
@43@74:
	?debug	L 1688
	leave	
	ret	
	?debug	C E60270321E02F8FF0270311E02FCFF05636F6C6F+
	?debug	C 72020A1400046D6F6465350A120004726563742C+
	?debug	C 0A0A000370706D3E0A0600
	?debug	E
	?debug	E
_DrawFillRect	endp
	?debug	L 1706
	assume	cs:BMSMAKY_TEXT
_GetPixel	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,4
	?debug	C E33F000400162100
	?debug	C E603706F731E0A0A000370706D3F0A0600
	?debug	B
	?debug	L 1710
	?debug	L 1711
	cmp	word ptr [bp+12],0
	jl	short @44@122
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+2]
	cmp	ax,word ptr [bp+12]
	jle	short @44@122
	cmp	word ptr [bp+10],0
	jl	short @44@122
	mov	ax,word ptr es:[bx]
	cmp	ax,word ptr [bp+10]
	jg	short @44@146
@44@122:
	jmp	short @44@242
@44@146:
	?debug	L 1714
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	mov	word ptr [bp-4],dx
	mov	word ptr [bp-2],ax
	?debug	L 1715
	cmp	word ptr es:[bx+6],1
	jne	short @44@242
	?debug	L 1717
	mov	ax,word ptr es:[bx+4]
	imul	word ptr [bp+10]
	add	word ptr [bp-4],ax
	?debug	L 1718
	mov	ax,word ptr [bp+12]
	mov	bx,8
	cwd	
	idiv	bx
	add	word ptr [bp-4],ax
	?debug	L 1719
	mov	ax,word ptr [bp+12]
	cwd	
	idiv	bx
	mov	cl,7
	sub	cl,dl
	mov	ax,1
	shl	ax,cl
	les	bx,dword ptr [bp-4]
	push	ax
	mov	al,byte ptr es:[bx]
	cbw	
	not	ax
	pop	dx
	test	dx,ax
	je	short @44@218
	?debug	L 1720
	mov	al,15
	jmp	short @44@266
@44@218:
	?debug	L 1721
	mov	al,0
	jmp	short @44@266
@44@242:
	?debug	L 1725
	mov	al,255
@44@266:
	?debug	L 1727
	leave	
	ret	
	?debug	C E340000400160200
	?debug	C E60270744002FCFF03706F731E0A0A000370706D+
	?debug	C 3F0A0600
	?debug	E
	?debug	E
_GetPixel	endp
	?debug	L 1741
	assume	cs:BMSMAKY_TEXT
_TestHLine	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,4
	push	si
	?debug	C E341000400162100
	?debug	C E60179040A0A000370706D410A0600
	?debug	B
	?debug	L 1746
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	push	ax
	mov	ax,word ptr es:[bx+4]
	push	dx
	imul	word ptr [bp+10]
	pop	dx
	add	dx,ax
	mov	word ptr [bp-4],dx
	pop	ax
	mov	word ptr [bp-2],ax
	?debug	L 1747
	xor	si,si
	jmp	short @45@122
@45@50:
	?debug	L 1749
	les	bx,dword ptr [bp-4]
	inc	word ptr [bp-4]
	cmp	byte ptr es:[bx],255
	je	short @45@98
	?debug	L 1750
	xor	ax,ax
	jmp	short @45@170
@45@98:
	?debug	L 1747
	inc	si
@45@122:
	cmp	si,10
	jl	short @45@50
	?debug	L 1752
	mov	ax,1
@45@170:
	?debug	L 1753
	pop	si
	leave	
	ret	
	?debug	C E342000400160200
	?debug	C E601690404060270744202FCFF0179040A0A0003+
	?debug	C 70706D410A0600
	?debug	E
	?debug	E
_TestHLine	endp
	?debug	L 1767
	assume	cs:BMSMAKY_TEXT
_TestVLine	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,4
	push	si
	push	di
	?debug	C E343000400162100
	?debug	C E60178040A0A000370706D430A0600
	?debug	B
	?debug	L 1773
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	push	ax
	mov	ax,word ptr [bp+10]
	mov	bx,8
	push	dx
	cwd	
	idiv	bx
	pop	dx
	add	dx,ax
	mov	word ptr [bp-4],dx
	pop	ax
	mov	word ptr [bp-2],ax
	?debug	L 1774
	mov	ax,word ptr [bp+10]
	cwd	
	idiv	bx
	mov	cl,7
	sub	cl,dl
	mov	ax,1
	shl	ax,cl
	mov	di,ax
	?debug	L 1775
	xor	si,si
	jmp	short @46@146
@46@50:
	?debug	L 1777
	les	bx,dword ptr [bp-4]
	mov	al,byte ptr es:[bx]
	cbw	
	not	ax
	test	ax,di
	je	short @46@98
	?debug	L 1778
	xor	ax,ax
	jmp	short @46@194
@46@98:
	?debug	L 1779
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+4]
	add	word ptr [bp-4],ax
	?debug	L 1775
	inc	si
@46@146:
	cmp	si,80
	jl	short @46@50
	?debug	L 1781
	mov	ax,1
@46@194:
	?debug	L 1782
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E344000400160200
	?debug	C E6046D61736B04040701690404060270744402FC+
	?debug	C FF0178040A0A000370706D430A0600
	?debug	E
	?debug	E
_TestVLine	endp
	?debug	L 1794
	assume	cs:BMSMAKY_TEXT
LoadCLUT	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E345000400160100
	?debug	C E606707461626C65450A0600
	?debug	B
	?debug	L 1796
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	call	far ptr _tcol_loadclut
	add	sp,4
	?debug	L 1797
	pop	bp
	ret	
	?debug	C E606707461626C65450A0600
	?debug	E
	?debug	E
LoadCLUT	endp
	?debug	L 1808
	assume	cs:BMSMAKY_TEXT
ClearMem	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	?debug	C E346000400160200
	?debug	C E60466696C6C040A0E00026C67060A0A00027074+
	?debug	C 460A0600
	mov	si,word ptr [bp+14]
	?debug	B
	?debug	L 1810
	or	si,si
	je	short @48@74
	?debug	L 1811
	mov	si,65535
@48@74:
	?debug	L 1812
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	push	si
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	call	far ptr _farmemset
	add	sp,10
	?debug	L 1813
	pop	si
	pop	bp
	ret	
	?debug	C E60466696C6C040C06026C67060A0A0002707446+
	?debug	C 0A0600
	?debug	E
	?debug	E
ClearMem	endp
	?debug	L 1824
	assume	cs:BMSMAKY_TEXT
LoadImage	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,18
	?debug	C E6066E756D65726F040A0600
	?debug	B
	?debug	L 1830
	mov	ax,word ptr [bp+6]
	cmp	ax,word ptr DGROUP:lastimage
	jne	short @49@74
	jmp	@49@194
@49@74:
	?debug	L 1839
	push	word ptr [bp+6]
	push	ds
	push	offset DGROUP:s@
	push	ss
	lea	ax,word ptr [bp-18]
	push	ax
	call	far ptr _sprintf
	add	sp,10
	?debug	L 1841
	push	ds
	push	offset DGROUP:s@+15
	push	ss
	lea	ax,word ptr [bp-18]
	push	ax
	call	far ptr _fopen
	add	sp,8
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	or	ax,dx
	jne	short @49@122
	?debug	L 1843
	call	far ptr _text_mode
	?debug	L 1844
	push	ds
	push	offset DGROUP:s@+18
	call	far ptr PCFatalError
	add	sp,4
@49@122:
	?debug	L 1847
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	32
	push	1
	les	bx,dword ptr DGROUP:pim
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	far ptr _fread
	add	sp,12
	?debug	L 1849
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	les	bx,dword ptr DGROUP:pim
	les	bx,dword ptr es:[bx]
	push	word ptr es:[bx+16]
	push	1
	les	bx,dword ptr DGROUP:pim
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	call	far ptr _fread
	add	sp,12
	?debug	L 1851
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	les	bx,dword ptr DGROUP:pim
	les	bx,dword ptr es:[bx]
	push	word ptr es:[bx+8]
	push	1
	les	bx,dword ptr DGROUP:pim
	push	word ptr es:[bx+10]
	push	word ptr es:[bx+8]
	call	far ptr _fread
	add	sp,12
	?debug	L 1854
	les	bx,dword ptr DGROUP:pim
	les	bx,dword ptr es:[bx]
	cmp	byte ptr es:[bx+2],1
	jbe	short @49@170
	?debug	L 1855
	les	bx,dword ptr DGROUP:pim
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	call	far ptr _tcol_loadclut
	add	sp,4
@49@170:
	?debug	L 1857
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	call	far ptr _fclose
	add	sp,4
	?debug	L 1858
	mov	word ptr DGROUP:lastimage,65535
	?debug	L 1860
@49@194:
	xor	ax,ax
	?debug	L 1863
	leave	
	ret	
	?debug	C E347000D001A02
	?debug	C E34A000400160800
	?debug	C E34B000400160800
	?debug	C E200056C6576656C040005666C6167730A000266+
	?debug	C 64020004686F6C640800056273697A6504000662+
	?debug	C 75666665724A0004637572704B0006697374656D+
	?debug	C 700A8005746F6B656E04
	?debug	C E3490014001E
	?debug	C E348000400164900
	?debug	C E6046E616D654702EEFF076368616E6E656C4802+
	?debug	C FCFF066E756D65726F040A0600
	?debug	E
	?debug	E
LoadImage	endp
	?debug	L 1881
	assume	cs:BMSMAKY_TEXT
_GetPixmap	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	push	di
	?debug	C E34C000400162100
	?debug	C E605636F6C6F72040A10000466696C6C040A0E00+
	?debug	C 0364696D1E0A0A000370706D4C0A0600
	mov	di,word ptr [bp+14]
	?debug	B
	?debug	L 1883
	mov	si,1
	?debug	L 1885
	or	di,di
	jne	short @50@74
	?debug	L 1886
	mov	di,255
	jmp	short @50@98
@50@74:
	?debug	L 1888
	xor	di,di
@50@98:
	?debug	L 1890
	cmp	word ptr [bp+16],1
	jl	short @50@146
	?debug	L 1891
	mov	si,4
@50@146:
	?debug	L 1893
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+12]
	or	ax,word ptr es:[bx+14]
	je	short @50@266
	?debug	L 1895
	mov	ax,word ptr es:[bx+2]
	cmp	ax,word ptr [bp+12]
	jne	short @50@242
	mov	ax,word ptr es:[bx]
	cmp	ax,word ptr [bp+10]
	jne	short @50@242
	?debug	L 1897
	push	di
	mov	ax,word ptr es:[bx+4]
	cwd	
	push	ax
	mov	ax,word ptr es:[bx]
	push	dx
	cwd	
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	push	ax
	mov	ax,si
	push	dx
	cwd	
	jmp	@50@338
@50@242:
	?debug	L 1902
	les	bx,dword ptr [bp+6]
	push	word ptr es:[bx+14]
	push	word ptr es:[bx+12]
	call	far ptr _free
	add	sp,4
	?debug	L 1903
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+12],0
	mov	word ptr es:[bx+14],0
@50@266:
	?debug	L 1907
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr [bp+12]
	mov	word ptr es:[bx+2],ax
	?debug	L 1908
	mov	ax,word ptr [bp+10]
	mov	word ptr es:[bx],ax
	?debug	L 1909
	mov	word ptr es:[bx+6],si
	?debug	L 1910
	mov	ax,word ptr [bp+12]
	add	ax,15
	mov	bx,16
	cwd	
	idiv	bx
	shl	ax,1
	mov	bx,word ptr [bp+6]
	mov	word ptr es:[bx+4],ax
	?debug	L 1911
	mov	word ptr es:[bx+8],0
	?debug	L 1912
	mov	word ptr es:[bx+10],15
	?debug	L 1914
	mov	ax,word ptr es:[bx+4]
	cwd	
	push	ax
	mov	ax,word ptr es:[bx+6]
	push	dx
	xor	dx,dx
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	les	bx,dword ptr [bp+6]
	push	ax
	mov	ax,word ptr es:[bx]
	push	dx
	cwd	
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	push	dx
	push	ax
	call	far ptr _farmalloc
	add	sp,4
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+12],ax
	mov	word ptr es:[bx+14],dx
	?debug	L 1915
	mov	ax,word ptr es:[bx+12]
	or	ax,word ptr es:[bx+14]
	jne	short @50@314
	?debug	L 1917
	push	ds
	push	offset DGROUP:s@+36
	call	far ptr PCFatalError
	add	sp,4
	?debug	L 1918
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+12],0
	mov	word ptr es:[bx+14],0
	?debug	L 1919
	mov	ax,1
	jmp	short @50@386
@50@314:
	?debug	L 1923
	push	di
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+4]
	cwd	
	push	ax
	mov	ax,word ptr es:[bx]
	push	dx
	cwd	
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	les	bx,dword ptr [bp+6]
	push	ax
	mov	ax,word ptr es:[bx+6]
	push	dx
	xor	dx,dx
@50@338:
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	push	dx
	push	ax
	les	bx,dword ptr [bp+6]
	push	word ptr es:[bx+14]
	push	word ptr es:[bx+12]
	push	cs
	call	near ptr ClearMem
	add	sp,10
	?debug	L 1925
	xor	ax,ax
@50@386:
	?debug	L 1926
	pop	di
	pop	si
	pop	bp
	ret	
	?debug	C E6036E627004040605636F6C6F72040A10000466+
	?debug	C 696C6C040C070364696D1E0A0A000370706D4C0A+
	?debug	C 0600
	?debug	E
	?debug	E
_GetPixmap	endp
	?debug	L 1939
	assume	cs:BMSMAKY_TEXT
_GivePixmap	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E34D000400162100
	?debug	C E60370706D4D0A0600
	?debug	B
	?debug	L 1941
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+12]
	or	ax,word ptr es:[bx+14]
	je	short @51@74
	?debug	L 1943
	push	word ptr es:[bx+14]
	push	word ptr es:[bx+12]
	call	far ptr _farfree
	add	sp,4
	?debug	L 1944
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+12],0
	mov	word ptr es:[bx+14],0
@51@74:
	?debug	L 1946
	xor	ax,ax
	?debug	L 1947
	pop	bp
	ret	
	?debug	C E60370706D4D0A0600
	?debug	E
	?debug	E
_GivePixmap	endp
	?debug	L 1960
	assume	cs:BMSMAKY_TEXT
_GetImage	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	?debug	C E34E000400162100
	?debug	C E6066E756D65726F040A0A000370706D4E0A0600
	?debug	B
	?debug	L 1970
	push	0
	push	32
	call	far ptr _farmalloc
	add	sp,4
	les	bx,dword ptr DGROUP:pim
	mov	word ptr es:[bx],ax
	mov	word ptr es:[bx+2],dx
	?debug	L 1971
	push	0
	push	48
	call	far ptr _farmalloc
	add	sp,4
	les	bx,dword ptr DGROUP:pim
	mov	word ptr es:[bx+4],ax
	mov	word ptr es:[bx+6],dx
	?debug	L 1972
	push	0
	push	55000
	call	far ptr _farmalloc
	add	sp,4
	les	bx,dword ptr DGROUP:pim
	mov	word ptr es:[bx+8],ax
	mov	word ptr es:[bx+10],dx
	?debug	L 1973
	mov	ax,word ptr es:[bx+8]
	or	ax,word ptr es:[bx+10]
	jne	short @52@74
	?debug	L 1975
	push	ds
	push	offset DGROUP:s@+61
	call	far ptr PCFatalError
	add	sp,4
@52@74:
	?debug	L 1979
	push	word ptr [bp+10]
	push	cs
	call	near ptr LoadImage
	inc	sp
	inc	sp
	mov	si,ax
	?debug	L 1980
	or	si,si
	je	short @52@122
	?debug	L 1982
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr _GivePixmap
	add	sp,4
	?debug	L 1983
	mov	ax,si
	jmp	@52@314
@52@122:
	?debug	L 1986
	?debug	L 1988
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+12]
	or	ax,word ptr es:[bx+14]
	je	short @52@194
	mov	ax,word ptr es:[bx+2]
	les	bx,dword ptr DGROUP:pim
	les	bx,dword ptr es:[bx]
	cmp	ax,word ptr es:[bx+4]
	jne	short @52@194
	les	bx,dword ptr DGROUP:pim
	les	bx,dword ptr es:[bx]
	mov	ax,word ptr es:[bx+6]
	les	bx,dword ptr [bp+6]
	cmp	ax,word ptr es:[bx]
	jne	@@207
	jmp	@52@242
@@207:
@52@194:
	?debug	L 1990
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr _GivePixmap
	add	sp,4
	?debug	L 1991
	les	bx,dword ptr DGROUP:pim
	les	bx,dword ptr es:[bx]
	mov	ax,word ptr es:[bx+4]
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+2],ax
	?debug	L 1992
	les	bx,dword ptr DGROUP:pim
	les	bx,dword ptr es:[bx]
	mov	ax,word ptr es:[bx+6]
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx],ax
	?debug	L 1993
	les	bx,dword ptr DGROUP:pim
	les	bx,dword ptr es:[bx]
	mov	al,byte ptr es:[bx+2]
	mov	ah,0
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+6],ax
	?debug	L 1994
	les	bx,dword ptr DGROUP:pim
	les	bx,dword ptr es:[bx]
	mov	ax,word ptr es:[bx+4]
	add	ax,15
	shr	ax,4
	shl	ax,1
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+4],ax
	?debug	L 1995
	mov	word ptr es:[bx+8],0
	?debug	L 1996
	mov	word ptr es:[bx+10],15
	?debug	L 1998
	mov	ax,word ptr es:[bx+4]
	cwd	
	push	ax
	mov	ax,word ptr es:[bx+6]
	push	dx
	xor	dx,dx
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	les	bx,dword ptr [bp+6]
	push	ax
	mov	ax,word ptr es:[bx]
	push	dx
	cwd	
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	push	dx
	push	ax
	call	far ptr _farmalloc
	add	sp,4
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+12],ax
	mov	word ptr es:[bx+14],dx
	?debug	L 1999
	mov	ax,word ptr es:[bx+12]
	or	ax,word ptr es:[bx+14]
	jne	short @52@242
	?debug	L 2001
	mov	word ptr es:[bx+12],0
	mov	word ptr es:[bx+14],0
	?debug	L 2002
	push	ds
	push	offset DGROUP:s@+70
	call	far ptr PCFatalError
	add	sp,4
	?debug	L 2003
	mov	ax,1
	jmp	short @52@314
@52@242:
	?debug	L 2008
	les	bx,dword ptr DGROUP:pim
	les	bx,dword ptr es:[bx]
	cmp	byte ptr es:[bx+1],23
	jne	short @52@290
	?debug	L 2009
	les	bx,dword ptr DGROUP:pim
	les	bx,dword ptr es:[bx]
	mov	al,byte ptr es:[bx+2]
	mov	ah,0
	push	ax
	les	bx,dword ptr [bp+6]
	push	word ptr es:[bx+14]
	push	word ptr es:[bx+12]
	les	bx,dword ptr DGROUP:pim
	push	word ptr es:[bx+10]
	push	word ptr es:[bx+8]
	call	far ptr _decode_image
	add	sp,10
@52@290:
	?debug	L 2014
	les	bx,dword ptr DGROUP:pim
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	far ptr _farfree
	add	sp,4
	?debug	L 2015
	les	bx,dword ptr DGROUP:pim
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	call	far ptr _farfree
	add	sp,4
	?debug	L 2016
	les	bx,dword ptr DGROUP:pim
	push	word ptr es:[bx+10]
	push	word ptr es:[bx+8]
	call	far ptr _farfree
	add	sp,4
	?debug	L 2019
	xor	ax,ax
@52@314:
	?debug	L 2020
	pop	si
	pop	bp
	ret	
	?debug	C E603657272040406066E756D65726F040A0A0003+
	?debug	C 70706D4E0A0600
	?debug	E
	?debug	E
_GetImage	endp
	?debug	L 2034
	assume	cs:BMSMAKY_TEXT
_CacheIcon	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E6066E756D65726F040A0600
	?debug	B
	?debug	L 2036
	?debug	L 2037
	pop	bp
	ret	
	?debug	C E6066E756D65726F040A0600
	?debug	E
	?debug	E
_CacheIcon	endp
	?debug	L 2045
	assume	cs:BMSMAKY_TEXT
copyquarter	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,10
	push	si
	push	di
	?debug	C E34F000400162100
	?debug	C E60771756172746572040A0A000370706D4F0A06+
	?debug	C 00
	?debug	B
	?debug	L 2052
	cmp	word ptr [bp+10],0
	jne	@@208
	jmp	@54@626
@@208:
	?debug	L 2055
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	mov	word ptr [bp-8],dx
	mov	word ptr [bp-6],ax
	?debug	L 2056
	push	0
	push	2
	mov	ax,word ptr es:[bx+2]
	cwd	
	push	dx
	push	ax
	call	far ptr F_LDIV@
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+2],ax
	?debug	L 2057
	push	0
	push	2
	mov	ax,word ptr es:[bx]
	cwd	
	push	dx
	push	ax
	call	far ptr F_LDIV@
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx],ax
	?debug	L 2059
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	mov	word ptr [bp-8],dx
	mov	word ptr [bp-6],ax
	?debug	L 2061
	mov	word ptr [bp-10],0
	jmp	@54@602
@54@74:
	?debug	L 2064
	mov	ax,word ptr [bp+10]
	cmp	ax,8192
	je	short @54@290
	jg	short @54@218
	cmp	ax,2048
	je	short @54@338
	cmp	ax,4096
	je	short @54@314
	jmp	short @54@386
@54@218:
	cmp	ax,16384
	je	short @54@266
	jmp	short @54@386
@54@266:
	?debug	L 2067
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	jmp	short @54@362
@54@290:
	?debug	L 2070
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	add	dx,5
	jmp	short @54@362
@54@314:
	?debug	L 2073
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	add	dx,400
	jmp	short @54@362
@54@338:
	?debug	L 2076
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	add	dx,405
@54@362:
	mov	word ptr [bp-4],dx
	mov	word ptr [bp-2],ax
	?debug	L 2077
@54@386:
	?debug	L 2080
	mov	ax,word ptr [bp-10]
	mov	dx,800
	imul	dx
	add	word ptr [bp-4],ax
	?debug	L 2082
	xor	di,di
	jmp	short @54@554
@54@410:
	?debug	L 2084
	xor	si,si
	jmp	short @54@482
@54@434:
	?debug	L 2085
	les	bx,dword ptr [bp-4]
	mov	al,byte ptr es:[bx]
	les	bx,dword ptr [bp-8]
	mov	byte ptr es:[bx],al
	inc	word ptr [bp-4]
	inc	word ptr [bp-8]
	?debug	L 2084
	inc	si
@54@482:
	cmp	si,5
	jl	short @54@434
	?debug	L 2087
	add	word ptr [bp-4],5
	?debug	L 2088
	add	word ptr [bp-8],5
	?debug	L 2082
	inc	di
@54@554:
	cmp	di,40
	jl	short @54@410
	?debug	L 2061
	inc	word ptr [bp-10]
@54@602:
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+6]
	cmp	ax,word ptr [bp-10]
	jle	@@209
	jmp	@54@74
@@209:
@54@626:
	?debug	L 2092
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E350000400160200
	?debug	C E351000400160200
	?debug	C E601690402F6FF01790404070178040406016450+
	?debug	C 02F8FF01735102FCFF0771756172746572040A0A+
	?debug	C 000370706D4F0A0600
	?debug	E
	?debug	E
copyquarter	endp
BMSMAKY_TEXT	ends
_BSS	segment word public 'BSS'
	db	2 dup (?)
_BSS	ends
BMSMAKY_TEXT	segment byte public 'CODE'
	?debug	L 2115
	assume	cs:BMSMAKY_TEXT
_GetIcon	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,12
	push	si
	push	di
	?debug	C E352000400162100
	?debug	C E6046D6F6465040A0C00066E756D65726F040A0A+
	?debug	C 000370706D520A0600
	mov	di,word ptr [bp+10]
	?debug	B
	?debug	L 2118
	mov	ax,di
	and	ax,2047
	mov	si,ax
	?debug	L 2122
	mov	ax,word ptr DGROUP:b@w+6
	mov	dx,3200
	imul	dx
	mov	dx,word ptr DGROUP:buffer+2
	mov	bx,word ptr DGROUP:buffer
	add	bx,ax
	mov	word ptr [bp-8],bx
	mov	word ptr [bp-6],dx
	?debug	L 2124
	inc	word ptr DGROUP:b@w+6
	mov	ax,word ptr DGROUP:b@w+6
	cmp	ax,3
	jne	short @55@74
	?debug	L 2125
	mov	word ptr DGROUP:b@w+6,0
@55@74:
	?debug	L 2127
	mov	ax,di
	and	ax,2047
	cmp	ax,512
	jge	short @55@122
	?debug	L 2128
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+6],4
	jmp	short @55@146
@55@122:
	?debug	L 2130
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+6],1
@55@146:
	?debug	L 2132
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+4],10
	?debug	L 2133
	mov	word ptr es:[bx+10],15
	?debug	L 2134
	mov	word ptr es:[bx+8],0
	?debug	L 2136
	cmp	si,512
	jge	short @55@194
	?debug	L 2138
	mov	ax,si
	cwd	
	push	ax
	push	dx
	xor	dx,dx
	mov	ax,3200
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	push	ax
	mov	ax,word ptr DGROUP:_xmsicons+4
	push	dx
	cwd	
	pop	bx
	pop	cx
	add	ax,cx
	adc	dx,bx
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	?debug	L 2139
	push	3200
	push	word ptr [bp-6]
	push	word ptr [bp-8]
	push	0
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr DGROUP:xmshandle
	call	far ptr _XMSCopy
	add	sp,14
	?debug	L 2140
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+6],4
	?debug	L 2141
	jmp	short @55@218
@55@194:
	?debug	B
	?debug	L 2145
	mov	ax,word ptr DGROUP:_xmsicons+4
	cwd	
	add	ax,0
	adc	dx,25
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	?debug	L 2146
	mov	ax,si
	add	ax,65024
	cwd	
	push	ax
	push	dx
	xor	dx,dx
	mov	ax,800
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	mov	word ptr [bp-12],ax
	mov	word ptr [bp-10],dx
	?debug	L 2148
	mov	ax,word ptr [bp-10]
	mov	dx,word ptr [bp-12]
	add	word ptr [bp-4],dx
	adc	word ptr [bp-2],ax
	?debug	L 2149
	push	800
	push	word ptr [bp-6]
	push	word ptr [bp-8]
	push	0
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr DGROUP:xmshandle
	call	far ptr _XMSCopy
	add	sp,14
	?debug	L 2150
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+6],1
@55@218:
	?debug	C E6026F6F0602F4FF
	?debug	E
	?debug	L 2153
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+2],80
	?debug	L 2154
	mov	word ptr es:[bx],80
	?debug	L 2155
	mov	word ptr es:[bx+4],10
	?debug	L 2156
	mov	word ptr es:[bx+10],15
	?debug	L 2157
	mov	word ptr es:[bx+8],0
	?debug	L 2158
	mov	ax,word ptr [bp-6]
	mov	dx,word ptr [bp-8]
	mov	word ptr es:[bx+12],dx
	mov	word ptr es:[bx+14],ax
	?debug	L 2160
	mov	ax,di
	and	ax,63488
	push	ax
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr copyquarter
	add	sp,6
	?debug	L 2162
	xor	ax,ax
	?debug	L 2163
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E353000400160200
	?debug	C E604706275665302F8FF066E756D627566040000+
	?debug	C 030600026E6F040406066F66667365740602FCFF+
	?debug	C 046D6F6465040A0C00066E756D65726F040C0703+
	?debug	C 70706D520A0600
	?debug	E
	?debug	E
_GetIcon	endp
	?debug	L 2167
	assume	cs:BMSMAKY_TEXT
__GetIcon	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,4
	?debug	C E354000400162100
	?debug	C E6046D6F6465040A0C00066E756D65726F040A0A+
	?debug	C 000370706D540A0600
	?debug	B
	?debug	L 2172
	push	0
	push	2
	mov	ax,word ptr [bp+10]
	cwd	
	push	ax
	push	dx
	xor	dx,dx
	mov	ax,6400
	pop	cx
	pop	bx
	call	far ptr F_LXMUL@
	push	dx
	push	ax
	call	far ptr F_LDIV@
	push	ax
	mov	ax,word ptr DGROUP:_xmsicons+4
	push	dx
	cwd	
	pop	bx
	pop	cx
	add	ax,cx
	adc	dx,bx
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	?debug	L 2174
	push	3200
	push	word ptr DGROUP:buffer+2
	push	word ptr DGROUP:buffer
	push	0
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr DGROUP:xmshandle
	call	far ptr _XMSCopy
	add	sp,14
	?debug	L 2176
	les	bx,dword ptr [bp+6]
	mov	word ptr es:[bx+2],80
	?debug	L 2177
	mov	word ptr es:[bx],80
	?debug	L 2178
	mov	word ptr es:[bx+6],4
	?debug	L 2179
	mov	word ptr es:[bx+4],10
	?debug	L 2180
	mov	word ptr es:[bx+10],15
	?debug	L 2181
	mov	word ptr es:[bx+8],0
	?debug	L 2182
	mov	ax,word ptr DGROUP:buffer+2
	mov	dx,word ptr DGROUP:buffer
	mov	word ptr es:[bx+12],dx
	mov	word ptr es:[bx+14],ax
	?debug	L 2183
	xor	ax,ax
	?debug	L 2184
	leave	
	ret	
	?debug	C E6066F66667365740602FCFF046D6F6465040A0C+
	?debug	C 00066E756D65726F040A0A000370706D540A0600
	?debug	E
	?debug	E
__GetIcon	endp
	?debug	L 2212
	assume	cs:BMSMAKY_TEXT
_xmsload	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,62
	push	si
	push	di
	?debug	C E355000400160200
	?debug	C E20002647804000264790480066F666673657404
	?debug	C E35707786D7369636F6E06001E
	?debug	C E356000400165700
	?debug	C E607786D7369636F6E560A0A00046E616D65550A+
	?debug	C 0600
	?debug	B
	?debug	L 2214
	mov	di,65535
	?debug	L 2215
	mov	word ptr [bp-8],0
	mov	word ptr [bp-6],0
	?debug	L 2216
	mov	word ptr [bp-12],0
	mov	word ptr [bp-10],0
	?debug	L 2221
	push	0
	push	32000
	call	far ptr _farmalloc
	add	sp,4
	mov	word ptr [bp-12],ax
	mov	word ptr [bp-10],dx
	?debug	L 2223
	mov	ax,word ptr [bp-12]
	or	ax,word ptr [bp-10]
	jne	short @57@74
	?debug	L 2224
	mov	ax,1
	jmp	@57@602
@57@74:
	?debug	L 2226
	push	ds
	push	offset DGROUP:s@+94
	call	far ptr _printf
	add	sp,4
	?debug	L 2228
	push	32769
	push	ds
	push	offset DGROUP:s@+120
	call	far ptr _open
	add	sp,6
	mov	di,ax
	?debug	L 2229
	cmp	di,65535
	jne	short @57@122
	?debug	L 2231
	push	ds
	push	offset DGROUP:s@+133
	call	far ptr _printf
	add	sp,4
	?debug	L 2232
	mov	ax,1
	jmp	@57@602
@57@122:
	?debug	L 2234
	push	46
	push	ss
	lea	ax,word ptr [bp-62]
	push	ax
	push	di
	call	far ptr _read
	add	sp,8
	?debug	L 2236
	xor	si,si
	jmp	short @57@194
@57@146:
	?debug	L 2238
	mov	bx,si
	shl	bx,2
	lea	ax,word ptr [bp-56]
	add	bx,ax
	mov	ax,word ptr ss:[bx]
	push	ax
	mov	ax,si
	mov	dx,6
	imul	dx
	mov	bx,ax
	pop	ax
	mov	word ptr DGROUP:_xmsicons[bx+4],ax
	?debug	L 2236
	inc	si
@57@194:
	cmp	si,word ptr [bp-58]
	jl	short @57@146
	?debug	L 2241
	push	di
	call	far ptr _filelength
	inc	sp
	inc	sp
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	?debug	L 2243
	push	0
	push	1024
	mov	ax,word ptr [bp-2]
	mov	dx,word ptr [bp-4]
	add	dx,1024
	adc	ax,0
	push	ax
	push	dx
	call	far ptr F_LDIV@
	push	ax
	call	far ptr _XMSGetMem
	inc	sp
	inc	sp
	mov	word ptr DGROUP:xmshandle,ax
	?debug	L 2245
	cmp	byte ptr DGROUP:_XMSErr,0
	je	@@210
	jmp	@57@386
@@210:
	?debug	B
	?debug	L 2247
	mov	word ptr [bp-14],0
	?debug	L 2248
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	ds
	push	offset DGROUP:s@+163
	call	far ptr _printf
	add	sp,8
	?debug	L 2249
	push	ds
	push	offset DGROUP:s@+199
	call	far ptr _printf
	add	sp,4
@57@266:
	?debug	B
	?debug	L 2254
	push	32000
	push	word ptr [bp-10]
	push	word ptr [bp-12]
	push	di
	call	far ptr _read
	add	sp,8
	mov	word ptr [bp-16],ax
	?debug	L 2255
	mov	ax,word ptr [bp-14]
	inc	word ptr [bp-14]
	test	ax,1
	je	short @57@314
	?debug	L 2256
	push	ds
	push	offset DGROUP:s@+217
	call	far ptr _printf
	add	sp,4
@57@314:
	?debug	L 2258
	cmp	word ptr [bp-16],0
	je	short @57@482
	?debug	L 2261
	push	word ptr [bp-16]
	push	word ptr [bp-6]
	push	word ptr [bp-8]
	push	word ptr DGROUP:xmshandle
	push	word ptr [bp-10]
	push	word ptr [bp-12]
	push	0
	call	far ptr _XMSCopy
	add	sp,14
	?debug	L 2264
	add	word ptr [bp-8],32000
	adc	word ptr [bp-6],0
	?debug	C E6096279746573726561640402F0FF
	?debug	E
	?debug	L 2266
	jmp	short @57@266
@57@386:
	?debug	C E605636F756E740402F2FF
	?debug	E
	?debug	L 2270
	cmp	byte ptr DGROUP:_XMSErr,160
	jne	short @57@434
	?debug	L 2271
	push	ds
	push	offset DGROUP:s@+219
	call	far ptr _printf
	add	sp,4
	jmp	short @57@458
@57@434:
	?debug	L 2273
	mov	al,byte ptr DGROUP:_XMSErr
	mov	ah,0
	push	ax
	push	ds
	push	offset DGROUP:s@+280
	call	far ptr _printf
	add	sp,6
@57@458:
	?debug	L 2275
	mov	ax,1
	jmp	short @57@602
@57@482:
	?debug	L 2279
	cmp	di,65535
	je	short @57@530
	?debug	L 2280
	push	di
	call	far ptr _close
	inc	sp
	inc	sp
@57@530:
	?debug	L 2282
	push	ds
	push	offset DGROUP:s@+298
	call	far ptr _printf
	add	sp,4
	?debug	L 2284
	mov	ax,word ptr [bp-12]
	or	ax,word ptr [bp-10]
	je	short @57@578
	?debug	L 2285
	push	word ptr [bp-10]
	push	word ptr [bp-12]
	call	far ptr _farfree
	add	sp,4
@57@578:
	?debug	L 2287
	xor	ax,ax
@57@602:
	?debug	L 2288
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E3590028001A06
	?debug	C E200056D616769630600076E6266696C65730480+
	?debug	C 066F666673657459
	?debug	C E35809696366696C656469722E001E
	?debug	C E35A000400160200
	?debug	C E601690404060766696C656469725802C2FF0464+
	?debug	C 6174615A02F4FF066F66667365740602F8FF066C+
	?debug	C 656E6774680602FCFF02696E04040707786D7369+
	?debug	C 636F6E560A0A00046E616D65550A0600
	?debug	E
	?debug	E
_xmsload	endp
	?debug	L 2303
	assume	cs:BMSMAKY_TEXT
LoadIcon	proc	far
	?debug	B
	push	si
	?debug	B
	?debug	L 2308
	call	far ptr _XMSInit
	mov	ah,0
	or	ax,ax
	jne	short @58@74
	?debug	L 2310
	push	ds
	push	offset DGROUP:s@+301
	call	far ptr _printf
	add	sp,4
	?debug	L 2311
	mov	ax,1
	jmp	short @58@146
@58@74:
	?debug	L 2314
	push	ds
	push	offset DGROUP:s@+312
	call	far ptr _printf
	add	sp,4
	?debug	L 2316
	push	ds
	push	offset DGROUP:_icons
	push	ds
	push	offset DGROUP:s@+339
	push	cs
	call	near ptr _xmsload
	add	sp,8
	mov	si,ax
	?debug	L 2317
	or	si,si
	je	short @58@122
	?debug	L 2318
	mov	ax,1
	jmp	short @58@146
@58@122:
	?debug	L 2320
	push	0
	push	9600
	call	far ptr _farmalloc
	add	sp,4
	mov	word ptr DGROUP:buffer,ax
	mov	word ptr DGROUP:buffer+2,dx
	?debug	L 2321
	xor	ax,ax
@58@146:
	?debug	L 2322
	pop	si
	ret	
	?debug	C E60172040406
	?debug	E
	?debug	E
LoadIcon	endp
	?debug	L 2325
	assume	cs:BMSMAKY_TEXT
UnloadIcon	proc	far
	?debug	B
	?debug	B
	?debug	L 2327
	push	ds
	push	offset DGROUP:s@+345
	call	far ptr _printf
	add	sp,4
	?debug	L 2328
	push	word ptr DGROUP:xmshandle
	call	far ptr _XMSFreeMem
	inc	sp
	inc	sp
	?debug	L 2329
	ret	
	?debug	E
	?debug	E
UnloadIcon	endp
	?debug	L 2342
	assume	cs:BMSMAKY_TEXT
AfMenu	proc	far
	?debug	B
	?debug	B
	?debug	L 2345
	ret	
	?debug	E
	?debug	E
AfMenu	endp
	?debug	L 2357
	assume	cs:BMSMAKY_TEXT
_BlackScreen	proc	far
	?debug	B
	?debug	B
	?debug	L 2360
	push	cs
	call	near ptr _HideMouseInt
	?debug	L 2361
	call	far ptr _zap_screen
	?debug	L 2362
	push	cs
	call	near ptr _ShowMouseInt
	?debug	L 2363
	ret	
	?debug	E
	?debug	E
_BlackScreen	endp
BMSMAKY_TEXT	ends
_DATA	segment word public 'DATA'
	db	66
	db	76
	db	85
	db	80
	db	73
	db	88
	db	65
	db	46
	db	68
	db	65
	db	84
	db	0
_DATA	ends
BMSMAKY_TEXT	segment byte public 'CODE'
	?debug	L 2455
	assume	cs:BMSMAKY_TEXT
_FileRead	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,14
	push	si
	push	di
	?debug	C E35B000400160100
	?debug	C E60466696C65020A1000026E62040A0E0003706F+
	?debug	C 73060A0A000570646174615B0A0600
	?debug	B
	push	ss
	lea	ax,word ptr [bp-14]
	push	ax
	push	ds
	push	offset DGROUP:d@+55
	mov	cx,12
	call	far ptr F_SCOPY@
	?debug	L 2462
	mov	al,byte ptr [bp+16]
	mov	byte ptr [bp-8],al
	?debug	L 2463
	call	far ptr _restore_clock
	?debug	L 2464
	push	32769
	push	ss
	lea	ax,word ptr [bp-14]
	push	ax
	call	far ptr __open
	add	sp,6
	mov	si,ax
	?debug	L 2465
	cmp	si,65535
	jne	short @62@74
	mov	ax,word ptr DGROUP:_errno
	jmp	short @62@218
@62@74:
	?debug	L 2467
	push	0
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	push	si
	call	far ptr _lseek
	add	sp,8
	cmp	dx,65535
	jne	short @62@146
	cmp	ax,65535
	jne	short @62@146
	jmp	short @62@170
@62@146:
	?debug	L 2473
	push	word ptr [bp+14]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	si
	call	far ptr __read
	add	sp,8
	mov	word ptr [bp-2],ax
	cmp	ax,65535
	jne	short @62@194
@62@170:
	?debug	L 2475
	mov	di,word ptr DGROUP:_errno
	?debug	L 2476
@62@194:
	?debug	L 2480
	call	far ptr _restore_clock
	?debug	L 2481
	push	si
	call	far ptr __close
	inc	sp
	inc	sp
	?debug	L 2482
	xor	ax,ax
@62@218:
	?debug	L 2483
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E35C000C001A02
	?debug	C E6036572720404070866696C656E616D655C02F2+
	?debug	C FF076368616E6E656C04040601720402FEFF0466+
	?debug	C 696C65020A1000026E62040A0E0003706F73060A+
	?debug	C 0A000570646174615B0A0600
	?debug	E
	?debug	E
_FileRead	endp
BMSMAKY_TEXT	ends
_DATA	segment word public 'DATA'
	db	66
	db	76
	db	85
	db	80
	db	73
	db	88
	db	65
	db	46
	db	68
	db	65
	db	84
	db	0
_DATA	ends
BMSMAKY_TEXT	segment byte public 'CODE'
	?debug	L 2495
	assume	cs:BMSMAKY_TEXT
_FileWrite	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,18
	push	si
	push	di
	?debug	C E35D000400160100
	?debug	C E60466696C65020A1000026E62040A0E0003706F+
	?debug	C 73060A0A000570646174615D0A0600
	?debug	B
	push	ss
	lea	ax,word ptr [bp-18]
	push	ax
	push	ds
	push	offset DGROUP:d@+67
	mov	cx,12
	call	far ptr F_SCOPY@
	?debug	L 2502
	mov	al,byte ptr [bp+16]
	mov	byte ptr [bp-12],al
	?debug	L 2503
	call	far ptr _restore_clock
	?debug	L 2504
	push	32770
	push	ss
	lea	ax,word ptr [bp-18]
	push	ax
	call	far ptr __open
	add	sp,6
	mov	si,ax
	?debug	L 2505
	cmp	si,65535
	jne	short @63@98
	?debug	L 2507
	push	0
	push	ss
	lea	ax,word ptr [bp-18]
	push	ax
	call	far ptr __creat
	add	sp,6
	mov	si,ax
	?debug	L 2508
	cmp	si,65535
	jne	short @63@98
	?debug	L 2509
	mov	ax,word ptr DGROUP:_errno
	jmp	short @63@266
@63@98:
	?debug	L 2512
	push	0
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	push	si
	call	far ptr _lseek
	add	sp,8
	cmp	dx,65535
	jne	short @63@170
	cmp	ax,65535
	jne	short @63@170
	jmp	short @63@218
@63@170:
	?debug	B
	?debug	L 2519
	push	si
	call	far ptr _tell
	inc	sp
	inc	sp
	mov	word ptr [bp-6],ax
	mov	word ptr [bp-4],dx
	?debug	C E604746573740602FAFF
	?debug	E
	?debug	L 2522
	push	word ptr [bp+14]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	si
	call	far ptr __write
	add	sp,8
	mov	word ptr [bp-2],ax
	cmp	ax,65535
	jne	short @63@242
@63@218:
	?debug	L 2524
	mov	di,word ptr DGROUP:_errno
	?debug	L 2525
@63@242:
	?debug	L 2529
	call	far ptr _restore_clock
	?debug	L 2530
	push	si
	call	far ptr __close
	inc	sp
	inc	sp
	?debug	L 2531
	xor	ax,ax
@63@266:
	?debug	L 2532
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E35E000C001A02
	?debug	C E6036572720404070866696C656E616D655E02EE+
	?debug	C FF076368616E6E656C04040601720402FEFF0466+
	?debug	C 696C65020A1000026E62040A0E0003706F73060A+
	?debug	C 0A000570646174615D0A0600
	?debug	E
	?debug	E
_FileWrite	endp
BMSMAKY_TEXT	ends
_DATA	segment word public 'DATA'
	db	66
	db	76
	db	85
	db	80
	db	73
	db	88
	db	65
	db	46
	db	68
	db	65
	db	84
	db	0
_DATA	ends
BMSMAKY_TEXT	segment byte public 'CODE'
	?debug	L 2544
	assume	cs:BMSMAKY_TEXT
_FileGetLength	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,20
	?debug	C E60466696C65020A0600
	?debug	B
	push	ss
	lea	ax,word ptr [bp-20]
	push	ax
	push	ds
	push	offset DGROUP:d@+79
	mov	cx,12
	call	far ptr F_SCOPY@
	?debug	L 2550
	mov	al,byte ptr [bp+6]
	mov	byte ptr [bp-14],al
	?debug	L 2551
	push	ds
	push	offset DGROUP:s@+358
	push	ss
	lea	ax,word ptr [bp-20]
	push	ax
	call	far ptr _fopen
	add	sp,8
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	?debug	L 2552
	mov	ax,word ptr [bp-4]
	or	ax,word ptr [bp-2]
	jne	short @64@74
	xor	dx,dx
	xor	ax,ax
	jmp	short @64@98
@64@74:
	?debug	L 2554
	push	2
	push	0
	push	0
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	call	far ptr _fseek
	add	sp,10
	?debug	L 2555
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	call	far ptr _ftell
	add	sp,4
	mov	word ptr [bp-8],ax
	mov	word ptr [bp-6],dx
	?debug	L 2557
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	call	far ptr _fclose
	add	sp,4
	?debug	L 2558
	mov	dx,word ptr [bp-6]
	mov	ax,word ptr [bp-8]
@64@98:
	?debug	L 2559
	leave	
	ret	
	?debug	C E35F000C001A02
	?debug	C E360000400164900
	?debug	C E6026C670602F8FF0866696C656E616D655F02EC+
	?debug	C FF076368616E6E656C6002FCFF0466696C65020A+
	?debug	C 0600
	?debug	E
	?debug	E
_FileGetLength	endp
BMSMAKY_TEXT	ends
_DATA	segment word public 'DATA'
	db	66
	db	76
	db	85
	db	80
	db	73
	db	88
	db	65
	db	46
	db	68
	db	65
	db	84
	db	0
_DATA	ends
BMSMAKY_TEXT	segment byte public 'CODE'
	?debug	L 2571
	assume	cs:BMSMAKY_TEXT
_FileDelete	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,12
	?debug	C E60466696C65020A0600
	?debug	B
	push	ss
	lea	ax,word ptr [bp-12]
	push	ax
	push	ds
	push	offset DGROUP:d@+91
	mov	cx,12
	call	far ptr F_SCOPY@
	?debug	L 2575
	mov	al,byte ptr [bp+6]
	mov	byte ptr [bp-6],al
	?debug	L 2576
	push	ss
	lea	ax,word ptr [bp-12]
	push	ax
	call	far ptr _unlink
	add	sp,4
	?debug	L 2577
	leave	
	ret	
	?debug	C E361000C001A02
	?debug	C E60866696C656E616D656102F4FF0466696C6502+
	?debug	C 0A0600
	?debug	E
	?debug	E
_FileDelete	endp
BMSMAKY_TEXT	ends
_DATA	segment word public 'DATA'
	db	66
	db	76
	db	85
	db	80
	db	73
	db	88
	db	65
	db	46
	db	68
	db	65
	db	84
	db	0
	db	66
	db	76
	db	85
	db	80
	db	73
	db	88
	db	65
	db	46
	db	68
	db	65
	db	84
	db	0
_DATA	ends
BMSMAKY_TEXT	segment byte public 'CODE'
	?debug	L 2589
	assume	cs:BMSMAKY_TEXT
_FileRename	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E6076E657766696C65020A0800076F6C6466696C+
	?debug	C 65020A0600
	?debug	B
	?debug	L 2594
	mov	al,byte ptr [bp+6]
	mov	byte ptr DGROUP:d@+103+6,al
	?debug	L 2595
	mov	al,byte ptr [bp+8]
	mov	byte ptr DGROUP:d@+115+6,al
	?debug	L 2596
	push	ds
	push	offset DGROUP:d@+115
	push	ds
	push	offset DGROUP:d@+103
	call	far ptr _rename
	add	sp,8
	?debug	L 2597
	pop	bp
	ret	
	?debug	C E362000C001A02
	?debug	C E363000C001A02
	?debug	C E60B6E657766696C656E616D656200000273000B+
	?debug	C 6F6C6466696C656E616D65630000026700076E65+
	?debug	C 7766696C65020A0800076F6C6466696C65020A06+
	?debug	C 00
	?debug	E
	?debug	E
_FileRename	endp
BMSMAKY_TEXT	ends
_DATA	segment word public 'DATA'
fatalerrptr	label	dword
	db	0
	db	0
	db	0
	db	0
_DATA	ends
BMSMAKY_TEXT	segment byte public 'CODE'
	?debug	L 2611
	assume	cs:BMSMAKY_TEXT
PCFatalError	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E364000400160200
	?debug	C E60474657874640A0600
	?debug	B
	?debug	L 2613
	mov	ax,word ptr [bp+8]
	mov	dx,word ptr [bp+6]
	mov	word ptr DGROUP:fatalerrptr,dx
	mov	word ptr DGROUP:fatalerrptr+2,ax
	?debug	L 2614
	call	far ptr _CloseMachine
	?debug	L 2615
	push	0
	call	far ptr _exit
	inc	sp
	inc	sp
	?debug	L 2616
	pop	bp
	ret	
	?debug	C E60474657874640A0600
	?debug	E
	?debug	E
PCFatalError	endp
	?debug	L 2628
	assume	cs:BMSMAKY_TEXT
_FatalError	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,30
	?debug	C E603657272040A0600
	?debug	B
	?debug	L 2631
	push	ds
	push	offset DGROUP:s@+360
	push	ss
	lea	ax,word ptr [bp-30]
	push	ax
	call	far ptr _sprintf
	add	sp,8
	?debug	L 2632
	lea	ax,word ptr [bp-30]
	mov	word ptr DGROUP:fatalerrptr,ax
	mov	word ptr DGROUP:fatalerrptr+2,ss
	?debug	L 2633
	call	far ptr _CloseMachine
	?debug	L 2634
	push	0
	call	far ptr _exit
	inc	sp
	inc	sp
	?debug	L 2635
	leave	
	ret	
	?debug	C E365001E001A02
	?debug	C E604746578746502E2FF03657272040A0600
	?debug	E
	?debug	E
_FatalError	endp
	?debug	L 2647
	assume	cs:BMSMAKY_TEXT
_IfFileExist	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,4
	?debug	C E366000400160200
	?debug	C E6097066696C656E616D65660A0600
	?debug	B
	?debug	L 2651
	push	ds
	push	offset DGROUP:s@+377
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	call	far ptr _fopen
	add	sp,8
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	?debug	L 2652
	mov	ax,word ptr [bp-4]
	or	ax,word ptr [bp-2]
	jne	short @69@74
	xor	ax,ax
	jmp	short @69@98
@69@74:
	?debug	L 2654
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	call	far ptr _fclose
	add	sp,4
	?debug	L 2655
	mov	ax,1
@69@98:
	?debug	L 2656
	leave	
	ret	
	?debug	C E367000400164900
	?debug	C E6076368616E6E656C6702FCFF097066696C656E+
	?debug	C 616D65660A0600
	?debug	E
	?debug	E
_IfFileExist	endp
	?debug	L 2668
	assume	cs:BMSMAKY_TEXT
_CheckMem	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E605666C6167730C0A0600
	?debug	B
	?debug	L 2670
	mov	ax,1
	?debug	L 2671
	pop	bp
	ret	
	?debug	C E605666C6167730C0A0600
	?debug	E
	?debug	E
_CheckMem	endp
	?debug	L 2686
	assume	cs:BMSMAKY_TEXT
_DboxMem	proc	far
	?debug	B
	?debug	B
	?debug	L 2688
	mov	ax,1
	?debug	L 2689
	ret	
	?debug	E
	?debug	E
_DboxMem	endp
	?debug	L 2700
	assume	cs:BMSMAKY_TEXT
FatalLoad	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,4
	?debug	C E368000400160200
	?debug	C E603657272040A0A00046E616D65680A0600
	?debug	B
	?debug	L 2704
	push	word ptr [bp+10]
	call	far ptr _strerror
	inc	sp
	inc	sp
	mov	word ptr [bp-4],ax
	mov	word ptr [bp-2],dx
	?debug	L 2705
	cmp	word ptr [bp-4],0
	jne	short @72@74
	?debug	L 2707
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	word ptr [bp+10]
	push	ds
	push	offset DGROUP:s@+379
	push	ds
	push	offset DGROUP:__streams+40
	call	far ptr _fprintf
	add	sp,14
	?debug	L 2708
	jmp	short @72@98
@72@74:
	?debug	L 2711
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	ds
	push	offset DGROUP:s@+412
	push	ds
	push	offset DGROUP:__streams+40
	call	far ptr _fprintf
	add	sp,16
@72@98:
	?debug	L 2713
	mov	ax,word ptr DGROUP:__streams
	dec	ax
	mov	word ptr DGROUP:__streams,ax
	or	ax,ax
	jl	short @72@146
	les	bx,dword ptr DGROUP:__streams+12
	inc	word ptr DGROUP:__streams+12
	mov	al,byte ptr es:[bx]
	mov	ah,0
	jmp	short @72@170
@72@146:
	push	ds
	push	offset DGROUP:__streams
	call	far ptr __fgetc
	add	sp,4
@72@170:
	?debug	L 2715
	call	far ptr _CloseMachine
	?debug	L 2716
	push	0
	call	far ptr _exit
	inc	sp
	inc	sp
	?debug	L 2717
	leave	
	ret	
	?debug	C E369000400160200
	?debug	C E6096572726F726E616D656902FCFF0365727204+
	?debug	C 0A0A00046E616D65680A0600
	?debug	E
	?debug	E
FatalLoad	endp
	?debug	L 2734
	assume	cs:BMSMAKY_TEXT
_lineegal	proc	far
	?debug	B
	?debug	B
	?debug	L 2736
	push	ds
	push	offset DGROUP:s@+438
	call	far ptr _printf
	add	sp,4
	?debug	L 2737
	ret	
	?debug	E
	?debug	E
_lineegal	endp
	?debug	L 2738
	assume	cs:BMSMAKY_TEXT
_OpenMachine	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,4
	push	si
	push	di
	?debug	B
	?debug	L 2748
	mov	word ptr [bp-2],0
	mov	word ptr [bp-4],0
	?debug	L 2751
	call	far ptr _clrscr
	?debug	L 2752
	push	1
	push	1
	call	far ptr _gotoxy
	add	sp,4
	?debug	L 2753
	push	14
	call	far ptr _textcolor
	inc	sp
	inc	sp
	?debug	L 2754
	push	6
	call	far ptr _textbackground
	inc	sp
	inc	sp
	?debug	L 2756
	push	ds
	push	offset DGROUP:s@+497
	call	far ptr _cprintf
	add	sp,4
	?debug	L 2758
	push	ss
	lea	ax,word ptr [bp-4]
	push	ax
	push	ss
	lea	ax,word ptr [bp-2]
	push	ax
	call	far ptr _querry_video
	add	sp,8
	?debug	L 2767
	call	far ptr _farcoreleft
	cmp	dx,4
	ja	short @74@122
	jb	short @74@98
	cmp	ax,44856
	jae	short @74@122
@74@98:
	?debug	B
	?debug	L 2770
	push	7
	push	21248
	push	2
	push	42992
	call	far ptr _errmem
	add	sp,8
@74@122:
	?debug	E
	?debug	L 2775
	call	far ptr _vfy_mouse
	cmp	ax,65535
	jne	short @74@170
	?debug	L 2777
	push	ds
	push	offset DGROUP:s@+579
	call	far ptr _printf
	add	sp,4
	?debug	L 2778
	push	0
	call	far ptr _exit
	inc	sp
	inc	sp
@74@170:
	?debug	L 2780
	push	ds
	push	offset DGROUP:s@+596
	call	far ptr _printf
	add	sp,4
	?debug	L 2783
	call	far ptr _GetDemo
	or	al,al
	je	short @74@218
	?debug	L 2785
	push	cs
	call	near ptr _lineegal
	?debug	L 2786
	push	ds
	push	offset DGROUP:s@+617
	call	far ptr _printf
	add	sp,4
	?debug	L 2787
	push	cs
	call	near ptr _lineegal
@74@218:
	?debug	L 2792
	push	cs
	call	near ptr LoadIcon
	mov	di,ax
	?debug	L 2793
	or	di,di
	je	short @74@266
	?debug	L 2795
	push	0
	call	far ptr _exit
	inc	sp
	inc	sp
@74@266:
	?debug	B
	?debug	L 2801
	call	far ptr _restore_clock
	?debug	L 2802
	push	32769
	push	ds
	push	offset DGROUP:s@+646
	call	far ptr __open
	add	sp,6
	mov	si,ax
	?debug	L 2803
	cmp	si,65535
	je	short @74@314
	?debug	L 2805
	push	28
	push	ds
	push	offset DGROUP:_blpinfo
	push	si
	call	far ptr __read
	add	sp,8
	?debug	L 2806
	push	si
	call	far ptr __close
	inc	sp
	inc	sp
@74@314:
	?debug	C E60166040406
	?debug	E
	?debug	L 2810
	push	ds
	push	offset DGROUP:s@+659
	call	far ptr _printf
	add	sp,4
	?debug	L 2813
	call	far ptr _init_sound
	neg	ax
	sbb	ax,ax
	inc	ax
	mov	word ptr DGROUP:have_sbcard,ax
	?debug	L 2816
	mov	word ptr DGROUP:origine+2,0
	?debug	L 2817
	mov	word ptr DGROUP:origine,0
	?debug	L 2819
	push	0
	push	0
	push	cs
	call	near ptr _StartRandom
	add	sp,4
	?debug	L 2820
	push	1
	push	1
	push	cs
	call	near ptr _StartRandom
	add	sp,4
	?debug	L 2822
	mov	word ptr DGROUP:keystatus,0
	?debug	L 2824
	push	cs
	call	near ptr AfMenu
	?debug	L 2832
	call	far ptr _trap_interrupts
	?debug	L 2834
	call	far ptr _FMMusicInit
	?debug	L 2836
	push	cs
	call	near ptr _OpenTime
	?debug	L 2837
	push	40
	push	cs
	call	near ptr _CloseTime
	inc	sp
	inc	sp
	?debug	L 2839
	call	far ptr _save_video_mode
	?debug	L 2840
	call	far ptr _graphic_mode
	mov	di,ax
	?debug	L 2841
	or	di,di
	je	short @74@362
	?debug	L 2842
	push	ds
	push	offset DGROUP:s@+685
	push	ds
	push	offset DGROUP:__streams+40
	call	far ptr _fprintf
	add	sp,8
	?debug	L 2843
	call	far ptr _CloseMachine
	?debug	L 2844
	push	1
	call	far ptr _exit
	inc	sp
	inc	sp
@74@362:
	?debug	L 2846
	push	cs
	call	near ptr _initmouse
	mov	word ptr DGROUP:havemouse,ax
	?debug	L 2848
	mov	word ptr DGROUP:lxwdo,640
	?debug	L 2849
	mov	word ptr DGROUP:lywdo,340
	?debug	L 2857
	push	cs
	call	near ptr _ShowMouseInt
	?debug	L 2859
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E610617661696C61626C655F766D6F6465730402+
	?debug	C FCFF0C6D6F6E69746F725F747970650402FEFF03+
	?debug	C 657272040407
	?debug	E
	?debug	E
_OpenMachine	endp
	?debug	L 2871
	assume	cs:BMSMAKY_TEXT
_CloseMachine	proc	far
	?debug	B
	?debug	B
	?debug	L 2873
	push	0
	call	far ptr _playsoundloop
	inc	sp
	inc	sp
	?debug	L 2875
	call	far ptr _FMMusicDeinit
	?debug	L 2876
	call	far ptr _end_sound
	?debug	L 2877
	call	far ptr _uninit_sound
	?debug	L 2879
	call	far ptr _release_interrupts
	?debug	L 2880
	call	far ptr _toneoff
	?debug	L 2881
	call	far ptr _restore_video_mode
	?debug	L 2882
	call	far ptr _restore_clock
	?debug	L 2884
	mov	ax,word ptr DGROUP:fatalerrptr
	or	ax,word ptr DGROUP:fatalerrptr+2
	je	short @75@50
	?debug	L 2886
	push	word ptr DGROUP:fatalerrptr+2
	push	word ptr DGROUP:fatalerrptr
	call	far ptr _printf
	add	sp,4
	?debug	L 2887
	call	far ptr _getch
@75@50:
	?debug	L 2890
	push	cs
	call	near ptr UnloadIcon
	?debug	L 2891
	ret	
	?debug	E
	?debug	E
_CloseMachine	endp
	?debug	L 2904
	assume	cs:BMSMAKY_TEXT
_MachinePartieLg	proc	far
	?debug	B
	?debug	B
	?debug	L 2906
	xor	dx,dx
	mov	ax,40
	?debug	L 2907
	ret	
	?debug	E
	?debug	E
_MachinePartieLg	endp
	?debug	L 2917
	assume	cs:BMSMAKY_TEXT
_MachinePartieWrite	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	?debug	C E60466696C65020A0A0003706F73060A0600
	?debug	B
	?debug	L 2921
	mov	al,byte ptr [bp+10]
	push	ax
	push	40
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	ds
	push	offset DGROUP:nextrand
	push	cs
	call	near ptr _FileWrite
	add	sp,12
	mov	si,ax
	?debug	L 2922
	?debug	L 2923
	pop	si
	pop	bp
	ret	
	?debug	C E6036572720404060466696C65020A0A0003706F+
	?debug	C 73060A0600
	?debug	E
	?debug	E
_MachinePartieWrite	endp
	?debug	L 2933
	assume	cs:BMSMAKY_TEXT
_MachinePartieRead	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	?debug	C E60466696C65020A0A0003706F73060A0600
	?debug	B
	?debug	L 2937
	mov	al,byte ptr [bp+10]
	push	ax
	push	40
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	ds
	push	offset DGROUP:nextrand
	push	cs
	call	near ptr _FileRead
	add	sp,12
	mov	si,ax
	?debug	L 2938
	?debug	L 2939
	pop	si
	pop	bp
	ret	
	?debug	C E6036572720404060466696C65020A0A0003706F+
	?debug	C 73060A0600
	?debug	E
	?debug	E
_MachinePartieRead	endp
	?debug	L 2951
	assume	cs:BMSMAKY_TEXT
_SetDemo	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E6056244656D6F020A0600
	?debug	B
	?debug	L 2953
	mov	al,byte ptr [bp+6]
	mov	byte ptr DGROUP:demo,al
	?debug	L 2954
	pop	bp
	ret	
	?debug	C E6056244656D6F020A0600
	?debug	E
	?debug	E
_SetDemo	endp
	?debug	L 2966
	assume	cs:BMSMAKY_TEXT
_GetDemo	proc	far
	?debug	B
	?debug	B
	?debug	L 2969
	call	far ptr _test_new_protection
	?debug	L 2973
	ret	
	?debug	E
	?debug	E
_GetDemo	endp
	?debug	L 3002
	assume	cs:BMSMAKY_TEXT
__clrrect	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,16
	push	si
	?debug	C E36A000400162100
	?debug	C E605636F6C6F72040A12000364696D1E0A0E0002+
	?debug	C 70311E0A0A0004706D61706A0A0600
	mov	si,word ptr [bp+18]
	?debug	B
	?debug	L 3007
	mov	ax,word ptr [bp+6]
	or	ax,word ptr [bp+8]
	je	short @81@290
	?debug	L 3009
	cmp	word ptr [bp+12],0
	jge	short @81@98
	?debug	L 3011
	mov	ax,word ptr [bp+12]
	add	word ptr [bp+16],ax
	?debug	L 3012
	mov	word ptr [bp+12],0
@81@98:
	?debug	L 3014
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr [bp+12]
	add	ax,word ptr [bp+16]
	cmp	word ptr es:[bx+2],ax
	jge	short @81@146
	?debug	L 3015
	mov	ax,word ptr es:[bx+2]
	sub	ax,word ptr [bp+12]
	mov	word ptr [bp+16],ax
@81@146:
	?debug	L 3016
	cmp	word ptr [bp+16],0
	jg	@@211
	jmp	@81@818
@@211:
	?debug	L 3018
	cmp	word ptr [bp+10],0
	jge	short @81@218
	?debug	L 3020
	mov	ax,word ptr [bp+10]
	add	word ptr [bp+14],ax
	?debug	L 3021
	mov	word ptr [bp+10],0
@81@218:
	?debug	L 3023
	mov	ax,word ptr [bp+10]
	add	ax,word ptr [bp+14]
	les	bx,dword ptr [bp+6]
	cmp	ax,word ptr es:[bx]
	jle	short @81@266
	?debug	L 3024
	mov	ax,word ptr es:[bx]
	sub	ax,word ptr [bp+10]
	mov	word ptr [bp+14],ax
@81@266:
	?debug	L 3025
	cmp	word ptr [bp+14],0
	jg	@@212
	jmp	@81@818
@@212:
@81@290:
	?debug	L 3029
	mov	ax,word ptr [bp+12]
	mov	word ptr [bp-16],ax
	?debug	L 3030
	mov	ax,word ptr [bp+10]
	mov	word ptr [bp-14],ax
	?debug	L 3031
	mov	ax,word ptr [bp+12]
	add	ax,word ptr [bp+16]
	mov	word ptr [bp-12],ax
	?debug	L 3032
	mov	ax,word ptr [bp+10]
	add	ax,word ptr [bp+14]
	mov	word ptr [bp-10],ax
	?debug	L 3034
	mov	ax,word ptr [bp+6]
	or	ax,word ptr [bp+8]
	je	@@213
	jmp	@81@578
@@213:
	?debug	L 3036
	push	ss
	lea	ax,word ptr [bp-16]
	push	ax
	push	cs
	call	near ptr _ifhidemousex
	add	sp,4
	?debug	L 3037
	mov	word ptr [bp-8],80
	?debug	L 3038
	mov	word ptr [bp-6],0
	mov	word ptr [bp-4],40960
	?debug	L 3039
	call	far ptr _ifcolor
	or	ax,ax
	jne	short @81@434
	?debug	L 3040
	cmp	si,15
	je	short @81@386
	mov	ax,1
	jmp	short @81@410
@81@386:
	xor	ax,ax
@81@410:
	shl	ax,2
	mov	dx,8
	or	dx,ax
	push	dx
	push	ss
	lea	ax,word ptr [bp-16]
	push	ax
	push	ss
	push	ax
	call	far ptr _blit
	add	sp,10
	jmp	@81@818
@81@434:
	?debug	L 3043
	push	cs
	call	near ptr _HideMouseInt
	?debug	L 3044
	mov	word ptr [bp-2],0
	jmp	short @81@506
@81@458:
	?debug	L 3046
	push	word ptr [bp-2]
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 3047
	mov	ax,si
	mov	cl,byte ptr [bp-2]
	sar	ax,cl
	mov	dx,1
	and	dx,ax
	shl	dx,2
	mov	ax,8
	or	ax,dx
	push	ax
	push	ss
	lea	ax,word ptr [bp-16]
	push	ax
	push	ss
	push	ax
	call	far ptr _blit
	add	sp,10
	?debug	L 3044
	inc	word ptr [bp-2]
@81@506:
	cmp	word ptr [bp-2],4
	jl	short @81@458
	?debug	L 3049
	push	cs
	call	near ptr _ShowMouseInt
	?debug	L 3051
	jmp	@81@818
@81@578:
	?debug	L 3055
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+4]
	mov	word ptr [bp-8],ax
	?debug	L 3056
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	mov	word ptr [bp-6],dx
	mov	word ptr [bp-4],ax
	?debug	L 3057
	cmp	word ptr es:[bx+6],4
	jne	short @81@722
	?debug	L 3058
	mov	word ptr [bp-2],0
	jmp	short @81@674
@81@626:
	?debug	L 3060
	mov	ax,si
	mov	cl,byte ptr [bp-2]
	sar	ax,cl
	mov	dx,1
	and	dx,ax
	shl	dx,2
	mov	ax,8
	or	ax,dx
	push	ax
	push	ss
	lea	ax,word ptr [bp-16]
	push	ax
	push	ss
	push	ax
	call	far ptr _blit
	add	sp,10
	?debug	L 3061
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx]
	imul	word ptr [bp-8]
	cwd	
	push	ax
	push	dx
	mov	dx,ss
	lea	ax,word ptr [bp-6]
	pop	cx
	pop	bx
	call	far ptr F_PADA@
	?debug	L 3058
	inc	word ptr [bp-2]
@81@674:
	cmp	word ptr [bp-2],4
	jl	short @81@626
	?debug	L 3062
	jmp	short @81@818
@81@722:
	?debug	L 3064
	cmp	si,15
	je	short @81@770
	mov	ax,1
	jmp	short @81@794
@81@770:
	xor	ax,ax
@81@794:
	shl	ax,2
	mov	dx,8
	or	dx,ax
	push	dx
	push	ss
	lea	ax,word ptr [bp-16]
	push	ax
	push	ss
	push	ax
	call	far ptr _blit
	add	sp,10
@81@818:
	?debug	L 3065
	?debug	L 3067
	pop	si
	leave	
	ret	
	?debug	C E605706C616E650402FEFF04646573741B02F0FF+
	?debug	C 05636F6C6F72040C060364696D1E0A0E00027031+
	?debug	C 1E0A0A0004706D61706A0A0600
	?debug	E
	?debug	E
__clrrect	endp
	?debug	L 3071
	assume	cs:BMSMAKY_TEXT
_procmode	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E6066F6E5F6F6666040A0800046D6F6465350A06+
	?debug	C 00
	?debug	B
	?debug	L 3073
	cmp	word ptr [bp+8],0
	je	short @82@242
	?debug	L 3074
	mov	ax,word ptr [bp+6]
	or	ax,ax
	je	short @82@170
	cmp	ax,2
	je	short @82@170
	cmp	ax,7
	je	short @82@194
	jmp	short @82@218
@82@170:
	?debug	L 3078
	mov	ax,2
	jmp	short @82@386
@82@194:
	?debug	L 3080
	mov	ax,7
	jmp	short @82@386
@82@218:
	jmp	short @82@362
@82@242:
	?debug	L 3086
	mov	ax,word ptr [bp+6]
	or	ax,ax
	je	short @82@338
	cmp	ax,5
	je	short @82@338
	jmp	short @82@362
@82@338:
	?debug	L 3090
	mov	ax,5
	jmp	short @82@386
@82@362:
	?debug	L 3094
	mov	ax,65535
@82@386:
	?debug	L 3096
	pop	bp
	ret	
	?debug	C E6066F6E5F6F6666040A0800046D6F6465350A06+
	?debug	C 00
	?debug	E
	?debug	E
_procmode	endp
	?debug	L 3098
	assume	cs:BMSMAKY_TEXT
__drawline	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,6
	push	si
	push	di
	?debug	C E36B000400162100
	?debug	C E605636F6C6F72040A1400046D6F6465350A1200+
	?debug	C 0364696D1E0A0E000270311E0A0A0004706D6170+
	?debug	C 6B0A0600
	mov	di,word ptr [bp+18]
	?debug	B
	?debug	L 3104
	cmp	di,65535
	jne	@@214
	jmp	@83@770
@@214:
	?debug	L 3106
	mov	ax,word ptr [bp+6]
	or	ax,word ptr [bp+8]
	je	short @83@266
	?debug	L 3108
	cmp	word ptr [bp+12],0
	jge	short @83@122
	?debug	L 3110
	mov	ax,word ptr [bp+12]
	add	word ptr [bp+16],ax
	?debug	L 3111
	mov	word ptr [bp+12],0
@83@122:
	?debug	L 3113
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr [bp+12]
	add	ax,word ptr [bp+16]
	cmp	word ptr es:[bx+2],ax
	jge	short @83@170
	?debug	L 3114
	mov	ax,word ptr es:[bx+2]
	sub	ax,word ptr [bp+12]
	mov	word ptr [bp+16],ax
@83@170:
	?debug	L 3116
	cmp	word ptr [bp+10],0
	jge	short @83@218
	?debug	L 3118
	mov	ax,word ptr [bp+10]
	add	word ptr [bp+14],ax
	?debug	L 3119
	mov	word ptr [bp+10],0
@83@218:
	?debug	L 3121
	mov	ax,word ptr [bp+10]
	add	ax,word ptr [bp+14]
	les	bx,dword ptr [bp+6]
	cmp	ax,word ptr es:[bx]
	jle	short @83@266
	?debug	L 3122
	mov	ax,word ptr es:[bx]
	sub	ax,word ptr [bp+10]
	mov	word ptr [bp+14],ax
@83@266:
	?debug	L 3125
	mov	ax,word ptr [bp+6]
	or	ax,word ptr [bp+8]
	je	@@215
	jmp	@83@530
@@215:
	?debug	L 3127
	push	cs
	call	near ptr _HideMouseInt
	?debug	L 3128
	mov	si,80
	?debug	L 3129
	mov	word ptr [bp-6],0
	mov	word ptr [bp-4],40960
	?debug	L 3130
	call	far ptr _ifcolor
	or	ax,ax
	jne	short @83@410
	?debug	L 3131
	?debug	L 3132
	cmp	word ptr [bp+20],15
	je	short @83@362
	mov	ax,1
	jmp	short @83@386
@83@362:
	xor	ax,ax
@83@386:
	push	ax
	push	di
	push	cs
	call	near ptr _procmode
	add	sp,4
	push	ax
	push	word ptr [bp+14]
	push	word ptr [bp+16]
	push	word ptr [bp+10]
	push	word ptr [bp+12]
	push	si
	push	word ptr [bp-4]
	push	word ptr [bp-6]
	call	far ptr __BDrawLine
	add	sp,16
	jmp	short @83@506
@83@410:
	?debug	L 3134
	mov	word ptr [bp-2],0
	jmp	short @83@482
@83@434:
	?debug	L 3136
	push	word ptr [bp-2]
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 3137
	?debug	L 3138
	mov	ax,word ptr [bp+20]
	mov	cl,byte ptr [bp-2]
	sar	ax,cl
	mov	dx,1
	and	dx,ax
	push	dx
	push	di
	push	cs
	call	near ptr _procmode
	add	sp,4
	push	ax
	push	word ptr [bp+14]
	push	word ptr [bp+16]
	push	word ptr [bp+10]
	push	word ptr [bp+12]
	push	si
	push	word ptr [bp-4]
	push	word ptr [bp-6]
	call	far ptr __BDrawLine
	add	sp,16
	?debug	L 3134
	inc	word ptr [bp-2]
@83@482:
	cmp	word ptr [bp-2],4
	jl	short @83@434
@83@506:
	?debug	L 3140
	push	cs
	call	near ptr _ShowMouseInt
	?debug	L 3141
	jmp	@83@770
@83@530:
	?debug	L 3145
	les	bx,dword ptr [bp+6]
	mov	si,word ptr es:[bx+4]
	?debug	L 3146
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	mov	word ptr [bp-6],dx
	mov	word ptr [bp-4],ax
	?debug	L 3147
	cmp	word ptr es:[bx+6],4
	jne	short @83@674
	?debug	L 3148
	mov	word ptr [bp-2],0
	jmp	short @83@626
@83@578:
	?debug	L 3150
	?debug	L 3151
	mov	ax,word ptr [bp+20]
	mov	cl,byte ptr [bp-2]
	sar	ax,cl
	mov	dx,1
	and	dx,ax
	push	dx
	push	di
	push	cs
	call	near ptr _procmode
	add	sp,4
	push	ax
	push	word ptr [bp+14]
	push	word ptr [bp+16]
	push	word ptr [bp+10]
	push	word ptr [bp+12]
	push	si
	push	word ptr [bp-4]
	push	word ptr [bp-6]
	call	far ptr __BDrawLine
	add	sp,16
	?debug	L 3152
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx]
	imul	si
	cwd	
	push	ax
	push	dx
	mov	dx,ss
	lea	ax,word ptr [bp-6]
	pop	cx
	pop	bx
	call	far ptr F_PADA@
	?debug	L 3148
	inc	word ptr [bp-2]
@83@626:
	cmp	word ptr [bp-2],4
	jl	short @83@578
	?debug	L 3153
	jmp	short @83@770
@83@674:
	?debug	L 3155
	?debug	L 3156
	cmp	word ptr [bp+20],15
	je	short @83@722
	mov	ax,1
	jmp	short @83@746
@83@722:
	xor	ax,ax
@83@746:
	push	ax
	push	di
	push	cs
	call	near ptr _procmode
	add	sp,4
	push	ax
	push	word ptr [bp+14]
	push	word ptr [bp+16]
	push	word ptr [bp+10]
	push	word ptr [bp+12]
	push	si
	push	word ptr [bp-4]
	push	word ptr [bp-6]
	call	far ptr __BDrawLine
	add	sp,16
@83@770:
	?debug	L 3157
	?debug	L 3159
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E36C000400160801
	?debug	C E6066F666673657404040604626D61706C02FAFF+
	?debug	C 05706C616E650402FEFF05636F6C6F72040A1400+
	?debug	C 046D6F6465350C070364696D1E0A0E000270311E+
	?debug	C 0A0A0004706D61706B0A0600
	?debug	E
	?debug	E
__drawline	endp
	?debug	L 3161
	assume	cs:BMSMAKY_TEXT
__drawrect	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,8
	push	si
	push	di
	?debug	C E36D000400162100
	?debug	C E605636F6C6F72040A1400046D6F6465350A1200+
	?debug	C 0364696D1E0A0E000270311E0A0A0004706D6170+
	?debug	C 6D0A0600
	mov	di,word ptr [bp+18]
	mov	si,word ptr [bp+20]
	?debug	B
	?debug	L 3165
	mov	ax,word ptr [bp+12]
	mov	dx,word ptr [bp+10]
	mov	word ptr [bp-4],dx
	mov	word ptr [bp-2],ax
	mov	ax,word ptr [bp+16]
	mov	dx,word ptr [bp+14]
	mov	word ptr [bp-8],dx
	mov	word ptr [bp-6],ax
	mov	word ptr [bp-8],0
	?debug	L 3166
	push	si
	push	di
	push	word ptr [bp-6]
	push	word ptr [bp-8]
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr __drawline
	add	sp,16
	?debug	L 3167
	mov	ax,word ptr [bp+14]
	add	word ptr [bp-4],ax
	?debug	L 3168
	push	si
	push	di
	push	word ptr [bp-6]
	push	word ptr [bp-8]
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr __drawline
	add	sp,16
	?debug	L 3169
	mov	ax,word ptr [bp+12]
	mov	dx,word ptr [bp+10]
	mov	word ptr [bp-4],dx
	mov	word ptr [bp-2],ax
	mov	ax,word ptr [bp+16]
	mov	dx,word ptr [bp+14]
	mov	word ptr [bp-8],dx
	mov	word ptr [bp-6],ax
	mov	word ptr [bp-6],0
	?debug	L 3170
	push	si
	push	di
	push	word ptr [bp-6]
	push	word ptr [bp-8]
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr __drawline
	add	sp,16
	?debug	L 3171
	mov	ax,word ptr [bp+16]
	add	word ptr [bp-2],ax
	?debug	L 3172
	push	si
	push	di
	push	word ptr [bp-6]
	push	word ptr [bp-8]
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	cs
	call	near ptr __drawline
	add	sp,16
	?debug	L 3173
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E6056474656D701E02F8FF057074656D701E02FC+
	?debug	C FF05636F6C6F72040C06046D6F6465350C070364+
	?debug	C 696D1E0A0E000270311E0A0A0004706D61706D0A+
	?debug	C 0600
	?debug	E
	?debug	E
__drawrect	endp
	?debug	L 3176
	assume	cs:BMSMAKY_TEXT
__setpixel	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,6
	push	si
	push	di
	?debug	C E36E000400162100
	?debug	C E605636F6C6F72040A1000046D6F6465350A0E00+
	?debug	C 0273741E0A0A0004706D61706E0A0600
	mov	di,word ptr [bp+14]
	?debug	B
	?debug	L 3182
	cmp	di,65535
	jne	@@216
	jmp	@85@746
@@216:
	?debug	L 3184
	cmp	word ptr [bp+12],0
	jge	@@217
	jmp	@85@746
@@217:
	cmp	word ptr [bp+10],0
	jge	@@218
	jmp	@85@746
@@218:
	?debug	L 3186
	mov	ax,word ptr [bp+6]
	or	ax,word ptr [bp+8]
	je	short @85@194
	?debug	L 3188
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx+2]
	cmp	ax,word ptr [bp+12]
	jg	@@219
	jmp	@85@746
@@219:
	mov	ax,word ptr es:[bx]
	cmp	ax,word ptr [bp+10]
	jg	short @85@242
	?debug	L 3189
	jmp	@85@746
@85@194:
	?debug	L 3193
	cmp	word ptr [bp+12],640
	jl	@@220
	jmp	@85@746
@@220:
	cmp	word ptr [bp+10],350
	jl	@@221
	jmp	@85@746
@@221:
@85@242:
	?debug	L 3197
	mov	ax,word ptr [bp+6]
	or	ax,word ptr [bp+8]
	je	@@222
	jmp	@85@506
@@222:
	?debug	L 3199
	push	cs
	call	near ptr _HideMouseInt
	?debug	L 3200
	mov	si,80
	?debug	L 3201
	mov	word ptr [bp-6],0
	mov	word ptr [bp-4],40960
	?debug	L 3202
	call	far ptr _ifcolor
	or	ax,ax
	jne	short @85@386
	?debug	L 3203
	cmp	word ptr [bp+16],15
	je	short @85@338
	mov	ax,1
	jmp	short @85@362
@85@338:
	xor	ax,ax
@85@362:
	push	ax
	push	di
	push	cs
	call	near ptr _procmode
	add	sp,4
	push	ax
	push	word ptr [bp+10]
	push	word ptr [bp+12]
	push	si
	push	word ptr [bp-4]
	push	word ptr [bp-6]
	call	far ptr _SetPixel
	add	sp,12
	jmp	short @85@482
@85@386:
	?debug	L 3205
	mov	word ptr [bp-2],0
	jmp	short @85@458
@85@410:
	?debug	L 3207
	push	word ptr [bp-2]
	call	far ptr _select_plane
	inc	sp
	inc	sp
	?debug	L 3208
	mov	ax,word ptr [bp+16]
	mov	cl,byte ptr [bp-2]
	sar	ax,cl
	mov	dx,1
	and	dx,ax
	push	dx
	push	di
	push	cs
	call	near ptr _procmode
	add	sp,4
	push	ax
	push	word ptr [bp+10]
	push	word ptr [bp+12]
	push	si
	push	word ptr [bp-4]
	push	word ptr [bp-6]
	call	far ptr _SetPixel
	add	sp,12
	?debug	L 3205
	inc	word ptr [bp-2]
@85@458:
	cmp	word ptr [bp-2],4
	jl	short @85@410
@85@482:
	?debug	L 3210
	push	cs
	call	near ptr _ShowMouseInt
	?debug	L 3211
	jmp	@85@746
@85@506:
	?debug	L 3215
	les	bx,dword ptr [bp+6]
	mov	si,word ptr es:[bx+4]
	?debug	L 3216
	mov	ax,word ptr es:[bx+14]
	mov	dx,word ptr es:[bx+12]
	mov	word ptr [bp-6],dx
	mov	word ptr [bp-4],ax
	?debug	L 3217
	cmp	word ptr es:[bx+6],4
	jne	short @85@650
	?debug	L 3218
	mov	word ptr [bp-2],0
	jmp	short @85@602
@85@554:
	?debug	L 3220
	mov	ax,word ptr [bp+16]
	mov	cl,byte ptr [bp-2]
	sar	ax,cl
	mov	dx,1
	and	dx,ax
	push	dx
	push	di
	push	cs
	call	near ptr _procmode
	add	sp,4
	push	ax
	push	word ptr [bp+10]
	push	word ptr [bp+12]
	push	si
	push	word ptr [bp-4]
	push	word ptr [bp-6]
	call	far ptr _SetPixel
	add	sp,12
	?debug	L 3221
	les	bx,dword ptr [bp+6]
	mov	ax,word ptr es:[bx]
	imul	si
	cwd	
	push	ax
	push	dx
	mov	dx,ss
	lea	ax,word ptr [bp-6]
	pop	cx
	pop	bx
	call	far ptr F_PADA@
	?debug	L 3218
	inc	word ptr [bp-2]
@85@602:
	cmp	word ptr [bp-2],4
	jl	short @85@554
	?debug	L 3222
	jmp	short @85@746
@85@650:
	?debug	L 3224
	cmp	word ptr [bp+16],15
	je	short @85@698
	mov	ax,1
	jmp	short @85@722
@85@698:
	xor	ax,ax
@85@722:
	push	ax
	push	di
	push	cs
	call	near ptr _procmode
	add	sp,4
	push	ax
	push	word ptr [bp+10]
	push	word ptr [bp+12]
	push	si
	push	word ptr [bp-4]
	push	word ptr [bp-6]
	call	far ptr _SetPixel
	add	sp,12
@85@746:
	?debug	L 3225
	?debug	L 3227
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E36F000400160801
	?debug	C E6066F666673657404040604626D61706F02FAFF+
	?debug	C 05706C616E650402FEFF05636F6C6F72040A1000+
	?debug	C 046D6F6465350C070273741E0A0A0004706D6170+
	?debug	C 6E0A0600
	?debug	E
	?debug	E
__setpixel	endp
	?debug	L 3229
	assume	cs:BMSMAKY_TEXT
_SetPixel	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	dec	sp
	dec	sp
	?debug	C E370000400160801
	?debug	C E6046D6F6465350A1000027930040A0E00027830+
	?debug	C 040A0C00066F6666736574040A0A0004626D6170+
	?debug	C 700A0600
	?debug	B
	?debug	L 3233
	mov	ax,word ptr [bp+14]
	imul	word ptr [bp+10]
	mov	dx,word ptr [bp+12]
	sar	dx,3
	add	ax,dx
	cwd	
	push	ax
	push	dx
	mov	dx,ss
	lea	ax,word ptr [bp+6]
	pop	cx
	pop	bx
	call	far ptr F_PADA@
	?debug	L 3234
	mov	cl,byte ptr [bp+12]
	and	cl,7
	mov	ax,128
	sar	ax,cl
	mov	word ptr [bp-2],ax
	?debug	L 3235
	mov	ax,word ptr [bp+16]
	cmp	ax,2
	je	short @86@194
	cmp	ax,5
	je	short @86@170
	cmp	ax,7
	je	short @86@218
	jmp	short @86@242
@86@170:
	?debug	L 3238
	mov	al,byte ptr [bp-2]
	not	al
	les	bx,dword ptr [bp+6]
	and	byte ptr es:[bx],al
	?debug	L 3239
	jmp	short @86@242
@86@194:
	?debug	L 3241
	les	bx,dword ptr [bp+6]
	mov	al,byte ptr [bp-2]
	or	byte ptr es:[bx],al
	?debug	L 3242
	jmp	short @86@242
@86@218:
	?debug	L 3244
	les	bx,dword ptr [bp+6]
	mov	al,byte ptr [bp-2]
	xor	byte ptr es:[bx],al
	?debug	L 3245
@86@242:
	?debug	L 3247
	leave	
	ret	
	?debug	C E6046D61736B0402FEFF046D6F6465350A100002+
	?debug	C 7930040A0E00027830040A0C00066F6666736574+
	?debug	C 040A0A0004626D6170700A0600
	?debug	E
	?debug	E
_SetPixel	endp
	?debug	L 3249
	assume	cs:BMSMAKY_TEXT
__BDrawLine	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	dec	sp
	dec	sp
	push	si
	push	di
	?debug	C E371000400160801
	?debug	C E6046D6F6465350A14000179040A12000178040A+
	?debug	C 1000027930040A0E00027830040A0C00066F6666+
	?debug	C 736574040A0A0004626D6170710A0600
	?debug	B
	?debug	L 3259
	cmp	word ptr [bp+16],0
	jge	short @87@74
	?debug	L 3261
	mov	ax,word ptr [bp+16]
	add	word ptr [bp+12],ax
	?debug	L 3262
	mov	ax,word ptr [bp+18]
	add	word ptr [bp+14],ax
	?debug	L 3263
	mov	ax,word ptr [bp+16]
	neg	ax
	mov	word ptr [bp+16],ax
	?debug	L 3264
	mov	ax,word ptr [bp+18]
	neg	ax
	mov	word ptr [bp+18],ax
@87@74:
	?debug	L 3266
	mov	ax,word ptr [bp+14]
	imul	word ptr [bp+10]
	mov	dx,word ptr [bp+12]
	sar	dx,3
	add	ax,dx
	cwd	
	push	ax
	push	dx
	mov	dx,ss
	lea	ax,word ptr [bp+6]
	pop	cx
	pop	bx
	call	far ptr F_PADA@
	?debug	L 3267
	mov	cl,byte ptr [bp+12]
	and	cl,7
	mov	ax,128
	sar	ax,cl
	mov	word ptr [bp-2],ax
	?debug	L 3268
	cmp	word ptr [bp+18],0
	jge	short @87@122
	?debug	L 3270
	mov	ax,word ptr [bp+18]
	neg	ax
	mov	word ptr [bp+18],ax
	?debug	L 3271
	mov	ax,word ptr [bp+10]
	neg	ax
	mov	word ptr [bp+10],ax
@87@122:
	?debug	L 3273
	mov	ax,word ptr [bp+16]
	cmp	ax,word ptr [bp+18]
	jl	@@223
	jmp	@87@482
@@223:
	?debug	L 3275
	mov	ax,word ptr [bp+18]
	sar	ax,1
	neg	ax
	mov	si,ax
	?debug	L 3276
	mov	di,word ptr [bp+18]
	jmp	short @87@434
@87@170:
	?debug	L 3278
	mov	ax,word ptr [bp+20]
	cmp	ax,2
	je	short @87@314
	cmp	ax,5
	je	short @87@290
	cmp	ax,7
	je	short @87@338
	jmp	short @87@362
@87@290:
	?debug	L 3281
	mov	al,byte ptr [bp-2]
	not	al
	les	bx,dword ptr [bp+6]
	and	byte ptr es:[bx],al
	?debug	L 3282
	jmp	short @87@362
@87@314:
	?debug	L 3284
	les	bx,dword ptr [bp+6]
	mov	al,byte ptr [bp-2]
	or	byte ptr es:[bx],al
	?debug	L 3285
	jmp	short @87@362
@87@338:
	?debug	L 3287
	les	bx,dword ptr [bp+6]
	mov	al,byte ptr [bp-2]
	xor	byte ptr es:[bx],al
	?debug	L 3288
@87@362:
	?debug	L 3290
	mov	ax,word ptr [bp+10]
	cwd	
	push	ax
	push	dx
	mov	dx,ss
	lea	ax,word ptr [bp+6]
	pop	cx
	pop	bx
	call	far ptr F_PADA@
	?debug	L 3291
	add	si,word ptr [bp+16]
	jle	short @87@434
	?debug	L 3293
	sub	si,word ptr [bp+18]
	?debug	L 3294
	sar	word ptr [bp-2],1
	mov	ax,word ptr [bp-2]
	or	ax,ax
	jne	short @87@434
	?debug	L 3296
	mov	word ptr [bp-2],128
	?debug	L 3297
	xor	cx,cx
	mov	bx,1
	mov	dx,ss
	lea	ax,word ptr [bp+6]
	call	far ptr F_PADA@
@87@434:
	dec	di
	jge	short @87@170
	?debug	L 3301
	jmp	@87@818
@87@482:
	?debug	L 3304
	mov	ax,word ptr [bp+16]
	sar	ax,1
	neg	ax
	mov	si,ax
	?debug	L 3305
	mov	di,word ptr [bp+16]
	jmp	short @87@794
@87@506:
	?debug	L 3307
	mov	ax,word ptr [bp+20]
	cmp	ax,2
	je	short @87@650
	cmp	ax,5
	je	short @87@626
	cmp	ax,7
	je	short @87@674
	jmp	short @87@698
@87@626:
	?debug	L 3310
	mov	al,byte ptr [bp-2]
	not	al
	les	bx,dword ptr [bp+6]
	and	byte ptr es:[bx],al
	?debug	L 3311
	jmp	short @87@698
@87@650:
	?debug	L 3313
	les	bx,dword ptr [bp+6]
	mov	al,byte ptr [bp-2]
	or	byte ptr es:[bx],al
	?debug	L 3314
	jmp	short @87@698
@87@674:
	?debug	L 3316
	les	bx,dword ptr [bp+6]
	mov	al,byte ptr [bp-2]
	xor	byte ptr es:[bx],al
	?debug	L 3317
@87@698:
	?debug	L 3319
	sar	word ptr [bp-2],1
	mov	ax,word ptr [bp-2]
	or	ax,ax
	jne	short @87@746
	?debug	L 3321
	mov	word ptr [bp-2],128
	?debug	L 3322
	xor	cx,cx
	mov	bx,1
	mov	dx,ss
	lea	ax,word ptr [bp+6]
	call	far ptr F_PADA@
@87@746:
	?debug	L 3324
	add	si,word ptr [bp+18]
	jle	short @87@794
	?debug	L 3326
	sub	si,word ptr [bp+16]
	?debug	L 3327
	mov	ax,word ptr [bp+10]
	cwd	
	push	ax
	push	dx
	mov	dx,ss
	lea	ax,word ptr [bp+6]
	pop	cx
	pop	bx
	call	far ptr F_PADA@
@87@794:
	dec	di
	jge	short @87@506
@87@818:
	?debug	L 3331
	pop	di
	pop	si
	leave	
	ret	
	?debug	C E6046D61736B0402FEFF01690404070572617469+
	?debug	C 6F040406046D6F6465350A14000179040A120001+
	?debug	C 78040A1000027930040A0E00027830040A0C0006+
	?debug	C 6F6666736574040A0A0004626D6170710A0600
	?debug	E
	?debug	E
__BDrawLine	endp
	?debug	L 3336
	assume	cs:BMSMAKY_TEXT
_MusicStart	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,20
	push	si
	?debug	C E604736F6E67040A0600
	mov	si,word ptr [bp+6]
	?debug	B
	?debug	L 3341
	cmp	si,1
	je	short @88@74
	cmp	si,2
	jne	short @88@98
@88@74:
	?debug	L 3343
	mov	ax,si
	add	ax,39
	push	ax
	push	cs
	call	near ptr _PlaySound
	inc	sp
	inc	sp
	?debug	L 3344
	jmp	short @88@170
@88@98:
	?debug	L 3347
	cmp	si,4
	jl	short @88@146
	?debug	L 3349
	mov	ax,si
	add	ax,65532
	mov	bx,8
	cwd	
	idiv	bx
	add	dx,4
	mov	si,dx
@88@146:
	?debug	L 3353
	call	far ptr _FMStopMusic
	?debug	L 3354
	push	si
	push	ds
	push	offset DGROUP:s@+711
	push	ss
	lea	ax,word ptr [bp-20]
	push	ax
	call	far ptr _sprintf
	add	sp,10
	?debug	L 3355
	push	ss
	lea	ax,word ptr [bp-20]
	push	ax
	call	far ptr _FMLoadSong
	add	sp,4
	?debug	L 3356
	call	far ptr _FMStartMusic
@88@170:
	?debug	L 3357
	pop	si
	leave	
	ret	
	?debug	C E3720014001A02
	?debug	C E60866696C656E616D657202ECFF04736F6E6704+
	?debug	C 0C06
	?debug	E
	?debug	E
_MusicStart	endp
	?debug	L 3359
	assume	cs:BMSMAKY_TEXT
_MusicStop	proc	far
	?debug	B
	?debug	B
	?debug	L 3361
	call	far ptr _FMStopMusic
	?debug	L 3362
	ret	
	?debug	E
	?debug	E
_MusicStop	endp
	?debug	L 3364
	assume	cs:BMSMAKY_TEXT
_PlayNoiseVolume	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E606766F6C756D65040A0600
	?debug	B
	?debug	L 3366
	cmp	word ptr [bp+6],0
	jne	short @90@74
	?debug	L 3368
	mov	byte ptr DGROUP:_sound_onoff,0
	?debug	L 3369
	call	far ptr _toneoff
	?debug	L 3370
	jmp	short @90@98
@90@74:
	?debug	L 3372
	mov	byte ptr DGROUP:_sound_onoff,1
@90@98:
	?debug	L 3373
	mov	ax,word ptr [bp+6]
	mov	dx,10
	imul	dx
	push	ax
	call	far ptr _setdacvolume
	inc	sp
	inc	sp
	?debug	L 3374
	pop	bp
	ret	
	?debug	C E606766F6C756D65040A0600
	?debug	E
	?debug	E
_PlayNoiseVolume	endp
BMSMAKY_TEXT	ends
_DATA	segment word public 'DATA'
currentvolume	label	word
	db	255
	db	255
_DATA	ends
_BSS	segment word public 'BSS'
	db	2 dup (?)
_BSS	ends
BMSMAKY_TEXT	segment byte public 'CODE'
	?debug	L 3379
	assume	cs:BMSMAKY_TEXT
_PlayMusicVolume	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	push	si
	?debug	C E606766F6C756D65040A0600
	mov	si,word ptr [bp+6]
	?debug	B
	?debug	L 3383
	cmp	word ptr DGROUP:currentvolume,65535
	je	short @91@74
	?debug	L 3384
	mov	ax,word ptr DGROUP:currentvolume
	mov	word ptr DGROUP:oldvolume,ax
	jmp	short @91@98
@91@74:
	?debug	L 3386
	mov	word ptr DGROUP:oldvolume,si
@91@98:
	?debug	L 3388
	mov	word ptr DGROUP:currentvolume,si
	?debug	L 3389
	mov	ax,si
	mov	dx,10
	imul	dx
	push	ax
	call	far ptr _FMSetVolume
	inc	sp
	inc	sp
	?debug	L 3391
	or	si,si
	jne	short @91@146
	?debug	L 3393
	call	far ptr _FMStopMusic
	?debug	L 3394
	mov	word ptr DGROUP:b@w+8,1
	?debug	L 3395
	jmp	short @91@194
@91@146:
	?debug	L 3398
	cmp	word ptr DGROUP:b@w+8,0
	je	short @91@194
	?debug	L 3399
	call	far ptr _FMStartMusic
@91@194:
	?debug	L 3401
	pop	si
	pop	bp
	ret	
	?debug	C E6096D757369636E756C6C04000003080006766F+
	?debug	C 6C756D65040C06
	?debug	E
	?debug	E
_PlayMusicVolume	endp
	?debug	L 3404
	assume	cs:BMSMAKY_TEXT
_restore_volume	proc	far
	?debug	B
	?debug	B
	?debug	L 3406
	push	word ptr DGROUP:oldvolume
	push	cs
	call	near ptr _PlayMusicVolume
	inc	sp
	inc	sp
	?debug	L 3407
	ret	
	?debug	E
	?debug	E
_restore_volume	endp
	?debug	L 3409
	assume	cs:BMSMAKY_TEXT
_errmem	proc	far
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E6036D696E060A0A000473757070060A0600
	?debug	B
	?debug	L 3419
	?debug	L 3422
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	call	far ptr _farcoreleft
	mov	bx,word ptr [bp+8]
	mov	cx,word ptr [bp+6]
	add	cx,ax
	adc	bx,dx
	push	bx
	push	cx
	push	ds
	push	offset DGROUP:s@+723
	call	far ptr _printf
	add	sp,12
	?debug	L 3432
	push	3
	call	far ptr _exit
	inc	sp
	inc	sp
	?debug	L 3433
	pop	bp
	ret	
	?debug	C E6036D696E060A0A000473757070060A0600
	?debug	E
	?debug	E
_errmem	endp
BMSMAKY_TEXT	ends
_BSS	segment word public 'BSS'
_icons	label	word
	db	6 dup (?)
lxwdo	label	word
	db	2 dup (?)
mouse_on	label	word
	db	2 dup (?)
imPC	label	word
	db	12 dup (?)
mtime	label	word
	db	4 dup (?)
lywdo	label	word
	db	2 dup (?)
relr	label	word
	db	2 dup (?)
rell	label	word
	db	2 dup (?)
mousebuttons	label	word
	db	2 dup (?)
pushr	label	word
	db	2 dup (?)
pushl	label	word
	db	2 dup (?)
buffer	label	dword
	db	4 dup (?)
oldvolume	label	word
	db	2 dup (?)
buttons	label	word
	db	2 dup (?)
nextrand	label	word
	db	40 dup (?)
_xmsicons	label	word
	db	48 dup (?)
xmshandle	label	word
	db	2 dup (?)
havemouse	label	word
	db	2 dup (?)
keystatus	label	word
	db	2 dup (?)
origine	label	word
	db	4 dup (?)
have_sbcard	label	word
	db	2 dup (?)
	?debug	C E9
_BSS	ends
_DATA	segment word public 'DATA'
s@	label	byte
	db	'BLUPIX%02d.COL'
	db	0
	db	'rb'
	db	0
	db	'Cannot open file '
	db	0
	db	'GetPixmap: out of memory'
	db	0
	db	'GetImage'
	db	0
	db	'GetImage: out of memory'
	db	0
	db	'Initializing Blupimania.'
	db	10
	db	0
	db	'blupiman.bma'
	db	0
	db	'File BLUPIMAN.BMA not found.'
	db	10
	db	0
	db	'%ld bytes of XMS memory allocated.'
	db	10
	db	0
	db	'Loading icons - ['
	db	0
	db	'.'
	db	0
	db	'Pas assez de m'
	db	-126
	db	'moire XMS. Consultez le fichier LISEZMOI.TXT'
	db	10
	db	0
	db	'XMS error no %x.'
	db	10
	db	0
	db	']'
	db	10
	db	0
	db	'Pas de XMS'
	db	0
	db	'XMS memory manager found.'
	db	10
	db	0
	db	'b1.ic'
	db	0
	db	'A bient'
	db	-109
	db	't !'
	db	10
	db	0
	db	'r'
	db	0
	db	'Fatal error: %d'
	db	10
	db	0
	db	'r'
	db	0
	db	'Erreur fatale num'
	db	-126
	db	'ro %d avec %s '
	db	0
	db	'Erreur fatale %s avec %s '
	db	0
	db	'========================================================='
	db	10
	db	0
	db	'                          B L U P I M A N I A   1 . 3        '
	db	'                   '
	db	10
	db	0
	db	'No mouse driver'
	db	10
	db	0
	db	'Mouse driver found.'
	db	10
	db	0
	db	'                    D E M O'
	db	10
	db	0
	db	'BLUPIMAN.INF'
	db	0
	db	'Checking for soundboard.'
	db	10
	db	0
	db	10
	db	'Unsupported graphic mode'
	db	0
	db	'bmx%03d.mus'
	db	0
	db	'Sie haben nicht genug Speicherplatz, um dieses Program zu sta'
	db	'rten.'
	db	10
	db	'Zur Zeit stehen Ihnen %ld Bytes freier konventioneller Speich'
	db	'er zur'
	db	10
	db	'Verf'
	db	-127
	db	'gung. Sie ben'
	db	-108
	db	'tigen aber mindestens %ld Bytes freien'
	db	10
	db	'konventionellen Speicher'
	db	10
	db	0
_DATA	ends
BMSMAKY_TEXT	segment byte public 'CODE'
BMSMAKY_TEXT	ends
_LoadCLUT	equ	LoadCLUT
	public	_GetKeyStatus
	extrn	__creat:far
	extrn	_select_plane:far
	extrn	_setdacvolume:far
	extrn	_lseek:far
	extrn	_FMMusicDeinit:far
	extrn	_fseek:far
	extrn	_fopen:far
	extrn	_restore_clock:far
	extrn	__open:far
_fatalerrptr	equ	fatalerrptr
_hiddenmouse	equ	hiddenmouse
	public	_HideMouseInt
_have_sbcard	equ	have_sbcard
	public	_DrawLine
	public	_sbsound
	extrn	_ifcolor:far
	public	_IfMouse
_getmousepos	equ	getmousepos
_origine	equ	origine
	extrn	_decode_image:far
	extrn	_querry_video:far
	public	_procmode
	extrn	_printf:far
	extrn	_FMStartMusic:far
	extrn	_playsoundblast:far
	extrn	_filelength:far
	extrn	__fgetc:far
	public	_PlayMusicVolume
	public	_PlayNoiseVolume
	public	_InitRandomEx
	extrn	_FMSetVolume:far
	public	_MachinePartieLg
	public	_FileDelete
	extrn	_unlink:far
	public	_MusicStart
	public	_DrawRect
	extrn	_farcoreleft:far
_keystatus	equ	keystatus
	extrn	_FMStopMusic:far
_visumouse	equ	visumouse
	extrn	_FMMusicInit:far
_lastmouse	equ	lastmouse
_havemouse	equ	havemouse
	public	_FatalError
	extrn	_FMLoadSong:far
	extrn	_typetext:word
_AfMenu	equ	AfMenu
	public	_FileRename
	public	_DboxMem
	extrn	_textcolor:far
	extrn	_playsoundloop:far
	public	_FileWrite
	extrn	_zap_screen:far
	public	_HideMouse
	extrn	_farmalloc:far
_xmshandle	equ	xmshandle
	extrn	_errno:word
	extrn	_gettimems:far
	public	_errmem
	public	_PlayStartStop
	public	_PlaySoundLoop
	public	_MusicStop
	public	_TestVLine
	public	_TestHLine
	extrn	_XMSFreeMem:far
	public	_GetRandom
	public	_CacheIcon
	public	_xmsicons
_lastimage	equ	lastimage
_nextrand	equ	nextrand
	extrn	_memmove:far
	public	_CloseGraDesc
	extrn	_text_mode:far
	public	_GivePixmap
	extrn	_farmemset:far
	public	_ShowMouseInt
	extrn	_XMSGetMem:far
	public	_GetEvent
	public	_CloseMachine
	extrn	_fread:far
	public	_DuplPixel
	extrn	_state_down:byte
	public	_OpenGraDesc
	extrn	__read:far
	extrn	_filsson:word
	extrn	_XMSCopy:far
_buttons	equ	buttons
	public	_GetPixmap
_FatalLoad	equ	FatalLoad
	extrn	_free:far
	public	_StartRandom
_shiftypart	equ	shiftypart
_shiftxpart	equ	shiftxpart
	public	_OpenMachine
	public	_GetImage
	public	_GetIcon
	public	_SetPixel
	public	_SetDemo
	public	_lineegal
	extrn	_state_right:byte
	public	_GetDemo
	public	_GetPixel
	extrn	_memcpy:far
	extrn	_XMSErr:byte
	public	_spmemmove
	extrn	_XMSInit:far
	extrn	_tcol_loadclut:far
	extrn	_rename:far
	public	_FileRead
	extrn	_farfree:far
	extrn	_bioskey:far
	public	_xmsload
	public	_GetRandomEx
	public	_ScrollPixelRect
	public	_ShowMouse
	public	_BlackScreen
	extrn	_state_left:byte
	public	_ClrEvents
	extrn	_state_up:byte
_oldvolume	equ	oldvolume
	public	__drawline
_buffer	equ	buffer
	public	_PlaySound
_clrmouse	equ	clrmouse
_pushl	equ	pushl
_pushr	equ	pushr
	public	_CloseTime
	extrn	_strerror:far
_mousebuttons	equ	mousebuttons
	extrn	_time:far
	extrn	_trap_interrupts:far
	extrn	_tell:far
	extrn	_sprintf:far
_rell	equ	rell
_relr	equ	relr
_lywdo	equ	lywdo
_demo	equ	demo
_PCFatalError	equ	PCFatalError
	extrn	_fprintf:far
	extrn	_cprintf:far
	extrn	_getch:far
	public	__drawrect
	public	_OpenTime
	extrn	_test_new_protection:far
_shifty	equ	shifty
_shiftx	equ	shiftx
	extrn	_release_interrupts:far
	extrn	_read:far
_pim	equ	pim
	public	_MachinePartieWrite
	public	_CheckMem
_ClearMem	equ	ClearMem
	extrn	_sound_onoff:byte
	public	_clrfifo
	public	_blpinfo
_copyquarter	equ	copyquarter
	public	_chgmode
	public	_ScrollPixel
	extrn	_close:far
_mtime	equ	mtime
	extrn	_restore_video_mode:far
	extrn	F_SCOPY@:far
_atime	equ	atime
	extrn	_ftell:far
	extrn	_clrscr:far
_imPC	equ	imPC
	public	_PosMouse
	extrn	_uninit_sound:far
_mouse_on	equ	mouse_on
	public	__GetIcon
_mousecode	equ	mousecode
_lxwdo	equ	lxwdo
	public	__setpixel
	extrn	__streams:word
_LoadIcon	equ	LoadIcon
_LoadImage	equ	LoadImage
_colormode	equ	colormode
	extrn	F_LDIV@:far
	extrn	_exit:far
	public	_CopyPixel
	extrn	_blit:far
	extrn	_gotoxy:far
	extrn	F_LXMUL@:far
_mouseon	equ	mouseon
	public	_IfFileExist
_mouseoff	equ	mouseoff
	extrn	_open:far
	public	_MachinePartieRead
	public	_ifhidemousex
	extrn	_graphic_mode:far
	extrn	F_SPUSH@:far
	extrn	__write:far
	extrn	_fclose:far
	public	__clrrect
	extrn	__close:far
	extrn	F_LUMOD@:far
	extrn	_toneoff:far
	extrn	_textbackground:far
	public	_DrawFillRect
	public	_restore_volume
	extrn	_init_sound:far
	extrn	_save_video_mode:far
	public	__BDrawLine
	extrn	_vfy_mouse:far
_UnloadIcon	equ	UnloadIcon
	public	_initmouse
	public	_IfPlayReady
	extrn	F_PADD@:far
	public	_FileGetLength
	public	_icons
	extrn	_end_sound:far
	extrn	F_PADA@:far
_currentvolume	equ	currentvolume
	?debug	C EA010C
	?debug	C E37300000023010400
	?debug	C E4000653544C4546540100000753545249474854+
	?debug	C 0200000453545550040080065354444F574E0800
	?debug	C E37500020022000080FF7F
	?debug	C E37400000023750400
	?debug	C EC0D5F4765744B65795374617475737418
	?debug	C E37700000023040400
	?debug	C EB075F5F637265617477
	?debug	C E37800000023010400
	?debug	C EB0D5F73656C6563745F706C616E6578
	?debug	C E37900000023040400
	?debug	C EB0D5F736574646163766F6C756D6579
	?debug	C E37A00000023060400
	?debug	C EB065F6C7365656B7A
	?debug	C E37B00000023010400
	?debug	C EB0E5F464D4D757369634465696E69747B
	?debug	C E37C00000023040400
	?debug	C EB065F667365656B7C
	?debug	C E37E000400164900
	?debug	C E37D000000237E0400
	?debug	C EB065F666F70656E7D
	?debug	C EB0E5F726573746F72655F636C6F636B79
	?debug	C E37F00000023040400
	?debug	C EB065F5F6F70656E7F
	?debug	C E38080000400160200
	?debug	C E3808100000023010400
	?debug	C EC0D5F486964654D6F757365496E74808118
	?debug	C E3808200000023010400
	?debug	C EC095F447261774C696E65808218
	?debug	C E3808300000023040400
	?debug	C EC085F7362736F756E64808318
	?debug	C E3808400000023040400
	?debug	C EB085F6966636F6C6F728084
	?debug	C E3808500000023040400
	?debug	C EC085F49664D6F757365808518
	?debug	C E38086000000231E0400
	?debug	C E3808700000023010400
	?debug	C EB0D5F6465636F64655F696D6167658087
	?debug	C E3808800000023010400
	?debug	C EB0D5F7175657272795F766964656F8088
	?debug	C E3808900000023350400
	?debug	C EC095F70726F636D6F6465808918
	?debug	C E3808A00000023040401
	?debug	C EB075F7072696E7466808A
	?debug	C EB0D5F464D53746172744D7573696379
	?debug	C EB0F5F706C6179736F756E64626C61737479
	?debug	C E3808B00000023060400
	?debug	C EB0B5F66696C656C656E677468808B
	?debug	C E3808C00000023040400
	?debug	C EB075F5F6667657463808C
	?debug	C E3808D00000023010400
	?debug	C EC105F506C61794D75736963566F6C756D65808D+
	?debug	C 18
	?debug	C E3808E00000023010400
	?debug	C EC105F506C61794E6F697365566F6C756D65808E+
	?debug	C 18
	?debug	C E3808F00000023010400
	?debug	C EC0D5F496E697452616E646F6D4578808F18
	?debug	C E3809000000023040400
	?debug	C EB0C5F464D536574566F6C756D658090
	?debug	C E3809100000023060400
	?debug	C EC105F4D616368696E655061727469654C678091+
	?debug	C 18
	?debug	C E3809200000023040400
	?debug	C EC0B5F46696C6544656C657465809218
	?debug	C E3809300000023040400
	?debug	C EB075F756E6C696E6B8093
	?debug	C E3809400000023010400
	?debug	C EC0B5F4D757369635374617274809418
	?debug	C E3809500000023010400
	?debug	C EC095F4472617752656374809518
	?debug	C E38096000000230C0400
	?debug	C EB0C5F666172636F72656C6566748096
	?debug	C EB0C5F464D53746F704D7573696379
	?debug	C E3809700000023040400
	?debug	C EB0C5F464D4D75736963496E69748097
	?debug	C E3809800000023010400
	?debug	C EC0B5F466174616C4572726F72809818
	?debug	C E3809900000023040400
	?debug	C EB0B5F464D4C6F6164536F6E678099
	?debug	C EB095F747970657465787404
	?debug	C E3809A00000023010400
	?debug	C E3809B00000023040400
	?debug	C EC0B5F46696C6552656E616D65809B18
	?debug	C E3809C00000023040400
	?debug	C EC085F44626F784D656D809C18
	?debug	C E3809D00000023010400
	?debug	C EB0A5F74657874636F6C6F72809D
	?debug	C EB0E5F706C6179736F756E646C6F6F7079
	?debug	C E3809E00000023040400
	?debug	C EC0A5F46696C655772697465809E18
	?debug	C E3809F00000023010400
	?debug	C EB0B5F7A61705F73637265656E809F
	?debug	C E380A000000023010400
	?debug	C EC0A5F486964654D6F75736580A018
	?debug	C E380A2000400160100
	?debug	C E380A10000002380A20400
	?debug	C EB0A5F6661726D616C6C6F6380A1
	?debug	C EB065F6572726E6F04
	?debug	C E380A300000023060400
	?debug	C EB0A5F67657474696D656D7380A3
	?debug	C E380A400000023010400
	?debug	C EC075F6572726D656D80A418
	?debug	C E380A500000023010400
	?debug	C EC0E5F506C6179537461727453746F7080A518
	?debug	C E380A600000023010400
	?debug	C EC0E5F506C6179536F756E644C6F6F7080A618
	?debug	C E380A700000023010400
	?debug	C EC0A5F4D7573696353746F7080A718
	?debug	C E380A800000023040400
	?debug	C EC0A5F54657374564C696E6580A818
	?debug	C E380A900000023040400
	?debug	C EC0A5F54657374484C696E6580A918
	?debug	C E380AA00000023010400
	?debug	C EB0B5F584D53467265654D656D80AA
	?debug	C E380AB00000023040400
	?debug	C EC0A5F47657452616E646F6D80AB18
	?debug	C E380AC00000023010400
	?debug	C EC0A5F436163686549636F6E80AC18
	?debug	C E380AD0030001A57
	?debug	C EC095F786D7369636F6E7380AD00
	?debug	C E380AE0028001A0C
	?debug	C E380B0000400160100
	?debug	C E380AF0000002380B00400
	?debug	C EB085F6D656D6D6F766580AF
	?debug	C E380B100000023010400
	?debug	C EC0D5F436C6F73654772614465736380B118
	?debug	C E380B200000023010400
	?debug	C EB0A5F746578745F6D6F646580B2
	?debug	C E380B300000023040400
	?debug	C EC0B5F476976655069786D617080B318
	?debug	C E380B400000023010400
	?debug	C EB0A5F6661726D656D73657480B4
	?debug	C E380B500000023010400
	?debug	C EC0D5F53686F774D6F757365496E7480B518
	?debug	C E380B600000023040400
	?debug	C EB0A5F584D534765744D656D80B6
	?debug	C E380B700000023040400
	?debug	C EC095F4765744576656E7480B718
	?debug	C E380B800000023010400
	?debug	C EC0D5F436C6F73654D616368696E6580B818
	?debug	C E380B9000000230A0400
	?debug	C EB065F667265616480B9
	?debug	C E380BA00000023010400
	?debug	C EC0A5F4475706C506978656C80BA18
	?debug	C EB0B5F73746174655F646F776E02
	?debug	C E380BB00000023010400
	?debug	C EC0C5F4F70656E4772614465736380BB18
	?debug	C E380BC00000023040400
	?debug	C EB065F5F7265616480BC
	?debug	C EB085F66696C73736F6E04
	?debug	C E380BD00000023010400
	?debug	C EB085F584D53436F707980BD
	?debug	C E380BE00000023040400
	?debug	C EC0A5F4765745069786D617080BE18
	?debug	C E380BF00000023010400
	?debug	C E380C000000023010400
	?debug	C EB055F6672656580C0
	?debug	C E380C100000023010400
	?debug	C EC0C5F537461727452616E646F6D80C118
	?debug	C E380C200000023010400
	?debug	C E380C300000023010400
	?debug	C E380C400000023010400
	?debug	C EC0C5F4F70656E4D616368696E6580C418
	?debug	C E380C500000023040400
	?debug	C EC095F476574496D61676580C518
	?debug	C E380C600000023040400
	?debug	C EC085F47657449636F6E80C618
	?debug	C E380C700000023010400
	?debug	C EC095F536574506978656C80C718
	?debug	C E380C800000023010400
	?debug	C EC085F53657444656D6F80C818
	?debug	C E380C900000023010400
	?debug	C EC095F6C696E656567616C80C918
	?debug	C EB0C5F73746174655F726967687402
	?debug	C E380CA00000023020400
	?debug	C EC085F47657444656D6F80CA18
	?debug	C E380CB00000023020400
	?debug	C EC095F476574506978656C80CB18
	?debug	C E380CD000400160100
	?debug	C E380CC0000002380CD0400
	?debug	C EB075F6D656D63707980CC
	?debug	C EB075F584D5345727208
	?debug	C E380CE00000023040400
	?debug	C EC0A5F73706D656D6D6F766580CE18
	?debug	C E380CF00000023080400
	?debug	C EB085F584D53496E697480CF
	?debug	C E380D000000023010400
	?debug	C EB0E5F74636F6C5F6C6F6164636C757480D0
	?debug	C E380D100000023040400
	?debug	C EB075F72656E616D6580D1
	?debug	C E380D200000023040400
	?debug	C EC095F46696C655265616480D218
	?debug	C E380D300000023010400
	?debug	C EB085F6661726672656580D3
	?debug	C EB085F62696F736B657979
	?debug	C E380D400000023040400
	?debug	C EC085F786D736C6F616480D418
	?debug	C E380D500000023040400
	?debug	C EC0C5F47657452616E646F6D457880D518
	?debug	C E380D600000023010400
	?debug	C EC105F5363726F6C6C506978656C5265637480D6+
	?debug	C 18
	?debug	C E380D700000023010400
	?debug	C EC0A5F53686F774D6F75736580D718
	?debug	C E380D800000023010400
	?debug	C EC0C5F426C61636B53637265656E80D818
	?debug	C EB0B5F73746174655F6C65667402
	?debug	C E380D900000023010400
	?debug	C EC0A5F436C724576656E747380D918
	?debug	C EB095F73746174655F757002
	?debug	C E380DA00000023010400
	?debug	C EC0A5F5F647261776C696E6580DA18
	?debug	C E380DB000400160200
	?debug	C E380DC00000023010400
	?debug	C EC0A5F506C6179536F756E6480DC18
	?debug	C E380DD00000023010400
	?debug	C E380DE00000023010400
	?debug	C EC0A5F436C6F736554696D6580DE18
	?debug	C E380E0000400160200
	?debug	C E380DF0000002380E00400
	?debug	C EB095F7374726572726F7280DF
	?debug	C E380E100000023060400
	?debug	C EB055F74696D6580E1
	?debug	C E380E200000023010400
	?debug	C EB105F747261705F696E746572727570747380E2
	?debug	C E380E300000023060400
	?debug	C EB055F74656C6C80E3
	?debug	C E380E400000023040401
	?debug	C EB085F737072696E746680E4
	?debug	C E380E500000023010400
	?debug	C E380E600000023040401
	?debug	C EB085F667072696E746680E6
	?debug	C E380E700000023040401
	?debug	C EB085F637072696E746680E7
	?debug	C E380E800000023040400
	?debug	C EB065F676574636880E8
	?debug	C E380E900000023010400
	?debug	C EC0A5F5F647261777265637480E918
	?debug	C E380EA00000023010400
	?debug	C EC095F4F70656E54696D6580EA18
	?debug	C EB145F746573745F6E65775F70726F7465637469+
	?debug	C 6F6E79
	?debug	C E380EB00000023010400
	?debug	C E380EC00000023010400
	?debug	C E380ED00000023010400
	?debug	C EB135F72656C656173655F696E74657272757074+
	?debug	C 7380ED
	?debug	C E380EE00000023040400
	?debug	C EB055F7265616480EE
	?debug	C E380F3000C001A08
	?debug	C E20005696D747970080005696D636F6408000569+
	?debug	C 6D626970080005696D646972080005696D646C78+
	?debug	C 0A0005696D646C790A0005696D6E62620C000569+
	?debug	C 6D73697A0A0005696D636E740A0005696D6C6763+
	?debug	C 0C8006696D66696C6C80F3
	?debug	C E380F20020001E
	?debug	C E380F10004001680F200
	?debug	C E380F4000400160200
	?debug	C E380F5000400160200
	?debug	C E200046865616480F10004636C757480F4800464+
	?debug	C 61746180F5
	?debug	C E380F0000C001E
	?debug	C E380EF0004001680F000
	?debug	C E380F600000023040400
	?debug	C EC135F4D616368696E6550617274696557726974+
	?debug	C 6580F618
	?debug	C E380F700000023040400
	?debug	C EC095F436865636B4D656D80F718
	?debug	C E380F800000023010400
	?debug	C EB0C5F736F756E645F6F6E6F666602
	?debug	C E380F900000023010400
	?debug	C EC085F636C726669666F80F918
	?debug	C E380FB0011001A02
	?debug	C E2000573626164720400057362646D6104000573+
	?debug	C 626972710400067362747970650400066C616E67+
	?debug	C 75650200056D75736963020005736F756E640280+
	?debug	C 0666696C6C657280FB
	?debug	C E380FA07626C70696E666F1C001E
	?debug	C EC085F626C70696E666F80FA00
	?debug	C E380FC00000023010400
	?debug	C E380FD00000023040400
	?debug	C EC085F6368676D6F646580FD18
	?debug	C E380FE00000023010400
	?debug	C EC0C5F5363726F6C6C506978656C80FE18
	?debug	C E380FF00000023040400
	?debug	C EB065F636C6F736580FF
	?debug	C E3810000000023010400
	?debug	C EB135F726573746F72655F766964656F5F6D6F64+
	?debug	C 658100
	?debug	C E3810100000023040500
	?debug	C EB08465F53434F5059408101
	?debug	C E3810200000023060400
	?debug	C EB065F6674656C6C8102
	?debug	C E3810300000023010400
	?debug	C EB075F636C727363728103
	?debug	C E3810400000023010400
	?debug	C EC095F506F734D6F757365810418
	?debug	C EB0D5F756E696E69745F736F756E6479
	?debug	C E3810500000023040400
	?debug	C EC095F5F47657449636F6E810518
	?debug	C E3810600000023040400
	?debug	C E3810700000023010400
	?debug	C EC0A5F5F736574706978656C810718
	?debug	C E381080000001A49
	?debug	C EB095F5F73747265616D738108
	?debug	C E3810900000023040400
	?debug	C E3810A00000023040400
	?debug	C EB07465F4C444956408101
	?debug	C E3810B00000023010400
	?debug	C EB055F65786974810B
	?debug	C E3810C00000023040400
	?debug	C EC0A5F436F7079506978656C810C18
	?debug	C E3810D00000023010400
	?debug	C EB055F626C6974810D
	?debug	C E3810E00000023010400
	?debug	C EB075F676F746F7879810E
	?debug	C EB08465F4C584D554C408101
	?debug	C E3810F00000023010400
	?debug	C E3811000000023040400
	?debug	C EC0C5F496646696C654578697374811018
	?debug	C E3811100000023010400
	?debug	C E3811200000023040401
	?debug	C EB055F6F70656E8112
	?debug	C E3811300000023040400
	?debug	C EC125F4D616368696E6550617274696552656164+
	?debug	C 811318
	?debug	C E3811400000023010400
	?debug	C EC0D5F6966686964656D6F75736578811418
	?debug	C E3811500000023040400
	?debug	C EB0D5F677261706869635F6D6F64658115
	?debug	C EB08465F5350555348408101
	?debug	C E3811600000023040400
	?debug	C EB075F5F77726974658116
	?debug	C E3811700000023040400
	?debug	C EB075F66636C6F73658117
	?debug	C E3811800000023010400
	?debug	C EC095F5F636C7272656374811818
	?debug	C E3811900000023040400
	?debug	C EB075F5F636C6F73658119
	?debug	C EB08465F4C554D4F44408101
	?debug	C EB085F746F6E656F666679
	?debug	C E3811A00000023010400
	?debug	C EB0F5F746578746261636B67726F756E64811A
	?debug	C E3811B00000023010400
	?debug	C EC0D5F4472617746696C6C52656374811B18
	?debug	C E3811C00000023010400
	?debug	C EC0F5F726573746F72655F766F6C756D65811C18
	?debug	C EB0B5F696E69745F736F756E6479
	?debug	C E3811D00000023010400
	?debug	C EB105F736176655F766964656F5F6D6F6465811D
	?debug	C E3811E00000023010400
	?debug	C EC0B5F5F42447261774C696E65811E18
	?debug	C E3811F00000023040400
	?debug	C EB0A5F7666795F6D6F757365811F
	?debug	C E3812000000023010400
	?debug	C E3812100000023040400
	?debug	C EC0A5F696E69746D6F757365812118
	?debug	C E3812200000023040400
	?debug	C EC0C5F4966506C61795265616479812218
	?debug	C EB07465F50414444408101
	?debug	C E3812300000023060400
	?debug	C EC0E5F46696C654765744C656E677468812318
	?debug	C EC065F69636F6E735700
	?debug	C EB0A5F656E645F736F756E6479
	?debug	C EB07465F50414441408101
	?debug	C E60B666174616C65727270747280800000027F00+
	?debug	C 0B68696464656E6D6F7573650400000235000B68+
	?debug	C 6176655F736263617264040000039A00076F7269+
	?debug	C 67696E651E0000039600096B6579737461747573+
	?debug	C 75000003940009766973756D6F7573650A000002+
	?debug	C 2200096C6173746D6F7573651E00000224000968+
	?debug	C 6176656D6F75736504000003920009786D736861+
	?debug	C 6E646C65040000039000096C617374696D616765+
	?debug	C 0A0000022D00086E65787472616E6480AE000003+
	?debug	C 380007627574746F6E73040000033600096F6C64+
	?debug	C 766F6C756D650400000334000662756666657280+
	?debug	C DB000003300005707573686C040000032E000570+
	?debug	C 75736872040000032C000C6D6F75736562757474+
	?debug	C 6F6E73040000032A000472656C6C040000032800+
	?debug	C 0472656C72040000032600056C7977646F040000+
	?debug	C 0324000464656D6F0200000228000370696D80EF+
	?debug	C 0000022900056D74696D65060000032000056174+
	?debug	C 696D65060000021C0004696D504380F000000314+
	?debug	C 00086D6F7573655F6F6E040000031200056C7877+
	?debug	C 646F04000003100009636F6C6F726D6F64650400+
	?debug	C 000220000D63757272656E74766F6C756D650400+
	?debug	C 0002830006755F6368617208060250741E06094B+
	?debug	C 657953746174757375060952656374616E676C65+
	?debug	C 2C0604574F52440A0604424F4F4C08060674696D+
	?debug	C 655F7406060673697A655F740A06065069786D61+
	?debug	C 70210605496D61676580F2060970747264696666+
	?debug	C 5F74060607496D616765504380F0060853686F77+
	?debug	C 4D6F6465350607636C6F636B5F74060604425954+
	?debug	C 4508060666706F735F740606
	?debug	C E607755F73686F72740A060446494C4549060675+
	?debug	C 5F6C6F6E670C060777636861725F74020607786D+
	?debug	C 7369636F6E5707066269746D61701B0707626C70+
	?debug	C 696E666F80FA0709696366696C656469725807
	?debug	F LoadCLUT 115 24
	?debug	F getmousepos 134 24
	?debug	F AfMenu 154 24
	?debug	F FatalLoad 191 24
	?debug	F shiftypart 194 24
	?debug	F shiftxpart 195 24
	?debug	F clrmouse 221 24
	?debug	F PCFatalError 229 24
	?debug	F shifty 235 24
	?debug	F shiftx 236 24
	?debug	F ClearMem 248 24
	?debug	F copyquarter 252 24
	?debug	F mousecode 262 24
	?debug	F LoadIcon 265 24
	?debug	F LoadImage 266 24
	?debug	F mouseon 271 24
	?debug	F mouseoff 273 24
	?debug	F UnloadIcon 288 24
	end
