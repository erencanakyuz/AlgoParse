all: lex yacc compile

lex:
	lex project.l

yacc:
	yacc -d project.y

compile:
	g++ lex.yy.c y.tab.c -o project -lfl

clean:
	rm -f project lex.yy.c y.tab.c y.tab.h
