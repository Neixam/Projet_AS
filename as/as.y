%{
/* tpc-2020-2021.y */
/* Syntaxe du TPC pour le projet d'analyse syntaxique de 2020-2021*/
#include <ctype.h>
#include <stdio.h>
extern int  count_line;
extern int  count_char;
extern char cnt_line[1024];
int     yyerror(char *s)
{
    int     i;

    fprintf(stderr, "%s near line %d, character %d:\n%s", s, count_line, count_char, cnt_line);
    for (i = 0; i < count_char; i++)
        fprintf(stderr, " ");
    fprintf(stderr, "^\n");
    return (0);
}
int     yylex(void);
%}
%token IDENT 
%token TYPE
%token VOID
%token STRUCT
%token READE
%token READC
%token IF
%token ELSE
%token WHILE
%token RETURN
%token PRINT
%token NUM
%token CHARACTER
%token ADDSUB
%token DIVSTAR
%token OR
%token AND
%token EQ
%token ORDER
%%
Prog:  DeclStruct DeclVars DeclFoncts 
    ;
DeclStruct:
       STRUCT IDENT Champs ';'
    |
    ;
Champs:
       '{' DeclVars TYPE Declarateurs ';' '}'
    ;
DeclVars:
       DeclVars TYPE Declarateurs ';' 
    |  DeclVars STRUCT IDENT Declarateurs ';'
    |
    ;
Declarateurs:
       Declarateurs ',' IDENT 
    |  IDENT 
    ;
DeclFoncts:
       DeclFoncts DeclFonct 
    |  DeclFonct 
    ;
DeclFonct:
       EnTeteFonct Corps 
    ;
EnTeteFonct:
       TYPE IDENT '(' Parametres ')' 
    |  VOID IDENT '(' Parametres ')' 
    |  STRUCT IDENT IDENT '(' Parametres ')'
    ;
Parametres:
       VOID 
    |  ListTypVar 
    ;
ListTypVar:
       ListTypVar ',' TYPE IDENT 
    |  TYPE IDENT 
    ;
Corps: '{' DeclVars SuiteInstr '}' 
    ;
SuiteInstr:
       SuiteInstr Instr 
    |
    ;
Instr:
       LValue '=' Exp ';'
    |  READE '(' IDENT ')' ';'
    |  READC '(' IDENT ')' ';'
    |  PRINT '(' Exp ')' ';'
    |  IF '(' Exp ')' Instr 
    |  IF '(' Exp ')' Instr ELSE Instr
    |  WHILE '(' Exp ')' Instr
    |  IDENT '(' Arguments  ')' ';'
    |  RETURN Exp ';' 
    |  RETURN ';' 
    |  '{' SuiteInstr '}' 
    |  ';' 
    ;
Exp :  Exp OR TB 
    |  TB 
    ;
TB  :  TB AND FB 
    |  FB 
    ;
FB  :  FB EQ M
    |  M
    ;
M   :  M ORDER E 
    |  E 
    ;
E   :  E ADDSUB T 
    |  T 
    ;    
T   :  T DIVSTAR F 
    |  F 
    ;
F   :  ADDSUB F 
    |  '!' F 
    |  '(' Exp ')' 
    |  NUM 
    |  CHARACTER
    |  LValue
    |  IDENT '(' Arguments  ')' 
    ;
LValue:
       IDENT 
    ;
Arguments:
       ListExp 
    |
    ;
ListExp:
       ListExp ',' Exp 
    |  Exp 
    ;
%%

int     main(void)
{
    return (yyparse());
}
