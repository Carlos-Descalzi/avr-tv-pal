; vim: syntax=asm
.global text_mode
.include "defs.inc"

text_mode:
    cpi		STATUS,	    STAT_SYNC
    brne 	draw_top_border
    rcall 	do_sync
    ldi 	STATUS,	    STAT_TBORDER
    ldi 	LINE,	    60
    rjmp 	rt_end

draw_top_border:
    cpi 	STATUS,	    STAT_TBORDER
    brne 	draw_lines
    rcall 	do_border
    dec 	LINE
    brne 	rt_end
    ldi 	LINE,	    192
    ldi 	STATUS,     STAT_DRAW

    clr		XL                      ; Back to address 0x0000
    clr 	XH
    clr 	ROWIDX                  ; And character row index 0

    rjmp 	rt_end

draw_lines:
    cpi 	STATUS,	    STAT_DRAW
    brne 	draw_bottom_border
    rcall 	do_line
    dec 	LINE
    brne 	rt_end
    ldi 	LINE,	    60
    ldi 	STATUS,	    STAT_LBORDER
    rjmp 	rt_end

draw_bottom_border:
    cpi 	STATUS,	    STAT_LBORDER
    brne 	rt_end
    rcall 	do_border
    dec 	LINE
    brne 	rt_end
    ldi		STATUS,     STAT_SYNC
    
rt_end:
    reti

do_sync:
    ZERO
    DELAY_28US
    BLACK
    DELAY_4US
    ZERO
    DELAY_28US
    BLACK
    DELAY_4US
    ret

do_border:
    ZERO
    DELAY_4US
    BLACK
    ret


.macro LOADBYTE
    ; The whole byte laod is done while shift register 
    ; writes on screen, this MUST be 17 clock cycles.
    out     ADDRL,      XL
    out     ADDRH,      XH
    nop
    nop
    SET_OE
    adiw    XL,         1
    movw    ZL,         YL
    in		r16,	    DATA		; Get the character to display from data bus.
    add 	ZL,		    r16			; Add the character to display
    adc 	ZH,		    ROWIDX		; Add the character row.
    CLR_OE
    lpm		r16,	    Z           ; ... and get the byte to display.
.endm


do_line:
    ; Write a whole horizontal line with sync pulses included.
    ZERO
    DELAY_4US
    
    SET_CE

    BLACK
    DELAY_12US

    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR, 	r16
    LOADBYTE
    out 	SPDR,   r16
    ; Release bus
    CLR_CE
    ; Fill with cycles
    nop
    nop
    nop
    nop

    nop
    nop
    nop
    nop

    nop
    nop
    nop
    nop

    nop
    nop
    nop
    nop
    ; ... to finally set the screen black again.
    clr 	r16
    out 	SPDR,   r16

    inc		ROWIDX                  ; increment character row
    andi	ROWIDX,	0x07            ; fit between 0 and 7.

    breq	endloop                 ; 
    sbiw	XL, 	32	            ; back to the begining of the line if hasn't written the 8 rows.
    ret

endloop:
    nop
    nop
    ret
