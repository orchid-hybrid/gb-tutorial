INCLUDE "hardware.inc"

SECTION "vblank",HOME[$40]
	jp vblank
SECTION "lcdc",HOME[$48]
	reti
SECTION "timer",HOME[$50]
	reti
SECTION "serial",HOME[$58]
	reti
SECTION "joypad",HOME[$60]
	reti

SECTION "entry",ROM0[$0100]
	nop
	jp $0150

SECTION "start",HOME[$150]
	di

	call	waitvblank

	ld   a,%00000000
	ldh  [rLCDC],a

;;; clear away the nintendo logo
	ld	a,0
	ld	hl,_SCRN0+$104
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	hl,_SCRN0+$124
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	ld	[hli],a
	
	ld	a,1
	ld	hl,_SCRN0+$C7
	ld	b,6
maprowloop:
	ld	c,6
mapcolloop:
	ld	[hli],a
	inc	a
	
	dec	c
	jr	nz,mapcolloop

	ld	de,$20-6
	add	hl,de
	
	dec	b
	jr	nz,maprowloop

	
	ld	de,_VRAM
	
	ld	hl,blank
	ld	b,$10
	call	memcpy
	
	ld	c,$A8
	ld	hl,sinistar
tilesloop:	
	ld	b,$10
	call	memcpy
	dec	c
	jr	nz,tilesloop

	ld	hl,sinistar_mouth
	ld	b,$20
	call	memcpy
	
	call	openmouth
	ld	c,$10
	ld	d,$0
	
	ld   a,%10010001
	ldh  [rLCDC],a
	
	ld   a,%00100111
	ldh  [rBGP],a    ;load the palette

	;;  enable V-Blank interrupts
	ld	a,%00000001
	ld	[$FFFF],a
	ei			;enable interrupts so that vblank drops us past the HALT
	
loop:	
	halt
	nop
	jp	loop

vblank:
	dec	c
	jr	nz,skip
	ld	c,$10
	call	openmouth
	ld	a,1
	xor	d
	ld	d,a
	jr	nz,skip
	call	closemouth
skip:
	reti

waitvblank:
	ldh	a,[rLY]
	cp	$91
	jr	nz,waitvblank
	ret

openmouth:
	ld	hl,_SCRN0+$149
	ld	a,$A9
	ld	[hli],a
	ld	a,$AA
	ld	[hli],a
	ret
	
closemouth:
	ld	hl,_SCRN0+$149
	ld	a,27
	ld	[hli],a
	ld	a,28
	ld	[hli],a
	ret

memcpy:
	ld	a,[hli]
	ld	[de],a
	inc	de
	dec	b
	jr	nz,memcpy
	ret

memset:
	ld	[de],a
	inc	de
	dec	b
	jr	nz,memset
	ret

blank:
	db	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

sinistar:
INCLUDE "sinistar.inc"

sinistar_mouth:
INCLUDE "sinistar_mouth.inc"
