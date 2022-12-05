#! /bin/bash

python calcparser.py < test/test.txt > out.txt
diff out.txt test/sol.txt

