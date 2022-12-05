%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include "calcy.h"
#define P 1234577

extern int yylex();
%}


%%
[ \t]  ;
^#(.|\\\n)*\n ;
\\\n   ;
[[:digit:]]+ { 
    yylval = atol(yytext); 
    return NUM; 
}
"(" {return '(';}
")" {return ')';}
"+" {return '+';}
"-" {return '-';}
"*" {return '*';}
"/" {return '/';}
"^" {return '^';}
\n  {return '\n';}
.   {return ERR;}

