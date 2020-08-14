.include "common.inc"

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
    out DDRA,	        r16
    out PORTA,	        r16
    
    ldi r16,	        0xFF
    out DDRB,	        r16
    out DDRC,       	r16
    out DDRD,	        r16
    ; SPI
    ldi r16, 	        SPE
    out SPCR, 	        r16
    ldi r16, 	        SPI2X
    out SPSR,	        r16

    ; timer
    ldi r16,	        hi8(TIMERS) 
    out OCR1AH,	        r16
    ldi r16,	        lo8(TIMERS)
    out OCR1AL,	        r16
    ldi r16, 	        CS10
    out TCCR1B,	        r16
    ldi r16,	        OCIE1A
    out TIMSK,	        r16
    clr r16
    out TCNT1H,	        r16
    out TCNT1L,	        r16

    ; clean registers
    clr CZERO
    ldi CONE,	        1
    ldi STATUS,	        STAT_SYNC
    clr ROWIDX
    clr LINE

    ; clean control lines
    cbi CTRL, 	        PIN_SYNC
    sbi CTRL,	        PIN_BUSREQ
    sbi	CTRL,	        PIN_OE
    sei
main_loop:
    rjmp main_loop

no_int:
    reti
