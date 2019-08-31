# avr-tv-pal
B/W PAL Signal generation from an Atmega32 microcontroller running at 16Mhz.

Written in GNU AVR Assembler. Right now the code renders an image stored in Program Memory, but the intention is to read from an external RAM or EPROM, if you look at the code is using ports to handle addressing and data read, although is not yet working at all.

It uses SPI as shift register to write bits into screen. The output resolution is 256x192 pixels in 1BPP. Every 8th pixel is a bit larger than the others, there is one extra clock cycle there to load the shift register.

![Screenshot](./run-example.jpg)
