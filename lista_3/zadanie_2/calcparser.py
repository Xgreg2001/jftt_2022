from sly import Parser
from calclex import CalcLexer
import sys

P = 1234577


class CalcParser(Parser):
    # debugfile = 'parser.out'
    # Get the token list from the lexer (required)
    tokens = CalcLexer.tokens

    rpn = ""
    error_message = ""

    precedence = (
        ('left', PLUS, MINUS),
        ('left', TIMES, DIVIDE),
        ('nonassoc', NEG),
        ('right', POW),
    )

    # Grammar rules and actions
    @_('')
    def input(self, p):
        pass

    @_('input line')
    def input(self, p):
        return p.line

    @_('expr NEWLINE')
    def line(self, p):
        if p.expr == -1:
            print(f"Error: {self.error_message}")
            self.error_message = ""
            self.rpn = ""
            return None
        print(self.rpn)
        print(f"= {p.expr}")
        self.rpn = ""
        return p.expr

    @_('error NEWLINE')
    def line(self, p):
        print(f"Error: błąd składniowy")
        self.error_message = ""
        self.rpn = ""
        return None

    @_('number')
    def expr(self, p):
        self.rpn += f"{p.number} "
        return p.number % P

    @_('LPAREN expr RPAREN')
    def expr(self, p):
        return p.expr

    @_('MINUS LPAREN expr RPAREN %prec NEG')
    def expr(self, p):
        self.rpn += f"~ "
        return -p.expr % P

    @_('expr PLUS expr')
    def expr(self, p):
        self.rpn += "+ "
        return (p.expr0 + p.expr1) % P

    @_('expr MINUS expr')
    def expr(self, p):
        self.rpn += "- "
        return (p.expr0 - p.expr1) % P

    @_('expr TIMES expr')
    def expr(self, p):
        self.rpn += "* "
        return (p.expr0 * p.expr1) % P

    @_('expr DIVIDE expr')
    def expr(self, p):
        self.rpn += "/ "
        inv = self.inv(p.expr1, P)
        if inv == -1:
            return -1
        return (p.expr0 * inv) % P

    @_('expr POW expr_pow')
    def expr(self, p):
        if (p.expr_pow == -1):
            return -1
        self.rpn += f"{p.expr_pow} ^ "
        return pow(p.expr, p.expr_pow, P)

    @_('number_pow')
    def expr_pow(self, p):
        return p.number_pow % (P - 1)

    @_('LPAREN expr_pow RPAREN')
    def expr_pow(self, p):
        return p.expr_pow

    @_('MINUS LPAREN expr_pow RPAREN %prec NEG')
    def expr_pow(self, p):
        return -p.expr_pow % (P - 1)

    @_('expr_pow PLUS expr_pow')
    def expr_pow(self, p):
        return (p.expr_pow0 + p.expr_pow1) % (P - 1)

    @_('expr_pow MINUS expr_pow')
    def expr_pow(self, p):
        return (p.expr_pow0 - p.expr_pow1) % (P - 1)

    @_('expr_pow TIMES expr_pow')
    def expr_pow(self, p):
        return (p.expr_pow0 * p.expr_pow1) % (P - 1)

    @_('expr_pow DIVIDE expr_pow')
    def expr_pow(self, p):
        inv = self.inv(p.expr_pow1, P - 1)
        if inv == -1:
            return -1
        return (p.expr_pow0 * inv) % (P - 1)

    @_('NUM')
    def number(self, p):
        return p.NUM % P

    @_('MINUS number %prec NEG')
    def number(self, p):
        return -p.number % P

    @_('NUM')
    def number_pow(self, p):
        return p.NUM % (P - 1)

    @_('MINUS number_pow %prec NEG')
    def number_pow(self, p):
        return -p.number_pow % (P - 1)

    def error(self, tok):
        pass

    # extended euclidean algorithm
    def inv(self, a, p):
        if a == 0:
            self.error_message = f"0 nie jest odwracalne modulo {p}"
            return -1
        if p % a == 0:
            self.error_message = f"{a} nie jest odwracalne modulo {p}"
            return -1

        t = 0
        newt = 1
        r = p
        newr = a
        while newr != 0:
            quotient = r // newr
            (t, newt) = (newt, t - quotient * newt)
            (r, newr) = (newr, r - quotient * newr)
        if t < 0:
            t = t + p
        return t


def main():
    lexer = CalcLexer()
    parser = CalcParser()

    line = sys.stdin.readline()
    while line:
        while line.endswith('\\\n'):
            line = line[:-2] + sys.stdin.readline()
        parser.parse(lexer.tokenize(line))
        line = sys.stdin.readline()


if __name__ == '__main__':
    main()
