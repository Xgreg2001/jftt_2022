%{
#include <stdio.h>

int yylex();
int yywrap();

int delete_docs = 1;
%}

%s BASE
%s INCLUDE
%s SINGLE_LINE_COMMENT
%s MULTI_LINE_COMMENT
%s STRING
%s SINGLE_LINE_DOC
%s MULTI_LINE_DOC


%%

    BEGIN(BASE);

<BASE>\"                                                    ECHO; BEGIN(STRING);
<BASE>[ \t]*\/(\\\n)?\/                                     BEGIN(SINGLE_LINE_COMMENT);
<BASE>[ \t]*\/(\\\n)?\*                                     BEGIN(MULTI_LINE_COMMENT);
<BASE>"#include <"                                          ECHO; BEGIN(INCLUDE);
<BASE>[ \t]*((\/(\\\n)?\/(\\\n)?\/)|(\/(\\\n)?\/(\\\n)?!))  if (!delete_docs) ECHO; BEGIN(SINGLE_LINE_DOC);
<BASE>[ \t]*((\/(\\\n)?\*(\\\n)?\*)|(\/(\\\n)?\*(\\\n)?!))  if (!delete_docs) ECHO; BEGIN(MULTI_LINE_DOC);

<STRING>\"                      ECHO; BEGIN(BASE);

<SINGLE_LINE_COMMENT>\\\n       ;
<SINGLE_LINE_COMMENT>\n         BEGIN(BASE);
<SINGLE_LINE_COMMENT>.          ;

<SINGLE_LINE_DOC>\\\n           if (!delete_docs) ECHO;
<SINGLE_LINE_DOC>\n             if (!delete_docs) ECHO; BEGIN(BASE);
<SINGLE_LINE_DOC>.              if (!delete_docs) ECHO;

<MULTI_LINE_COMMENT>\*\/        BEGIN(BASE);
<MULTI_LINE_COMMENT>\n          ;
<MULTI_LINE_COMMENT>.           ;

<MULTI_LINE_DOC>\*\/            if (!delete_docs) ECHO; BEGIN(BASE);
<MULTI_LINE_DOC>\n              if (!delete_docs) ECHO;
<MULTI_LINE_DOC>.               if (!delete_docs) ECHO;

<INCLUDE>">"                    ECHO; BEGIN(BASE);


%%

int yywrap() { 
    return 1; 
} 
int main(int argc, char** argv) {
    if (argc > 1 && strcmp(argv[1], "-d") == 0) {
        delete_docs = 0;
    }
    return yylex(); 
}