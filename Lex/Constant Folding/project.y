%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>  // For pow function

void yyerror(const char *s);
int yylex(void);
%}

%union {
    struct {
        int val;
        char* str;
    } node;
}

%token <node> IDENT NUM
%type <node> statement expr term factor

%%

program:
      program statement
    | /* emp */
    ;

statement:
      IDENT '=' expr ';'   
        { 
          printf("%s = ", $1.str);
          if ($3.str == NULL) {
              // Constants
              printf("%d;\n", $3.val);
          } else {
              // Nonconstants
              printf("%s;\n", $3.str);
              free($3.str);
          }
          free($1.str);
        }
    | IDENT ';' // Undef variables
        {
          printf("%s;\n", $1.str);
          free($1.str);
        }
    ;

expr:
      expr '+' term        
        { 
          if ($1.str == NULL && $3.str == NULL) { 
              $$.val = $1.val + $3.val; 
              $$.str = NULL;
          } else { 
              char *left, *right;
              if ($1.str)
                  left = $1.str;
              else
                  asprintf(&left, "%d", $1.val);

              if ($3.str)
                  right = $3.str;
              else
                  asprintf(&right, "%d", $3.val);

              asprintf(&$$.str, "%s + %s", left, right);
              $$.val = 0;

              if (!$1.str) free(left);
              if (!$3.str) free(right);
          }
        }
    | expr '-' term        
        { 
          if ($1.str == NULL && $3.str == NULL) { 
              $$.val = $1.val - $3.val; 
              $$.str = NULL;
          } else { 
              char *left, *right;
              if ($1.str)
                  left = $1.str;
              else
                  asprintf(&left, "%d", $1.val);

              if ($3.str)
                  right = $3.str;
              else
                  asprintf(&right, "%d", $3.val);

              asprintf(&$$.str, "%s - %s", left, right);
              $$.val = 0;

              if (!$1.str) free(left);
              if (!$3.str) free(right);
          }
        }
    | term                  
        { $$ = $1; }
    ;

term:
      term '*' factor      
        { 
          if ($1.str == NULL && $3.str == NULL) { 
              $$.val = $1.val * $3.val; 
              $$.str = NULL;
          } else { 
              char *left, *right;
              if ($1.str)
                  left = $1.str;
              else
                  asprintf(&left, "%d", $1.val);

              if ($3.str)
                  right = $3.str;
              else
                  asprintf(&right, "%d", $3.val);

              asprintf(&$$.str, "%s * %s", left, right);
              $$.val = 0;

              if (!$1.str) free(left);
              if (!$3.str) free(right);
          }
        }
    | term '/' factor      
        { 
          if ($1.str == NULL && $3.str == NULL && $3.val != 0) { 
              $$.val = $1.val / $3.val; 
              $$.str = NULL;
          } else { 
              char *left, *right;
              if ($1.str)
                  left = $1.str;
              else
                  asprintf(&left, "%d", $1.val);

              if ($3.str)
                  right = $3.str;
              else
                  asprintf(&right, "%d", $3.val);

              asprintf(&$$.str, "%s / %s", left, right);
              $$.val = 0;

              if (!$1.str) free(left);
              if (!$3.str) free(right);
          }
        }
    | factor               
        { $$ = $1; }
    ;

factor:
      factor '^' factor    
        { 
          if ($1.str == NULL && $3.str == NULL) { 
              $$.val = (int)pow($1.val, $3.val); 
              $$.str = NULL;
          } else { 
              char *left, *right;
              if ($1.str)
                  left = $1.str;
              else
                  asprintf(&left, "%d", $1.val);

              if ($3.str)
                  right = $3.str;
              else
                  asprintf(&right, "%d", $3.val);

              asprintf(&$$.str, "%s ^ %s", left, right);
              $$.val = 0;

              if (!$1.str) free(left);
              if (!$3.str) free(right);
          }
        }
    | '(' expr ')'         
        { $$ = $2; }
    | NUM                  
        { $$.val = $1.val; $$.str = NULL; }
    | IDENT                
        { $$.str = strdup($1.str); $$.val = 0; free($1.str); }
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}
