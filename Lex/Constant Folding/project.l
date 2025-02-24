%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
%}

DIGIT      [0-9]
ID         [a-zA-Z_][a-zA-Z0-9_]*
WS         [ \t\r\n]+

%%

{ID}       { 
              yylval.node.str = strdup(yytext); 
              yylval.node.val = 0; 
              return IDENT; 
           }
{DIGIT}+   { 
              yylval.node.val = atoi(yytext); 
              yylval.node.str = NULL; 
              return NUM; 
           }
"="        { return '='; }
";"        { return ';'; }
"+"        { return '+'; }
"-"        { return '-'; }
"*"        { return '*'; }
"^"        { return '^'; } //I added later
"/"        { return '/'; }
"^"        { return '^'; }
"("        { return '('; }
")"        { return ')'; }
{WS}       { /* empt */ }
.          { return yytext[0]; }

%%

int yywrap() {
    return 1;
}
