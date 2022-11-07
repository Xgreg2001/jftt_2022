[FLAGS] = -Wall -Wextra -Werror -pedantic -std=c11
scan: scan.c stack.c stack.h
	gcc $(FLAGS) -lm -o scan scan.c stack.c stack.h

scan.c: scan.l
	flex -o scan.c scan.l

clean:
	rm -f scan.c scan err.txt sol.txt

test: scan
	./scan < test/test.txt > sol.txt 2> err.txt
	diff err.txt test/err.txt 
	diff sol.txt test/sol.txt