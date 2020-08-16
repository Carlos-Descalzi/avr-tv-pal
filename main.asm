; vim: syntax=asm
;
;  SYNC     PB0 ------------- PA0    A0
;  BUSRQ    PB1 -           - PA1    A1
;  OE       PB2 -           - PA2    A2
;           PB3 -           - PA3    A3
;           PB4 -           - PA4    A4
;           PB5 -           - PA5    A5
;           PB6 -           - PA6    A6
;           PB7 -           - PA7    A7
;         RESET -           -
;           VCC -           -
;           GND -           -
;          XTAL -           - PC7    
;          XTAL -           - PC6    
;  D0       PD0 -           - PC5    
;  D1       PD1 -           - PC4    A12
;  D2       PD2 -           - PC3    A11
;  D3       PD3 -           - PC2    A10
;  D4       PD4 -           - PC1    A9
;  D5       PD5 -           - PC0    A8
;  D6       PD6 ------------- PD7    D7

;;;
; Ports
;
; PORTA - PINA

.equ    DDRA    , 0x1A
.equ    ADDRL   , 0x1B
;.equ	DATA	, 0x19

; PORTB 
.equ    DDRB    , 0x17
.equ	CTRL	, 0x18
; PORTC
.equ    DDRC    , 0x14
.equ	ADDRH	, 0x15
; PORTD
.equ    DDRD    , 0x11
;.equ	ADDRL	, 0x12
.equ    PORTD   , 0x12
.equ    DATA    , 0x10

.equ    PORTB   , 0x18
.equ    OCR1AL  , 0x2A
.equ    OCR1AH  , 0x2B
.equ    TCNT1L  , 0x2C
.equ    TCNT1H  , 0x2D
;.equ	TCCR1A	, 0x2F
.equ    TCCR1B  , 0x2E
.equ	SPL		, 0x3d
.equ	SPH		, 0x3e
;.equ	TIFR	, 0x38
.equ    TIMSK   , 0x39
.equ	SPDR	, 0x0F
.equ	SPSR	, 0x0E
.equ	SPCR	, 0x0D 

.equ    MCUCR   , 0x35
;;;

;;;
; Registers
;
; Work register
.equ    r16     , 16
.equ    CTRLR   , 17
; Delay counter
.equ    DELAY  , 19
; Counters
.equ    ROWIDX  , 21
.equ    LINE    , 22
.equ    STATUS  , 23
; Memory address.
.equ    XL      , 26
.equ    XH      , 27
; Font map pointer constant. Stored here for copy with movw
.equ    YL      , 28
.equ    YH      , 29
; Font map pointer
.equ    ZL      , 30
.equ    ZH      , 31
;;;

;;;
; Constants
;
PIN_SYNC		    = 0x00
PIN_BUSREQ			= 0x01
PIN_OE				= 0x02

FLAG_SYNC           = 0x01
FLAG_BUSREQ         = 0x02
FLAG_OE             = 0x04

STAT_SYNC		    = 0x00
STAT_TBORDER		= 0x01
STAT_DRAW			= 0x02
STAT_LBORDER		= 0x03

WGM12   			= 0x08
CS10				= 0x01
OCIE1A  			= 0x10
OCIE0				= 0x02
OCF1A				= 0x10

SPE					= 0x40
MSTR				= 0x10
CPOL				= 0x04

SPI2X				= 0x01

F_CPU				= 16000000
TIMERS				= (F_CPU/1000000)*64
RAMEND				= 0x085f
;;;

;;;
; Macros
;
.macro  ZERO
    ;andi    CTRLR,  ~FLAG_SYNC
    ;out     CTRL,   CTRLR
    cbi     CTRL,   PIN_SYNC
.endm
.macro  BLACK
    ;ori     CTRLR,  FLAG_SYNC
    ;out     CTRL,   CTRLR
    sbi     CTRL,   PIN_SYNC
.endm
.macro	SET_OE
    ;andi    CTRLR,  ~FLAG_OE
    ;out     CTRL,   CTRLR
    cbi		CTRL,	PIN_OE		    ; OE set on external SRAM
.endm
.macro  CLR_OE
    ;ori     CTRLR,  FLAG_OE
    ;out     CTRL,   CTRLR
    sbi		CTRL,	PIN_OE		    ; OE clear on external SRAM
.endm
.macro  SET_CE
    ;andi    CTRLR,  ~FLAG_BUSREQ
    ;out     CTRL,   CTRLR
    cbi 	CTRL, 	PIN_BUSREQ	    ; Chip-select set on external SRAM.
.endm
.macro  CLR_CE
    ;ori     CTRLR,  FLAG_BUSREQ
    ;out     CTRL,   CTRLR
    sbi 	CTRL, 	PIN_BUSREQ	    ; Chip-select clear on external SRAM.
.endm

.macro DELAY_4US
    ldi  DELAY, 21
    dec  DELAY
    brne .-4
    nop
.endm

.macro DELAY_12US
    ldi  DELAY, 64
    dec  DELAY
    brne .-4
.endm

.macro DELAY_28US
    ldi  DELAY, 149
    dec  DELAY
    brne .-4
    nop
.endm

;;;

.org 0x0000
    jmp main
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int
    jmp run_timer
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int
    jmp no_int

main:
; setup
    ; stack
    ldi r16,	        hi8(RAMEND)
    out SPH,	        r16
    ldi r16,	        lo8(RAMEND)
    out SPL,	        r16

    ; ports
    clr r16
    out DDRD,	        r16
    out PORTD,          r16
    
    ldi r16,	        0xFF
    out DDRB,	        r16
    out DDRC,       	r16
    out DDRA,	        r16
    ; SPI
    ldi r16, 	        SPE | MSTR | CPOL
    out SPCR, 	        r16
    ldi r16, 	        SPI2X
    out SPSR,	        r16

    ; timer
    ldi r16,	        hi8(TIMERS) 
    out OCR1AH,	        r16
    ldi r16,	        lo8(TIMERS)
    out OCR1AL,	        r16
    ldi r16, 	        CS10 | WGM12
    out TCCR1B,	        r16
    ldi r16,	        OCIE1A
    out TIMSK,	        r16
    clr r16
    out TCNT1H,	        r16
    out TCNT1L,	        r16

    ; clean registers
    ldi STATUS,	        STAT_SYNC
    clr ROWIDX
    clr LINE
    ldi YL,		        lo8(FONTMAP)	; Prepare fontmap pointer
    ldi YH,		        hi8(FONTMAP)	;

    ; clean control lines
    ZERO
    CLR_OE
    CLR_CE
    sei
main_loop:
    rjmp main_loop

no_int:
    reti
    nop

;.include "fontmap.inc"

run_timer:
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
    out     ADDRL,  XL
    out     ADDRH,  XH
    nop
    nop
    SET_OE
    adiw    XL,     1
    movw    ZL,     YL
    in		r16,	DATA			; Get the character to display from data bus.
    
    add 	ZL,		r16				; Add the character to display
    adc 	ZH,		ROWIDX			; Add the character row.
    
    CLR_OE
    lpm		r16,	Z               ; ... and get the byte to display.
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
