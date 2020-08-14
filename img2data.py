#!/usr/bin/python3
"""
A small program to convert a bitmap containing font map into assembly code.
The data is saved in the following format:
    character 0 - row 0
    character 1 - row 0
    character 2 - row 0
    character 3 - row 0
    character 4 - row 0
    character 5 - row 0
    character 6 - row 0
    character 7 - row 0
    character 0 - row 1
    ....
    character 255 - row 7
In this way I use low byte to index the character and high byte to index the character row.
"""
import sys
import pygame

def is_white(c):
	return c == (255,255,255,255)


def image_to_array(im):
	print('Reading')
	data = [0] * 2048


	for cy in range(16):
		for cx in range(16):
			cnum = cy * 16 + cx

			for y in range(8):
				row = cy*8+y

				for x in range(8):

					pixel = im.get_at((cx*8+x,row))

					if is_white(pixel):
						data[cnum * 8 +y ] |= 1 << (7-x)


	return data

def save(data, targetname):
	print('Saving')
	with open(targetname,'w') as f:
		f.writelines(['.global FONTMAP\nFONTMAP:\n'])
		while data:
			chunk = data[0:256]
			data = data[256:]
			f.write('.byte %s\n' % ','.join(['0x%02x' % i for i in chunk]) )

def flip(array):
	print('Flipping')
	result = [0] * 2048

	for i in range(256):
		for j in range(8):
			result[j * 256 + i] = array[i * 8 + j]

	return result

if __name__ == '__main__':
	fname = sys.argv[1]
	targetname = fname.replace('.png','.asm')
	im = pygame.image.load(fname)

	data = image_to_array(im)
	data = flip(data)
	save(data, targetname)

