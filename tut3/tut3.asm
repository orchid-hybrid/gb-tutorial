INCLUDE "hardware.inc"

SECTION "entry",ROM0[$0100]
	nop
	jp $0150

SECTION "start",HOME[$150]
	di

	call WAIT_VBLANK

;;	TODO read about turning off the LCD
	
	ld   a,%11100100 ;load a normal palette
	ldh  [rBGP],a    ;load the palette
	
	ld	hl,heart
	ld	de,_VRAM+$190

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
