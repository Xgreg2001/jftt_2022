[FLAGS] = -Wall -Wextra -Werror -pedantic -std=c11
scan: scan.c
	gcc -o scan scan.c $(FLAGS)

scan.c: scan.l
	flex -o scan.c scan.l

clean:
	rm -f scan.c scan without_docs.cpp with_docs.cpp

run: scan
	./scan -d < test/test.cpp > with_docs.cpp
	./scan < test/test.cpp > without_docs.cpp