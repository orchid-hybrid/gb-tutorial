INCLUDE "hardware.inc"

SECTION "entry",ROM0[$0100]
	nop
	jp $0150

SECTION "start",HOME[$150]
	di

	call WAIT_VBLANK
	
	ld	hl,heart
	ld	de,_VRAM

	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	ld	a,[hl]
	inc	hl
	ld	[de],a
	inc	de
	
loop:	
	halt
	nop
	jp	loop

WAIT_VBLANK:
	ldh	a,[rLY]
	cp	$91
	jr	nz,WAIT_VBLANK
	ret

heart:
	db $00,$00,$6e,$6e,$bf,$93,$bf,$83,$ff,$83,$7e,$46,$3c,$2c,$18,$18
