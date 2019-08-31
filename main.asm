;
;  SYNC     PB0 ------------- PA0    D0
;  BUSRQ    PB1 -           - PA1    D1
;  OE       PB2 -           - PA2    D2
;           PB3 -           - PA3    D3
;           PB4 -           - PA4    D4
;           PB5 -           - PA5    D5
;           PB6 -           - PA6    D6
;           PB7 -           - PA7    D7
;         RESET -           -
;           VCC -           -
;           GND -           -
;          XTAL -           - PC7    
;          XTAL -           - PC6    
;  A0       PD0 -           - PC5    
;  A1       PD1 -           - PC4    A12
;  A2       PD2 -           - PC3    A11
;  A3       PD3 -           - PC2    A10
;  A4       PD4 -           - PC1    A9
;  A5       PD5 -           - PC0    A8
;  A6       PD6 ------------- PD7    A7

;.include "atmega644p.inc"

; PORTA - PINA

.equ    DDRA    , 0x1A
.equ	PORTA	, 0x1B
.equ	PINA	, 0x19
.equ	DATA	, 0x19

; PORTB 
.equ    DDRB    , 0x17
.equ	CTRL	, 0x18

; PORTC
.equ    DDRC    , 0x14
.equ    PORTC   , 0x15
.equ	ADDRH	, 0x15

; PORTD
.equ    DDRD    , 0x11
.equ	ADDRL	, 0x12


.equ    PORTB   , 0x18
.equ    OCR1AL  , 0x2A
.equ    OCR1AH  , 0x2B
.equ    TCNT1L  , 0x2C
.equ    TCNT1H  , 0x2D
.equ	TCCR1A	, 0x2F
.equ    TCCR1B  , 0x2E
.equ	SPL		, 0x3d
.equ	SPH		, 0x3e
.equ	TIFR	, 0x38
.equ    TIMSK   , 0x39
.equ	SPDR	, 0x0F
.equ	SPSR	, 0x0E
.equ	SPCR	, 0x0D 



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

ZL					= 30
ZH					= 31

# Buffer pointer
YL					= 28
YH					= 29

r16					= 16
r17					= 17
r18					= 18
r19					= 19
r20					= 20
r21					= 21
r22					= 22
r23					= 23
# Address
r24					= 24
r25					= 25

r26					= 26
r27					= 27
r28					= 28
r29					= 29
r30					= 30

RAMEND				= 0x085f


SYNC				= 0x00
BUSREQ				= 0x01
OE					= 0x02

STAT_SYNC			= 0x00
STAT_TBORDER		= 0x01
STAT_DRAW			= 0x02
STAT_LBORDER		= 0x03

LINE				= 20
STATUS				= 21


.macro ZERO
	cbi CTRL, SYNC
.endm

.macro BLACK
	sbi CTRL, SYNC
.endm

.macro CLR_ADDR_REGS
	ldi	ZL,	lo8(ROM)
	ldi ZH,	hi8(ROM)
	clr	YL
	clr YH
.endm

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


.include "testimage.inc"


.macro DELAY_4US
    ldi  r19, 21
	dec  r19
    brne .-4
    nop
.endm

.macro DELAY_4_7_US	; 75 cycles
    ldi  r19, 25
	dec  r19
    brne .-4
.endm

.macro DELAY_5US	; 91 cycles
    ldi  r19, 27
	dec  r19
    brne .-4
    nop
.endm

.macro DELAY_5_7_US	; 91 cycles
    ldi  r19, 30
	dec  r19
    brne .-4
    nop
.endm

.macro DELAY_8US
    ldi  r19, 42
	dec  r19
    brne .-4
.endm

.macro DELAY_10US
    ldi  r19, 53
	dec  r19
    brne .-4
    nop
.endm


.macro DELAY_12US
    ldi  r19, 64
	dec  r19
    brne .-4
.endm

.macro DELAY_28US
    ldi  r19, 149
	dec  r19
    brne .-4
    nop
.endm

.macro DELAY_52US
    ldi  r19, 2
	ldi	 r20, 19
	dec  r20
	brne .-4
	dec	 r19
    brne .-16
.endm


main:
; setup
	; stack
	ldi r16,	hi8(RAMEND)
	out SPH,	r16
	ldi r16,	lo8(RAMEND)
	out SPL,	r16

	; ports
	clr r16
	out DDRA,	r16
	
	ldi r16,	0xFF
	out DDRB,	r16
	out DDRC,	r16
	out DDRD,	r16
	; SPI
	ldi r16, 	SPE|MSTR|CPOL
	out SPCR, 	r16
	ldi r16, 	SPI2X
	out SPSR,	r16

	; timer
	ldi r16,	hi8(TIMERS) 
	out OCR1AH,	r16

	ldi r16,	lo8(TIMERS)
	out OCR1AL,	r16

	ldi r16, 	CS10|WGM12
	out TCCR1B,	r16

	ldi r16,	OCIE1A
	out TIMSK,	r16

	clr r16
	out TCNT1H,	r16
	out TCNT1L,	r16

	; clear records
	CLR_ADDR_REGS

	ldi STATUS,	STAT_SYNC

	; clear control lines
	cbi CTRL, 	SYNC
	sbi CTRL,	BUSREQ
	sbi	CTRL,	OE
	sei
; just loop, main functionality works on timer.
main_loop:
	;sbi	PORTB,1
	rjmp main_loop

run_timer:
	cpi	STATUS,STAT_SYNC
	brne rt_2
	rcall do_sync
	ldi STATUS,STAT_TBORDER
	ldi LINE,60
	rjmp rt_end

rt_2:
	cpi STATUS,STAT_TBORDER
	brne rt_3
	rcall do_border
	dec LINE
	brne rt_end
	ldi LINE,192
	ldi STATUS,STAT_DRAW
	CLR_ADDR_REGS
	rjmp rt_end

rt_3:
	cpi STATUS,STAT_DRAW
	brne rt_4
	rcall do_line
	dec LINE
	brne rt_end
	ldi LINE,60
	ldi STATUS,STAT_LBORDER
	rjmp rt_end

rt_4:
	cpi STATUS,STAT_LBORDER
	brne rt_end
	rcall do_border
	dec LINE
	brne rt_end
	ldi STATUS,STAT_SYNC
	
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

.macro LOADBYTE				; 16 cycles 


	out ADDRL,	YL
	out ADDRH,	YH
	cbi	CTRL,	OE
	lpm	r16,	Z+

	add YL,1
	adc YH,1

	nop
	nop
	nop
	nop
	nop

	in	r17,	DATA
	sbi	CTRL,	OE

.endm


.macro DOFILL
	out SPDR, r16
	LOADBYTE
.endm

.macro DOFILLAST
	nop
	out SPDR, r16
	sbi CTRL, 	BUSREQ

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

.endm

do_line:
	cbi CTRL, 	BUSREQ

	ZERO
	DELAY_4US

	BLACK
	DELAY_12US
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

	clr r16
	out SPDR, r16
	ret

no_int:
	reti
