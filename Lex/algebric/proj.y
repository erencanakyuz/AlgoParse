%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <map>
#include <string>
#include <iostream>
using namespace std;

// I defined function prototypes here
int yylex();
void yyerror(const char *s);

// map for variables for chaning 
static map<string, string> varMap;


// check if it is a number for seprate letters and numbers
bool isNumber(const string& s) {
    if(s.empty()) return false;
    int i = 0;
    if(s[0] == '-') i++;
    for(; i < s.size(); i++) {
        if(!isdigit(s[i])) return false; 
    }
    return true;
}
// assign the value to map
string valueOf(const string& var) {
    if(varMap.find(var) == varMap.end()) return var;
    string val = varMap[var];
    if(val == "?") return var;
    if(isNumber(val)) return val;
    if(val == var) return var;
    return valueOf(val);
}
// assign the value to map
void assignVar(const string& lhs, const string& rhs) {
    if(isNumber(rhs)) {
        varMap[lhs] = rhs;
    } else {
        string val = valueOf(rhs);
        varMap[lhs] = val;
    }
}
%}

/* priority not necessary if bug occurs */
%left PLUS
%left MULT
%right POW

%union {
    char* str;
}
// lex tokens better with name
%token <str> IDENTIFIER
%token <str> NUMBER
%token PLUS
%token POW
%token ASSIGN
%token MULT
%token SEMI

%type <str> stmt expr id

%%
program:
      /* emp */
    | program stmt
    ;

stmt:
    id ASSIGN expr SEMI {
         string lhs($1);
         string rhs($3);

         
         assignVar(lhs, rhs);

         // simpl algorithm deleted notify
         if(lhs == rhs) {
             cout << "(deleted)" << endl;
         }
         else {
             cout << lhs << " = " << rhs << ";" << endl;
         }

         free($1);
         free($3);
    }
    ;

id:
    IDENTIFIER { $$ = $1; }
;
expr:
    expr PLUS expr {
         string l = valueOf(string($1));
         string r = valueOf(string($3));

         if(l == "0") {
             $$ = strdup(r.c_str());
         }
         else if(r == "0") {
             $$ = strdup(l.c_str());
         }
         else if(isNumber(l) && isNumber(r)) {
             long long a = atoll(l.c_str());
             long long b = atoll(r.c_str());
             long long sum = a + b;
             string res = to_string(sum);
             $$ = strdup(res.c_str());
         }
         else {
             string result = l + "+" + r;
             $$ = strdup(result.c_str());
         }
         free($1); free($3);
    }
    | expr POW expr {
         string l = valueOf(string($1));
         string r = valueOf(string($3));

         // general opt for all variables: x^2 --> x * x (IMPORTANT PART)
         if(isNumber(r) && atoll(r.c_str()) == 2) {
             string result = l + "*" + l;
             $$ = strdup(result.c_str());
         }
         else if(isNumber(l) && isNumber(r)) {
             long long base = atoll(l.c_str());
             long long exp = atoll(r.c_str());
             long long res = 1;
             for(int i = 0; i < exp; i++) res *= base;
             string result = to_string(res);
             $$ = strdup(result.c_str());
         }
         else {
             string result = l + "^" + r;
             $$ = strdup(result.c_str());
         }

         free($1); free($3);
    }
    | expr MULT expr {
         string l = valueOf(string($1));
         string r = valueOf(string($3));

         if(l == "0" || r == "0") {
             $$ = strdup("0");
         }
         else if(l == "1") {
             $$ = strdup(r.c_str());
         }
         else if(r == "1") {
             $$ = strdup(l.c_str());
         }
         else if(isNumber(l) && isNumber(r)) {
             long long a = atoll(l.c_str());
             long long b = atoll(r.c_str());
             long long m = a * b;
             string res = to_string(m);
             $$ = strdup(res.c_str());
         }
         else {
             string result = l + "*" + r;
             $$ = strdup(result.c_str());
         }

         free($1); free($3);
    }
    | NUMBER {
         $$ = $1;
    }
    | id {
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
