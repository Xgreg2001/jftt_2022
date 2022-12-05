# calclex.py

from sly import Lexer
import sys


class CalcLexer(Lexer):
    # Set of token names.   This is always required
    tokens = {NUM, ERR, PLUS, MINUS, TIMES, DIVIDE, POW, LPAREN, RPAREN,
              NEWLINE}

    # String containing ignored characters
    ignore = ' \t'
    ignore_comment = r'^#(.|\\\n)*\n'
    ignore_removed_newline = r'\\\n'

    @_(r'\d+')
    def NUM(self, t):
        t.value = int(t.value)
        return t

    # Regular expression rules for tokens
    PLUS = r'\+'
    MINUS = r'-'
    TIMES = r'\*'
    DIVIDE = r'/'
    POW = r'\^'
    LPAREN = r'\('
    RPAREN = r'\)'
    NEWLINE = r'\n'
    ERR = r'.+'
