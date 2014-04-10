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

	ld	b,$10
	ld	a,0
	ld	de,_VRAM
	call	memset
	ld	b,$10
	ld	a,$ff
	call	memset

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
	
	ld   a,%10010001
	ldh  [rLCDC],a
	
	ld   a,%11100100
	ldh  [rBGP],a    ;load the palette

	;;  enable V-Blank interrupts
	ld	a,%00000001
	ld	[$FFFF],a
	ei			;enable interrupts so that vblank drops us past the HALT
	
loop:
	call	read_pad
	ld	hl,_SCRN0
	ld	b,1
	
	ld	a,c
	and	b
	ld	[hli],a
	rrc	c
	ld	a,c
	and	b
	ld	[hli],a
	rrc	c
	ld	a,c
	and	b
	ld	[hli],a
	rrc	c
	ld	a,c
	and	b
	ld	[hli],a
	rrc	c
	ld	a,c
	and	b
	ld	[hli],a
	rrc	c
	ld	a,c
	and	b
	ld	[hli],a
	rrc	c
	ld	a,c
	and	b
	ld	[hli],a
	rrc	c
	ld	a,c
	and	b
	ld	[hli],a
	rrc	c
	
	
	halt
	nop
	jp	loop

vblank:
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
