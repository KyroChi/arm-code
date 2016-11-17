ASFLAGS=-g

all: rpncalc

lab12: rpncalc.o hexi.o hexo.o peputils.a
	ld -o rpncalc rpncalc.o hexi.o hexo.o peputils.a

lab12.o: rpncalc.s
	as $(ASFLAGS) -o rpncalc.o rpncalc.s

clean:
	rm -f *.o rpncalc
