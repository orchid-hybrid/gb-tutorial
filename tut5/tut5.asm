INCLUDE "hardware.inc"

SECTION "entry",ROM0[$0100]
	nop
	jp $0150

SECTION "start",HOME[$150]
	di

	call	waitvblank

;;; it is essential to turn off the LCD inside vblank or you can damage the gameboy
;;; it is also essential here because we do so many instructions that vblank would finish before we do, causing the operations to fail
	ld   a,%00000000	
	ldh  [rLCDC],a

	ld	a,0
	ld	b,$80
	ld	de,_SCRN0
	call	memset
	call	memset
	call	memset
	call	memset
	
	ld	b,$10
	ld	hl,box
	ld	de,_VRAM
	call	memcpy
	
;;; http://nocash.emubase.de/pandocs.htm#lcdcontrolregister
;;; bit7 [1]: turn the LCD on
;;; bit4 [1]: select the correct/default background tile bank
;;; bit3 [0]: select the correct/default background tile map
;;; bit0 [1]: background display on
	ld   a,%10010001
	ldh  [rLCDC],a
	
	ld   a,%11100100 ;load a normal palette
	ldh  [rBGP],a    ;load the palette
	
loop:	
	halt
	nop
	jp	loop

waitvblank:
	ldh	a,[rLY]
	cp	$91
	jr	nz,waitvblank
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

box:
	db $ff,$ff,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$ff,$ff
