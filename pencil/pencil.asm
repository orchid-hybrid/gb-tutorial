INCLUDE "hardware.inc"

sprX	EQU	$C024
sprY	EQU	$C025

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
	
	ld	de,_VRAM+$10
	ld	hl,pencil
	ld	b,$10
	call	memcpy
	ld	b,$10
	call	memcpy
	ld	b,$10
	call	memcpy
	ld	b,$10
	call	memcpy

	;; set up a sprite
	ld	a,$12
	ld	[sprX],a
	ld	a,$55
	ld	[sprY],a
	
	ld	hl,$FE00
	ld	a,[sprY]
	ld	[hl],a
	inc	hl
	ld	a,[sprX]
	ld	[hl],a
	inc	hl
	ld	[hl],$03
	inc	hl
	ld	[hl],%00000000
	inc	hl
;;;  set the sprite palette OBP0
	ld	a,%01111000
	ld	[rOBP0],a
	
	;;  bit 1:: OBJ (Sprite) display enable
	ld   a,%10010011
	ldh  [rLCDC],a
	
	ld   a,%11100100
	ldh  [rBGP],a    ;load the palette

	;;  enable V-Blank interrupts
	ld	a,%00000001
	ld	[$FFFF],a
	ei			;enable interrupts so that vblank drops us past the HALT
	
loop:	
	call	read_pad
	
	bit	4,c
	jr	z,skipMoveX
	ld	a,[sprX]
	inc	a
	ld	[sprX],a
skipMoveX:

	bit	5,c
	jr	z,skipMoveXback
	ld	a,[sprX]
	dec	a
	ld	[sprX],a
skipMoveXback:

	bit	7,c
	jr	z,skipMoveY
	ld	a,[sprY]
	inc	a
	ld	[sprY],a
skipMoveY:

	bit	6,c
	jr	z,skipMoveYback
	ld	a,[sprY]
	dec	a
	ld	[sprY],a
skipMoveYback:


	;; update sprite position
	ld	hl,$FE00
	ld	a,[sprY]
	ld	[hl],a
	inc	hl
	ld	a,[sprX]
	ld	[hl],a
	inc	hl
	
	halt
	nop
	jp	loop

vblank:
	ld	hl,$FE00
	ld	[hl],$20
	inc	hl
	ld	[hl],$30
	inc	hl
	
skip:
	reti

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

;;; this code is taken from
;;; http://gbdev.gg8.se/wiki/articles/ASM_Joypad
;;; with the variable changed to the c register
read_pad:
    ; init
    ld      a, 0
    ld      c, a

    ; read the d-pad:
    ld      a, %00100000    ; bit 4 = 0, bit 5 = 1 (d-pad on, buttons off)
    ld      [rP1], a
    ; read the status of the d-pad
    ; we do several reads because of bouncing
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]

    and     $0F             ; just keep low nibble (d-pad status)
    swap    a               ; swap low and high nibbles
    ld      b, a            ; save d-pad status in b register

    ; let's read the buttons
    ld      a, %00010000    ; bit 4 = 1, bit 5 = 0 (buttons on, d-pad off)
    ld      [rP1], a

    ; bouncing...
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]

    ; we have in "a" the status of the buttons
    and     $0F             ; just keep low nibble.
    or      b               ; OR with "b" to put in the high byte of "a"
                            ; the d-pad status.

    ; now we have in "a" the status of all the controls
    ; make the complement of it (so activated buttons read as 1)
    ; and save it 
    cpl
    ld      c, a

    ; reset the joypad
    ld      a,$30
    ld      [rP1], a

    ; return
    ret


pencil:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$03,$03,$06,$07,$0C
	db $00,$10,$10,$38,$38,$64,$7C,$CE,$FE,$99,$FC,$32,$F8,$64,$F0,$C8
	db $0F,$19,$1F,$33,$3F,$66,$5F,$EC,$6E,$F9,$74,$BA,$78,$9C,$00,$F8
	db $E0,$90,$C0,$20,$80,$40,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00
