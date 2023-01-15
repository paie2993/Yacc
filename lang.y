%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(char *s);

int last = 0;
int *productions;
%}

%union
{
    char* string;
    int   integer;
}

%token MULTI_CHAR_OPERATOR
%token BOOL_MULTI_CHAR_OPERATOR

%token DECL_KEYWORD
%token TYPE

%token IF
%token THEN
%token ELSE
%token ENDIF
%token WHILE
%token DO
%token FOR
%token TO
%token READ_KEYWORD
%token WRITE_KEYWORD

%token BOOLEAN
%token IDENTIFIER
%token CHAR
%token STRING
%token INTEGER

%%

program     : statement                             { productions[last++] = 1; }        
            ;
statement   : simple                                { productions[last++] = 2; }        
            | compound                              { productions[last++] = 3; } 
            ;
compound    : '{' sequence '}'                      { productions[last++] = 4; }
            ;
sequence    : statement optionally                  { productions[last++] = 5; }
            ;
optionally  :                                       { productions[last++] = 6; }
            | sequence                              { productions[last++] = 7; }
            ;

simple      : decl                                  { productions[last++] = 8; }
            | assign                                { productions[last++] = 9; }            
            | io                                    { productions[last++] = 10; }            
            | flow                                  { productions[last++] = 11; }            
            ;

decl        : DECL_KEYWORD IDENTIFIER ':' type      { productions[last++] = 12; }
            ;
type        : TYPE arrType                          { productions[last++] = 13; }
            ;
arrType     :                                       { productions[last++] = 14; }
            | '[' INTEGER ']'                       { productions[last++] = 15; }
            ;

assign      : IDENTIFIER '=' iAssign                { productions[last++] = 16; }
            ;
iAssign     : BOOLEAN                               { productions[last++] = 17; }
            | STRING                                { productions[last++] = 18; }
            | CHAR                                  { productions[last++] = 19; }
            | exp                                   { productions[last++] = 20; }
            ;
exp         : term                                  { productions[last++] = 21; }
            | exp iExp                              { productions[last++] = 22; }
            ;
iExp        : '+' term                              { productions[last++] = 23; }
            | '-' term                              { productions[last++] = 24; }
            ;
term        : factor                                { productions[last++] = 25; }
            | term iTerm                            { productions[last++] = 26; }
            ;
iTerm       : '*' factor                            { productions[last++] = 27; }
            | '/' factor                            { productions[last++] = 28; }
            | '%' factor                            { productions[last++] = 29; }
            ;
factor      : '(' exp ')'                           { productions[last++] = 30; }
            | IDENTIFIER                            { productions[last++] = 31; }
            | INTEGER                               { productions[last++] = 32; }
            | arrayAccess                           { productions[last++] = 33; }
            ;
arrayAccess : IDENTIFIER '[' exp ']'                { productions[last++] = 34; }
            ;

io          : read                                  { productions[last++] = 35; }
            | write                                 { productions[last++] = 36; }
            ;
read        : READ_KEYWORD '(' iRead                { productions[last++] = 37; }
            ;
iRead       : IDENTIFIER ')'                        { productions[last++] = 38; }
            | arrayAccess ')'                       { productions[last++] = 39; }
            ;
write       : WRITE_KEYWORD '(' iWrite              { productions[last++] = 40; }
            ;
iWrite      : BOOLEAN ')'                           { productions[last++] = 41; }
            | STRING ')'                            { productions[last++] = 42; }
            | CHAR ')'                              { productions[last++] = 43; }
            | exp ')'                               { productions[last++] = 44; }
            ;



flow        : cond                                  { productions[last++] = 45; }
            | while                                 { productions[last++] = 46; }
            | for                                   { productions[last++] = 47; }
            ;

cond        : IF '(' bExp ')' THEN statement optElse ENDIF  { productions[last++] = 48; }
            ;
optElse     :                                       { productions[last++] = 49; }
            | ELSE statement                        { productions[last++] = 50; }
            ; 
bExp        : BOOLEAN iBExp                         { productions[last++] = 51; }                         
            | exp iRel                              { productions[last++] = 52; }                              
            ;
iBExp       :                                       { productions[last++] = 53; }
            | BOOL_MULTI_CHAR_OPERATOR BOOLEAN      { productions[last++] = 54; }
            ;
iRel        : '<' exp                               { productions[last++] = 55; }
            | '>' exp                               { productions[last++] = 56; }
            | MULTI_CHAR_OPERATOR exp               { productions[last++] = 57; }
            ;

while       : WHILE '(' bExp ')' DO statement       { productions[last++] = 58; }
            ;

for         : FOR '(' exp TO exp ')' DO statement   { productions[last++] = 59; }
            ;



%%

void yyerror(char *s) {
    printf("%s\n", s);
}

int main(const int argc, const char **argv) {
    productions = (int *) malloc(1000 * sizeof(int));
    yyparse();
    for (int i = last - 1; i >= 0; i--) {
        printf("%d\n", productions[i]);
    }
    free(productions);
}