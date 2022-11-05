[FLAGS] = -Wall -Wextra -Werror -pedantic -std=c11
scan: scan.c stack.c stack.h
	gcc $(FLAGS) -lm -o scan scan.c stack.c stack.h

scan.c: scan.l
	flex -o scan.c scan.l

clean:
	rm scan.c scan