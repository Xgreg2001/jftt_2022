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
<ERROR>.*\n                 stack_clear_error(s); stack_clear(s); BEGIN(INITIAL);

^\n                         ;

-?[0-9]+                    stack_push(s, atoi(yytext));

"+"                         {
                            a = stack_pop(s);
                            if (stack_error_occured(s)){
                                BEGIN(ERROR);
                            } else {
                                b = stack_pop(s);
                                if (stack_error_occured(s)){
                                    BEGIN(ERROR);
                                } else {
                                    stack_push(s, a + b);
                                }
                            }
                            }

"-"                         {
                            a = stack_pop(s);
                            if (stack_error_occured(s)){
                                BEGIN(ERROR);
                            } else {
                                b = stack_pop(s);
                                if (stack_error_occured(s)){
                                    BEGIN(ERROR);
                                } else {
                                    stack_push(s, b - a);
                                }
                            }
                            }

"*"                         {
                            a = stack_pop(s);
                            if (stack_error_occured(s)){
                                BEGIN(ERROR);
                            } else {
                                b = stack_pop(s);
                                if (stack_error_occured(s)){
                                    BEGIN(ERROR);
                                } else {
                                    stack_push(s, a * b);
                                }
                            }
                            }

"/"                         {
                            a = stack_pop(s);
                            if (stack_error_occured(s)){
                                BEGIN(ERROR);
                            } else {
                                b = stack_pop(s);
                                if (stack_error_occured(s)){
                                    BEGIN(ERROR);
                                } else {
                                    if (a == 0){
                                        fprintf(stderr, "B????d: dzielenie przez 0\n");
                                        BEGIN(ERROR);
                                    } else {
                                        stack_push(s, b / a);
                                    }
                                }
                            }
                            }

"^"                         {
                            a = stack_pop(s);
                            if (stack_error_occured(s)){
                                BEGIN(ERROR);
                            } else {
                                b = stack_pop(s);
                                if (stack_error_occured(s)){
                                    BEGIN(ERROR);
                                } else {
                                    stack_push(s, pow(b, a));
                                }
                            }
                            }

"%"                        {
                            a = stack_pop(s);
                            if (stack_error_occured(s)){
                                BEGIN(ERROR);
                            } else {
                                b = stack_pop(s);
                                if (stack_error_occured(s)){
                                    BEGIN(ERROR);
                                } else {
                                    if (a == 0){
                                        fprintf(stderr, "B????d: dzielenie przez 0\n");
                                        BEGIN(ERROR);
                                    } else {
                                        stack_push(s, b % a);
                                    }
                                }
                            }
                            }

[ \t]+                      ;

\n                          {
                            result = stack_pop(s);
                            if (stack_error_occured(s)){
                                stack_clear_error(s); 
                                stack_clear(s);
                            } else if (!stack_is_empty(s)){
                                fprintf(stderr, "B????d: za ma??a liczba operator??w\n");
                                stack_clear_error(s); 
                                stack_clear(s);
                            } else {
                                printf("= %d\n", result);
                            }
                            }

.                           {
                            fprintf(stderr, "B????d: z??y symbol: %s\n", yytext);
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