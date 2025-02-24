%{
#include "proj.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%%

[a-zA-Z_][a-zA-Z0-9_]*    { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+                    { yylval.str = strdup(yytext); return NUMBER; }
"="                       { return ASSIGN; }
"+"                       { return PLUS; }
"*"                       { return MULT; }
"^"                       { return POW; }
";"                       { return SEMI; }
[ \t\r\n]+                ;  /* TAB,SPACE,NEW line */
.                         { printf("Invalid character: %s\n", yytext); }

%%

int yywrap(void) { 
    return 1; 
}
