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
.include "defs.inc"

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
    
    ldi r16,            0xF7
    out DDRB,	        r16
    ldi r16,	        0xFF
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

run_timer:
    in      r16,    CTRLI
    andi    r16,    FLAG_MODE
    brne    _gfx                        ; 0: Text, 1: Graphics
    nop
    jmp    text_mode
_gfx:
    jmp    gfx_mode

    
no_int:
    reti
    nop

