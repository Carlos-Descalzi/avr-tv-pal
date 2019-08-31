ASM=avr-as
LD=avr-ld
MCU=atmega32
OPTLEVEL=5
#CFLAGS=-mmcu=$(MCU) -D -g
CFLAGS=-mmcu=$(MCU)
LDFLAGS=
ASFLAGS=-mmcu=$(MCU)
OBJCOPY=avr-objcopy
OBJDUMP=avr-objdump
FORMAT=ihex
OBJS=main.o
INC=testimage.inc
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

%.inc: %.png
	python img2data.py $< 
	
burn: all
	avrdude -c usbasp -p $(MCU) -U lfuse:w:0xff:m -U hfuse:w:0xdf:m -U flash:w:tvasm.hex 

