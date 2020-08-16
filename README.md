# avr-tv-pal

B/W PAL Text and Graphics display from an Atmega32 microcontroller running at 16Mhz.
Graphics mode has a resolution of 256x192 pixels black and white.
Text mode has a resolution of 32x24 characters. Font map is fixed, stored in program memory.

Written in GNU AVR Assembler. 

It uses SPI as shift register to write bits into screen. Every 8th pixel is a bit larger than the others, there is one extra clock cycle there to load the shift register.

![Screenshot](./run-example.jpg)
