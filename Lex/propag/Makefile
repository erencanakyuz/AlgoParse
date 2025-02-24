all: proj

proj: proj.tab.c lex.yy.c
	g++ -o proj proj.tab.c lex.yy.c -lfl

proj.tab.c proj.tab.h: proj.y
	bison -d proj.y

lex.yy.c: proj.l proj.tab.h
	flex proj.l

clean:
	rm -f proj.tab.c proj.tab.h lex.yy.c proj
