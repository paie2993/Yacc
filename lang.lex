%option noyywrap

%{
#include "lang.tab.h"
%}

separator					:|\(|\)|\[|\]|\{|\}
singleCharOperator			\+|-|\*|\/|%|=|<|>|!		
boolMultipleCharOperator	&&|\|\|
multipleCharOperator		<=|>=|==|!=

type						Integer|Character|String|Boolean
decl_keyword				val
read_keyword				read
write_keyword				write
if							if
then						then
else						else
endif						endif
while						while
do                          do
for							for
to							to

identifier					_?[a-zA-Z][a-zA-Z0-9]*
boolean 					true|false
char						'[a-zA-Z0-9]'
string						\"[a-zA-Z0-9 ]*\"
integer						0|[+-]?[1-9][0-9]*


%%

	void printMatch(const char* format) {
		fprintf(yyout, format, yytext);	
	}

\n+							
[ \t]+					
{boolMultipleCharOperator}  {yylval.string = yytext; return BOOL_MULTI_CHAR_OPERATOR;}
{multipleCharOperator}      {yylval.string = yytext; return MULTI_CHAR_OPERATOR;}						
{singleCharOperator}        {yylval.string = yytext; return *yytext;}
{separator}  			   	{yylval.string = yytext; return *yytext;}

{type}						{yylval.string = yytext; return TYPE;}
{decl_keyword}				{yylval.string = yytext; return DECL_KEYWORD;}

{read_keyword}				{yylval.string = yytext; return READ_KEYWORD;}
{write_keyword}				{yylval.string = yytext; return WRITE_KEYWORD;}

{if}						{yylval.string = yytext; return IF;}
{then}						{yylval.string = yytext; return THEN;}
{else}						{yylval.string = yytext; return ELSE;}
{endif}						{yylval.string = yytext; return ENDIF;}

{while}						{yylval.string = yytext; return WHILE;}
{do}						{yylval.string = yytext; return DO;}

{for}						{yylval.string = yytext; return FOR;}
{to}						{yylval.string = yytext; return TO;}

{boolean}					{yylval.string = yytext; return BOOLEAN;}
{identifier}				{yylval.string = yytext; return IDENTIFIER;}
{char}						{yylval.string = yytext; return CHAR;}
{string}					{yylval.string = yytext; return STRING;}
{integer}					{yylval.string = yytext; return INTEGER;}

%%


