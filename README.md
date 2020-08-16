# avr-tv-pal

B/W PAL Text and Graphics display from an Atmega32 microcontroller running at 16Mhz, by reading an external RAM or ROM memory.
Graphics mode has a resolution of 256x192 pixels black and white.
Text mode has a resolution of 32x24 characters. Font map is fixed, stored in program memory.

Written in GNU AVR Assembler. 

It uses SPI as shift register to write bits into screen. Every 8th pixel is a bit larger than the others, there is one extra clock cycle there to load the shift register.

![Screenshot](./run-example.jpg)

## Pinout
* Pin 1 - Output (PB0) - Horizontal synchronization
* Pin 2 - Output (PB1) - Bus request, intended for memory contention, active low.
* Pin 3 - Output (PB1) - Output Enable / Chip Select, active low.
* Pin 4 - Input (PB1) - Mode, 0: Text, 1: Graphics.
* PD0 - PD7 - Input: Data Lines D0-D7
* PA0 - PA7 - Output: Address lines A0-A7
* PC0 - PC4 - Output: Address lines A8 - A12

Recommend to put some capacitor on uCU between VCC and GND, given the high usage of IO pins. Here I used 4700uF just because that's what I had around.
