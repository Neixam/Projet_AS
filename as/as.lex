%{
#include "as.tab.h"
#include <string.h>
int     count_line = 1;
int     count_char = 0;
char    cnt_line[4096] = "";
%}

%option noinput
%option nounput
%x COML COMB STR
%%
^(.*)[\n]               { strcpy(cnt_line, yytext); REJECT; }
[\n].*[\n]              { strcpy(cnt_line, &yytext[1]); REJECT; }
[ ]                     { count_char++; }
int|char                { return TYPE; count_char+= yyleng; }
void                    { return VOID; count_char+= yyleng; }
struct                  { return STRUCT; count_char+= yyleng; }
print                   { return PRINT; count_char+= yyleng; }
readc                   { return READC; count_char+= yyleng; }
reade                   { return READE; count_char+= yyleng; }
return                  { return RETURN; count_char+= yyleng; }
if                      { return IF; count_char+= yyleng; }
else                    { return ELSE; count_char+= yyleng; }
"=="|"!="               { return EQ; count_char+= yyleng; }
while                   { return WHILE; count_char+= yyleng; }
"<="|">="|"<"|">"       { return ORDER; count_char+= yyleng; }
[/][/]                  { BEGIN COML; count_char+= yyleng; }
[/][*]                  { BEGIN COMB; count_char+= yyleng; }
["]                     { BEGIN STR; count_char++; }
[0-9]+                  { return NUM; count_char+= yyleng; }
['].[']                 { return CHARACTER; count_char+= yyleng; }
[&][&]                  { return AND; count_char+= yyleng; }
[|][|]                  { return OR; count_char+= yyleng; }
[*]|[/]|[%]             { return DIVSTAR; count_char++; }
[+]|-                   { return ADDSUB; count_char++; }
[a-zA-Z][a-zA-Z0-9_]*   { return IDENT; count_char+= yyleng; }
.                       { return (yytext[0]); count_char++; }
\n                      { count_char = 0; count_line++; }

<COML>.                 { count_char++; }
<COML>[\n]              { count_char = 0; count_line++; BEGIN INITIAL; }

<COMB>.                 { count_char++; }
<COMB>[\n]              { count_char = 0; count_line++; }
<COMB>[*][/]            { BEGIN INITIAL; count_char+= yyleng; }

<STR>[\n]               { count_char = 0; count_line++; }
<STR>[^"]               { count_char++; }
<STR>["]                { BEGIN INITIAL; return CHARACTER; count_char++; }
%%
