all: bmp2chr

test: bmp2chr
	./bmp2chr test.bmp test.chr
	cl65 -t none -o test.o -c test.asm
	ld65 -o test.nes --config test.cfg --obj test.o

bmp2chr: bmp2chr.c
	clang -o bmp2chr bmp2chr.c

clean:
	rm -f bmp2chr test.o test.nes
