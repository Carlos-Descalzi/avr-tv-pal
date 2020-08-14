; vim: syntax=asm
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

;;;
; Ports
;
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

.equ    MCUCR   , 0x35
;;;

;;;
; Registers
;
; Work register
.equ    r16     , 16
; Used by delays
.equ    DELAY1  , 20
; Counters
.equ    ROWIDX  , 21
.equ    LINE    , 22
.equ    STATUS  , 23
; Constants to work around adiw issue
.equ    CZERO   , 24
.equ    CONE    , 25
; Unused
.equ    XL      , 26
.equ    XH      , 27
; Buffer pointer
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
.macro ZERO
    cbi CTRL, PIN_SYNC
.endm

.macro BLACK
    sbi CTRL, PIN_SYNC
.endm


.macro DELAY_4US
    ldi  DELAY1, 21
    dec  DELAY1
    brne .-4
    nop
.endm

.macro DELAY_4_7_US	; 75 cycles
    ldi  DELAY1, 25
    dec  DELAY1
    brne .-4
.endm

.macro DELAY_5US	; 91 cycles
    ldi  DELAY1, 27
    dec  DELAY1
    brne .-4
    nop
.endm

.macro DELAY_5_7_US	; 91 cycles
    ldi  DELAY1, 30
    dec  DELAY1
    brne .-4
    nop
.endm

.macro DELAY_8US
    ldi  DELAY1, 42
    dec  DELAY1
    brne .-4
.endm

.macro DELAY_10US
    ldi  DELAY1, 53
    dec  DELAY1
    brne .-4
    nop
.endm


.macro DELAY_12US
    ldi  DELAY1, 64
    dec  DELAY1
    brne .-4
.endm

.macro DELAY_28US
    ldi  DELAY1, 149
    dec  DELAY1
    brne .-4
    nop
.endm

.macro NOP4
    nop
    nop
    nop
    nop
.endm
;;;
