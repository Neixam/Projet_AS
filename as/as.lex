%{
#include "as.tab.h"
#include <string.h>
int     count_line = 1;
int     count_char = 0;
int     last_token;
char    cnt_line[4096] = "";
%}

%option noinput
%option nounput
%x COML COMB STR
%%
^(.*)[\n]               { strcpy(cnt_line, yytext); REJECT; }
[\n].*[\n]              { strcpy(cnt_line, &yytext[1]); REJECT; }
[ ]                     { count_char++; }
int|char                { last_token = yyleng; count_char+= yyleng; return TYPE; }
void                    { last_token = yyleng; count_char+= yyleng; return VOID; }
struct                  { last_token = yyleng; count_char+= yyleng; return STRUCT; }
print                   { last_token = yyleng; count_char+= yyleng; return PRINT; }
readc                   { last_token = yyleng; count_char+= yyleng; return READC; }
reade                   { last_token = yyleng; count_char+= yyleng; return READE; }
return                  { last_token = yyleng; count_char+= yyleng; return RETURN; }
if                      { last_token = yyleng; count_char+= yyleng; return IF; }
else                    { last_token = yyleng; count_char+= yyleng; return ELSE; }
"=="|"!="               { last_token = yyleng; count_char+= yyleng; return EQ; }
while                   { last_token = yyleng; count_char+= yyleng; return WHILE; }
"<="|">="|"<"|">"       { last_token = yyleng; count_char+= yyleng; return ORDER; }
[/][/]                  { count_char+= yyleng; BEGIN COML; }
[/][*]                  { count_char+= yyleng; BEGIN COMB; }
["]                     { count_char+= yyleng; BEGIN STR; }
[0-9]+                  { last_token = yyleng; count_char+= yyleng; return NUM; }
['].[']                 { last_token = yyleng; count_char+= yyleng; return CHARACTER; }
[&][&]                  { last_token = yyleng; count_char+= yyleng; return AND; }
[|][|]                  { last_token = yyleng; count_char+= yyleng; return OR; }
[*]|[/]|[%]             { last_token = yyleng; count_char+= yyleng; return DIVSTAR; }
[+]|-                   { last_token = yyleng; count_char+= yyleng; return ADDSUB; }
[a-zA-Z][a-zA-Z0-9_]*   { last_token = yyleng; count_char+= yyleng; return IDENT; }
.                       { last_token = yyleng; count_char++; return (yytext[0]); }
\n                      { count_char = 0; count_line++; }

<COML>.                 { count_char++; }
<COML>[\n]              { count_char = 0; count_line++; BEGIN INITIAL; }

<COMB>.                 { count_char++; }
<COMB>[\n]              { count_char = 0; count_line++; }
<COMB>[*][/]            { count_char+= yyleng; BEGIN INITIAL; }

<STR>[\n]               { count_char = 0; count_line++; }
<STR>[^"]               { count_char++; }
<STR>["]                { count_char++; BEGIN INITIAL; return CHARACTER; }
%%
