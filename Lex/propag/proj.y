%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <map>
#include <string>
#include <iostream>
#include <cmath>
#include <set>
using namespace std;

int yylex();
void yyerror(const char *s);

static map<string, string> varMap; // map for key and varibles

bool isNumber(const string& s) {
    if(s.empty()) return false;
    int i = 0;
    if(s[0] == '-') i++;
    for(; i < s.size(); i++) {
        if(!isdigit(s[i])) return false;
    }
    return true;
}

//  recursiveShallow fonksiyon here
string recursiveShallow(const string& var) {
    if(isNumber(var)) return var;
    set<string> seen;
    string current = var;
    while(true) {
        if(isNumber(current)) return current;
        if(seen.count(current)) break;  // Check referance if loop breaks
        seen.insert(current);
        auto it = varMap.find(current);
        if(it == varMap.end()) break;
        current = it->second;
    }
    return current;
}

void assignVar(const string& lhs, const string& rhs) {
    varMap[lhs] = rhs;
}
%}

%union {
    char* str;
}

%token <str> IDENTIFIER
%token <str> NUMBER
%token ASSIGN
%token ADD
%token MINUS
%token MULT
%token DIV
%token POWER
%token SEMI

%type <str> stmt expr id

%%

program:
      /* bos */
    | program stmt
    ;

stmt:
    id ASSIGN expr SEMI {
         string lhs($1);
         string rhs($3);

         // propag and assign save right left
         assignVar(lhs, rhs);

         string output_rhs;
         string token;
         for (size_t i = 0; i < rhs.size(); ++i) {
             char c = rhs[i];
             if(isalnum(c) || c == '_') {
                 token += c;
             } else {
                 if(!token.empty()) {
                     string sub = recursiveShallow(token);
                     // if constant var change method
                     if(isNumber(sub)) {
                         output_rhs += sub;
                     } else {
                         output_rhs += token;
                     }
                     token.clear();
                 }
                 output_rhs += c;
             }
         }
         if(!token.empty()) {
             string sub = recursiveShallow(token);
             if(isNumber(sub)) {
                 output_rhs += sub;
             } else {
                 output_rhs += token;
             }
         }

         cout << lhs << "=" << output_rhs << ";" << endl;

         free($1); 
         free($3);
    }
    ;

expr:
    expr ADD expr {
         string l($1), r($3);
         string lval = recursiveShallow(l);
         string rval = recursiveShallow(r);
         l = isNumber(lval) ? lval : l;
         r = isNumber(rval) ? rval : r;
         string result = l + "+" + r;
         $$ = strdup(result.c_str());
         free($1);
         free($3);
    }
    | expr MINUS expr {
         string l($1), r($3);
         string lval = recursiveShallow(l);
         string rval = recursiveShallow(r);
         l = isNumber(lval) ? lval : l;
         r = isNumber(rval) ? rval : r;
         string result = l + "-" + r;
         $$ = strdup(result.c_str());
         free($1);
         free($3);
    }
    | expr MULT expr {
         string l($1), r($3);
         string lval = recursiveShallow(l);
         string rval = recursiveShallow(r);
         l = isNumber(lval) ? lval : l;
         r = isNumber(rval) ? rval : r;
         string result = l + "*" + r;
         $$ = strdup(result.c_str());
         free($1);
         free($3);
    }
    | expr DIV expr {
         string l($1), r($3);
         string lval = recursiveShallow(l);
         string rval = recursiveShallow(r);
         l = isNumber(lval) ? lval : l;
         r = isNumber(rval) ? rval : r;
         string result = l + "/" + r;
         $$ = strdup(result.c_str());
         free($1);
         free($3);
    }
    | expr POWER expr {
         string l($1), r($3);
         string lval = recursiveShallow(l);
         string rval = recursiveShallow(r);
         l = isNumber(lval) ? lval : l;
         r = isNumber(rval) ? rval : r;
         string result = l + "^" + r;
         $$ = strdup(result.c_str());
         free($1);
         free($3);
    }
    | NUMBER {
         $$ = $1;
      }
    | id {
         $$ = $1;
      }
    ;

id:
    IDENTIFIER {
         $$ = $1;
      }
    ;

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
