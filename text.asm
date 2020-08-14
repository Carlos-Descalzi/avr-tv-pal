.include "common.inc"

.global run_timer

.macro CLR_ADDR_REGS
    clr		YL                      ; Back to address 0x0000
    clr 	YH
    clr 	ROWIDX                  ; And character row index 0
.endm

run_timer:
    cpi		STATUS,	STAT_SYNC
    brne 	rt_2
    rcall 	do_sync
    ldi 	STATUS,	STAT_TBORDER
    ldi 	LINE,	60
    rjmp 	rt_end

rt_2:
    cpi 	STATUS,	STAT_TBORDER
    brne 	rt_3
    rcall 	do_border
    dec 	LINE
    brne 	rt_end
    ldi 	LINE,	192
    ldi 	STATUS, STAT_DRAW
    CLR_ADDR_REGS
    rjmp 	rt_end

rt_3:
    cpi 	STATUS,	STAT_DRAW
    brne 	rt_4
    rcall 	do_line
    dec 	LINE
    brne 	rt_end
    ldi 	LINE,	60
    ldi 	STATUS,	STAT_LBORDER
    rjmp 	rt_end

rt_4:
    cpi 	STATUS,	STAT_LBORDER
    brne 	rt_end
    rcall 	do_border
    dec 	LINE
    brne 	rt_end
    ldi		STATUS, STAT_SYNC
    
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

.macro	SET_OE
    cbi		CTRL,	PIN_OE		    ; OE set on external SRAM
.endm

.macro CLR_OE
    sbi		CTRL,	PIN_OE		    ; OE clear on external SRAM
.endm

.macro SET_CE
    cbi 	CTRL, 	PIN_BUSREQ	    ; Chip-select set on external SRAM.
.endm

.macro CLR_CE
    sbi 	CTRL, 	PIN_BUSREQ	    ; Chip-select clear on external SRAM.
.endm


.macro LOADBYTE
    ; The whole byte laod is done while shift register 
    ; writes on screen, this MUST be 17 clock cycles.
    out 	ADDRL,	YL		        ; Put YL:YH into ADDRL:ADDRH
    out 	ADDRH,	YH		        ;
    SET_OE                  
    ; Increment Memory Address registers (YL:YH)
    ; DO NOT USE ADIW INSTRUCTION, IT BREAKS EVERYTHING AND I DON'T KNOW WHY
    add		YL,		CONE	        ; CONSTANT 1
    adc		YH,		CZERO	        ; CONSTANT 0
    ldi 	ZL,		lo8(FONTMAP)	; Prepare fontmap pointer
    ldi 	ZH,		hi8(FONTMAP)	;
    nop
    in		r16,	DATA			; Get the character to display from data bus.
    CLR_OE
    add 	ZL,		r16				; Add the character to display
    adc 	ZH,		ROWIDX			; Add the character row.
    lpm		r16,	Z               ; ... and get the byte to display.
.endm


.macro DOFILL
    out 	SPDR, 	r16
    LOADBYTE
.endm

.macro DOFILLAST
    ; Write last byte, and let pass some clock cycles.
    nop
    out 	SPDR,   r16

    CLR_CE

    nop
    nop

    NOP4
    NOP4
    NOP4
    NOP4
.endm


do_line:
    ; Write a whole horizontal line with sync pulses included.
    ZERO
    DELAY_4US

    BLACK
    DELAY_12US

    SET_CE

    LOADBYTE

dl_loop:

    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILL
    DOFILLAST

    clr 	r16
    out 	SPDR,	r16

    inc		ROWIDX                  ; increment character row
    andi	ROWIDX,	0x07            ; fit between 0 and 7.

    breq	endloop                 ; != 0? REVISAR 
    sbiw	YL, 	32	            ; back to the begining of the line if hasn't written the 8 rows.
    ret

endloop:
    nop
    nop
    ret
