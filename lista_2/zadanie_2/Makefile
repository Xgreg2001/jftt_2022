[FLAGS] = -Wall -Wextra -Werror -pedantic -std=c11
scan: scan.c
	gcc -o scan scan.c $(FLAGS)

scan.c: scan.l
	flex -o scan.c scan.l

clean:
	rm -f scan.c scan sol.py

test: scan
	./scan < test/test.py > sol.py
	python sol.py