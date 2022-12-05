main: calc.y calc.l
	bison -d -o calcy.c calc.y
	flex -o calcl.c calc.l
	gcc -g -o calc calcy.c calcl.c

clean:
	rm calc calcl.c calcy.c calcy.h

test: main
	./calc < test/test.txt > out.txt 
	diff out.txt test/sol.txt
	rm out.txt
