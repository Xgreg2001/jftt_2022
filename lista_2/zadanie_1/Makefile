[FLAGS] = -Wall -Wextra -Werror -pedantic -std=c11
scan: scan.c
	gcc -o scan scan.c $(FLAGS)

scan.c: scan.l
	flex -o scan.c scan.l

clean:
	rm scan.c scan sols/l2z1a.sol.txt sols/l2z1b.sol.txt

test: scan
	./scan < test/l2z1a.txt > sols/l2z1a.sol.txt
	./scan < test/l2z1b.txt > sols/l2z1b.sol.txt
	sha1sum sols/*.txt