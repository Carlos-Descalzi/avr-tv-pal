; vim: syntax=asm
.global gfx_mode
.include "defs.inc"

gfx_mode:
	cpi	    STATUS,     STAT_SYNC
	brne    draw_top_border
	rcall   do_sync
	ldi     STATUS,     STAT_TBORDER
	ldi     LINE,       60
	rjmp rt_end

draw_top_border:
	cpi     STATUS,     STAT_TBORDER
	brne    draw_lines
	rcall   do_border
	dec     LINE
	brne    rt_end
	ldi     LINE,       192
	ldi     STATUS,     STAT_DRAW

	clr     XL
	clr     XH
	clr     ROWIDX
	
	rjmp rt_end

draw_lines:
	cpi     STATUS,     STAT_DRAW
	brne    draw_bottom_border
	rcall   do_line
	dec     LINE
	brne    rt_end
	ldi     LINE,       60
	ldi     STATUS,     STAT_LBORDER
	rjmp rt_end

draw_bottom_border:
	cpi     STATUS,     STAT_LBORDER
	brne    rt_end
	rcall   do_border
	dec     LINE
	brne    rt_end
	ldi     STATUS,     STAT_SYNC
	
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


	out     ADDRL,	    XL
	out     ADDRH,	    YH
	nop
	nop
	SET_OE
	in      r16,        DATA
    adiw    XL,         1
    nop
	CLR_OE

	nop
	nop
	nop
	nop
	nop
.endm


do_line:
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

    nop;inc		ROWIDX                  ; increment character row
    nop;andi	ROWIDX,	0x07            ; fit between 0 and 7.

    nop;breq	endloop                 ; 
    nop;sbiw	XL, 	32	            ; back to the begining of the line if hasn't written the 8 rows.
    ret
