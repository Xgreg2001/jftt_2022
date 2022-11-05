%{
#include <stdio.h>
#include <math.h>
#include "stack.h"

int yylex();
int yywrap();

int err = false;
int a, b;
int result;

stack* s;

%}

%x ERROR

%%
<ERROR>.*\n                stack_clear_error(s); stack_clear(s); BEGIN(INITIAL);

^\n                         ;

-?[0-9]+                    stack_push(s, atoi(yytext));

"+"                         {
                            if (!stack_error_occured(s)) {a = stack_pop(s);} else {BEGIN(ERROR);}; 
                            if (!stack_error_occured(s)) {b = stack_pop(s);} else {BEGIN(ERROR);}; 
                            if (!stack_error_occured(s)) {stack_push(s, b + a);} else {BEGIN(ERROR);};
                            }

"-"                         {
                            if (!stack_error_occured(s)) { a = stack_pop(s);} else {BEGIN(ERROR);}; 
                            if (!stack_error_occured(s)) { b = stack_pop(s);} else {BEGIN(ERROR);}; 
                            if (!stack_error_occured(s)) { stack_push(s, b - a);} else {BEGIN(ERROR);};
                            }

"*"                         {
                            if (!stack_error_occured(s)) { a = stack_pop(s);} else {BEGIN(ERROR);}; 
                            if (!stack_error_occured(s)) { b = stack_pop(s);} else {BEGIN(ERROR);}; 
                            if (!stack_error_occured(s)) { stack_push(s, b * a);} else {BEGIN(ERROR);};
                            }

"/"                         {
                            if (!stack_error_occured(s)) { a = stack_pop(s);} else {BEGIN(ERROR);}; 
                            if (!stack_error_occured(s)) { b = stack_pop(s);} else {BEGIN(ERROR);}; 
                            if (!stack_error_occured(s)) { stack_push(s, b / a);} else {BEGIN(ERROR);};
                            }

"^"                         {
                            if (!stack_error_occured(s)) { a = stack_pop(s);} else {BEGIN(ERROR);}; 
                            if (!stack_error_occured(s)) { b = stack_pop(s);} else {BEGIN(ERROR);}; 
                            if (!stack_error_occured(s)) { stack_push(s, pow(b, a));} else {BEGIN(ERROR);};
                            }

"%"                        {
                            if (!stack_error_occured(s)) { a = stack_pop(s);} else {BEGIN(ERROR);}; 
                            if (!stack_error_occured(s)) { b = stack_pop(s);} else {BEGIN(ERROR);}; 
                            if (!stack_error_occured(s)) { stack_push(s, b % a);} else {BEGIN(ERROR);};
                            }

[ \t]+                      ;

\n                          {
                            if (!stack_error_occured(s)) { result = stack_pop(s);} else {BEGIN(ERROR);};
                            if (!stack_error_occured(s)) { if (!stack_is_empty(s)) { fprintf(stderr, "Błąd: nie wystarczająca liczba operatorów\n"); BEGIN(ERROR); }
                            else {printf("= %d\n", result);} } else {BEGIN(ERROR);};
                            }

.                           {
                            fprintf(stderr, "Błąd zły symbol: %s\n", yytext);
                            BEGIN(ERROR);
                            }

%%
int yywrap() {
    return 1;
}

int main() {
    s = stack_create();
    yylex();
    return 0;
}