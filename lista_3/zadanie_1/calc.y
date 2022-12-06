%{
#define YYSTYPE long
#define P 1234577
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
int yyerror(char* s);

char* str_concat(char* s1, char* s2);
char* str_create(const char* const s);
char* str_empty();
char* str_clear(char* s);
char* str_from_long(long n);
char* rpn_str;
char* error_str;
long zp_inv(long a, long p);
long zp_mul(long a, long b, long p);
long zp_pow(long a, long b, long p);
long zp_div(long a, long b, long p);
long zp_add(long a, long b, long p);
long zp_sub(long a, long b, long p);
long zp_neg(long a, long p);

%}

%token NUM
%token ERR
%left '+' '-'
%left '*' '/'
%precedence NEG
%right '^'

%%

input:
    %empty
    | input line
;
line: 
    expr '\n' { 
            printf("%s\n", rpn_str);
            printf("= %ld\n", $1);
            rpn_str = str_clear(rpn_str);
        }
    | error '\n' { 
            if (strcmp(error_str, "") == 0)
                error_str = str_concat(error_str, "błąd składniowy");
            printf("Error: %s\n", error_str);
            rpn_str = str_clear(rpn_str);
            error_str = str_clear(error_str);
        }
;
expr: 
    number                          {   char* val = str_from_long($1);
                                        rpn_str = str_concat(rpn_str, val); 
                                        free(val);
                                        rpn_str = str_concat(rpn_str, " "); $$ = $1; }
    | '(' expr ')'                  { $$ = $2; }
    | '-' '(' expr ')' %prec NEG    { rpn_str = str_concat(rpn_str, "~ "); $$ = zp_neg($3, P); }
    | expr '+' expr                 { rpn_str = str_concat(rpn_str, "+ "); $$ = zp_add($1, $3, P); }
    | expr '-' expr                 { rpn_str = str_concat(rpn_str, "- "); $$ = zp_sub($1, $3, P); }
    | expr '*' expr                 { rpn_str = str_concat(rpn_str, "* "); $$ = zp_mul($1, $3, P); }
    | expr '^' expr_pow             { char* val = str_from_long($3);
                                        rpn_str = str_concat(rpn_str, val);
                                        rpn_str = str_concat(rpn_str, " ^ "); 
                                        free(val);
                                        $$ = zp_pow($1, $3, P); }
    | expr '/' expr { 
            rpn_str = str_concat(rpn_str, "/ "); 
            long val = zp_div($1, $3, P);
            if (val == -1) {
                YYERROR;
            }
            $$ = val; 
        }
;
expr_pow:
    number_pow                          { $$ = $1; }
    | '(' expr_pow ')'                  { $$ = $2; }
    | '-' '(' expr_pow ')' %prec NEG    { $$ = zp_neg($3, P - 1); }
    | expr_pow '+' expr_pow             { $$ = zp_add($1, $3, P - 1); }
    | expr_pow '-' expr_pow             { $$ = zp_sub($1, $3, P - 1); }
    | expr_pow '*' expr_pow             { $$ = zp_mul($1, $3, P - 1); }
    | expr_pow '/' expr_pow {
                long val = zp_div($1, $3, P - 1);
                if (val == -1) {
                    YYERROR;
                }
                $$ = val; 
        }
;
number:
    NUM                     { $$ = ($1 % P + P) % P; }
    | '-' number %prec NEG  { $$ = zp_neg($2, P); }
;
number_pow:
    NUM                     { $$ = ($1 % (P - 1) + P - 1) % (P - 1); }
    | '-' number %prec NEG  { $$ = zp_neg($2, P - 1); }
;

%%



long zp_mul(long a, long b, long p){
    return ((a * b) % p + p) % p;
}

// extended euclidean algorithm
long zp_inv(long a, long p) {
    if (a == 0){
        error_str = str_concat(error_str, "0 nie jest odwracalne modulo ");
        char* val = str_from_long(p);
        error_str = str_concat(error_str, val);
        free(val);
        return -1;
    } else if(p % a == 0){
        char* val_a = str_from_long(a);
        char* val_p = str_from_long(p);
        error_str = str_concat(error_str, val_a);
        error_str = str_concat(error_str, " nie jest odwracalne modulo ");
        error_str = str_concat(error_str, val_p);
        free(val_a);
        free(val_p);
        return -1;
    }

    long t = 0, newt = 1;
    long r = p, newr = a;
    long q, tmp;
    while (newr != 0) {
        q = r / newr;
        tmp = newt;
        newt = t - q * newt;
        t = tmp;
        tmp = newr;
        newr = r - q * newr;
        r = tmp;
    }
    if (t < 0) {
        t += p;
    }
    return t;
}

long zp_div(long a, long b, long p) {
    long inv = zp_inv(b, p);
    if (inv == -1)
        return -1;
    return zp_mul(a, inv, p);
}

long zp_pow(long a, long b, long p) {
    long result = 1;
    for (long i = 0; i < b; i++) {
        result = zp_mul(result, a, p);
    }
    return result;
}

long zp_add(long a, long b, long p){
    return (a + b) % p;
}

long zp_sub(long a, long b, long p){
    return (a - b + p) % p;
}

long zp_neg(long a, long p){
    return ((-a % p) + p) % p;
}

char* str_concat(char* s1, char* s2) {
    char* result = (char*) malloc(strlen(s1) + strlen(s2) + 1);
    if (result == NULL) {
        fprintf(stderr, "malloc() failed");
        exit(1);
    }
    strcpy(result, s1);
    free(s1);
    strcat(result, s2);
    return result;
}

char* str_create(const char* const s) {
    char* result = (char*) malloc(strlen(s) + 1);
    if (result == NULL) {
        fprintf(stderr, "malloc() failed");
        exit(1);
    }
    strcpy(result, s);
    return result;
}

char* str_empty() {
    char* result = (char*) malloc(1);
    if (result == NULL) {
        fprintf(stderr, "malloc() failed");
        exit(1);
    }
    result[0] = '\0';
    return result;
}

char* str_clear(char* s) {
    free(s);
    return str_empty();
}

char* str_from_long(long i) {
    char* result = (char*) malloc(12);
    if (result == NULL) {
        fprintf(stderr, "malloc() failed");
        exit(1);
    }
    sprintf(result, "%ld", i);
    return result;
}

int yyerror(char* s){
    return 0;
}

int main()
{
    rpn_str = str_empty();
    error_str = str_empty();
    yyparse();
    free(rpn_str);
    free(error_str);
    return 0;
}