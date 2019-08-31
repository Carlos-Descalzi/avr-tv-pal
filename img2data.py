import sys
import pygame

def is_white(c):
	return c == (255,255,255,255)

fname = sys.argv[1]
targetname = fname.replace('.png','.inc')

im = pygame.image.load(fname)

data = [0] * 6144

for y in xrange(192):
	for x in xrange(32):
		for xx in xrange(8):
			pixel = im.get_at((x*8+xx,y))
			if is_white(pixel):
				data[y*32 + x]|= 1 << (7-xx)
	
with open(targetname,'w') as f:
	f.writelines(['ROM:\n'])
	while data:
		chunk = data[0:32]
		data = data[32:]
		f.write('.byte %s\n' % ','.join(['0x%02x' % i for i in chunk]) )

