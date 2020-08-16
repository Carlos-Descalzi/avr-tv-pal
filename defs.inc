; vim: syntax=asm
;
;  SYNC     PB0 ------------- PA0    A0
;  BUSRQ    PB1 -           - PA1    A1
;  OE       PB2 -           - PA2    A2
;  MODE     PB3 -           - PA3    A3
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
.equ    CTRLI   , 0x16
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
; Mode is: 0 - Text, 1 - Graphics
FLAG_MODE           = 0x08

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
    cbi     CTRL,   PIN_SYNC
.endm
.macro  BLACK
    sbi     CTRL,   PIN_SYNC
.endm
.macro	SET_OE
    cbi		CTRL,	PIN_OE		    ; OE set on external SRAM
.endm
.macro  CLR_OE
    sbi		CTRL,	PIN_OE		    ; OE clear on external SRAM
.endm
.macro  SET_CE
    cbi 	CTRL, 	PIN_BUSREQ	    ; Chip-select set on external SRAM.
.endm
.macro  CLR_CE
    sbi 	CTRL, 	PIN_BUSREQ	    ; Chip-select clear on external SRAM.
.endm

.macro DELAY_4US                    ; Not 4uS exactly, I reduced 3 cycles
    ldi  DELAY, 18
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
