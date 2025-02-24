%{
#include "proj.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%%

[0-9]+                  { 
                            yylval.str = strdup(yytext); 
                            return NUMBER; 
                        }
[a-zA-Z_][a-zA-Z0-9_]*  { 
                            yylval.str = strdup(yytext); 
                            return IDENTIFIER; 
                        }
"="                     { return ASSIGN; }
"+"                     { return ADD; }
"-"                     { return MINUS; }
"*"                     { return MULT; }
"/"                     { return DIV; }
"^"                     { return POWER; }
";"                     { return SEMI; }
[ \t\r\n]+              { /* ignore space,new line,tab */ }
.                       { return yytext[0]; }

%%

int yywrap(void) { 
    return 1; 
}
