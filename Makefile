ASM=avr-as
LD=avr-ld
MCU=atmega32
CFLAGS=-mmcu=$(MCU)
LDFLAGS=
ASFLAGS=-mmcu=$(MCU)
OBJCOPY=avr-objcopy
OBJDUMP=avr-objdump
FORMAT=ihex
OBJS=main.o fontmap.o
PORT=/dev/ttyS5

all: tvasm lst

tvasm: tvasm.hex

lst: tvasm.lst

clean:
	rm -rf *.hex *.elf *.o *.lst

%.hex: %.elf
	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@

%.lst: %.elf
	$(OBJDUMP) -h -S $< > $@

tvasm.elf: $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o tvasm.elf

%.o: %.asm $(INC)
	$(ASM) $(CFLAGS) $< -o $@
	
burn: all
	avrdude -c usbasp -p $(MCU) -U lfuse:w:0xff:m -U hfuse:w:0xdf:m -U flash:w:tvasm.hex 

