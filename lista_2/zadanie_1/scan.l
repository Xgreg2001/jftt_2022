%{
    #include <stdio.h>
    int yylex();
    int yywrap();

    int word_count = 0;
    int line_count = 0;
%}

WHITESPACE [ \t]
%s NEWLINE
%s WORD
%s SPACES

%%
    BEGIN(NEWLINE);

<NEWLINE>{WHITESPACE}*    ;
<NEWLINE>\n               ;
<NEWLINE>.                ECHO; BEGIN(WORD); word_count++; line_count++;

<WORD>{WHITESPACE}        BEGIN(SPACES);
<WORD>\n                  printf("\n"); BEGIN(NEWLINE);

<SPACES>{WHITESPACE}      ;
<SPACES>\n                printf("\n"); BEGIN(NEWLINE);
<SPACES>.                 printf(" "); ECHO; BEGIN(WORD); word_count++;

%%

int yywrap()
{
    fprintf(stderr, "Number of words: %d, Number of lines: %d\n", word_count, line_count);
    return 1;
}

int main()
{
    yylex();
    return 0;
}
