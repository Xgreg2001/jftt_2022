%{
#include <stdio.h>

int yywrap();
int yylex();
%}

%s FIRSTLINE
%s BASE
%s STRING1
%s STRING2
%s DOCSTRING1
%s DOCSTRING2

%%

    BEGIN(FIRSTLINE);

<FIRSTLINE>^#!.*\n    ECHO; BEGIN(BASE);

<BASE>[ \t]*#.*\n      ;
<BASE>\"\"\"     ECHO; BEGIN(DOCSTRING1);
<BASE>"'''"      ECHO; BEGIN(DOCSTRING2);
<BASE>\"         ECHO; BEGIN(STRING1);
<BASE>\'         ECHO; BEGIN(STRING2);

<DOCSTRING1>\"\"\" ECHO; BEGIN(BASE);
<DOCSTRING2>"'''"   ECHO; BEGIN(BASE);
<STRING1>\"         ECHO; BEGIN(BASE);
<STRING2>\'         ECHO; BEGIN(BASE);

%%

int yywrap() { 
    return 1; 
}

int main() { 
    return yylex(); 
}