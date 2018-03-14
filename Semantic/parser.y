%{
    void yyerror(char* s);
    #include<stdio.h>
    #include <string.h>
    #include<stdlib.h>
    #include<ctype.h>
    int flag=0;
    char ty[100];

    void cinsert(char a[100],char b[100]);
    void insert(char a[100],char b[100]);
   
%}

%union
{
	int num;
	char *string;
}

%token <string> ID
%token <string> STRING
%token <num> NUM
%token FOR WHILE IF ELSE
%token INT CHAR VOID INCLUDE RETURN
%token PLPL MIMI PEQ MEQ DEQ MULEQ 
 
%right EQ
%left AND OR BOR BAND
%left LEQ GEQ EQEQ NEQ LT GT PLUS MINUS DIV MULT MOD
 
%start first
 
%%
first:      INCLUDE first  
            | INCLUDE states 
            ;

states:     stmt states
            | stmt
            ;
 
type:       INT
            | CHAR
            | VOID
            ;
 
stmt:       ';'
            |expr';'
            |RETURN';'
            |RETURN expr';'
            |ifstmt
            |whileloop
            |forloop
            |funcdef
            |funccall';'
            |assignment';'
            |declaration';'
            ;
 
com:        GEQ
            | LEQ
            | LT
            | GT
            ;
 
comeq:      EQ
            | NEQ
            ;
 
op1:        MULT
            | DIV
            ;
 
op2:        PLUS
            | MINUS
            ;
 
unary:      PLPL
            | MIMI
            ;

op3:        PEQ
            | EQ
            | MULEQ
            | MEQ
            | DEQ
            ;
 
expr:       expr OR expr
            | expr AND expr
            | expr BOR expr
            | expr BAND expr
            | expr com expr
            | expr comeq expr
            | expr op2 expr
            | expr op1 expr
            | unary expr
            | expr unary
            | MINUS expr
            | '('expr')'
            | ID  {
		   
		   if (search($1))
                   {
                       printf("%s was found \n",$1);
                   }
		   else
		       printf("%s not declared \n",$1);
			      }
            | NUM {}//cinsert($1,"INT constant");} 
            | funccall
            | STRING {cinsert($1,"CHAR constant");}
            ;
 
expr1:      expr
            | assignment
            |  
            ;
            
assignment: ID op3 expr {
			 insert($1,"Identifier");} 
            ;
 
declaration:type dec1 
            ;

dec1:       ID        {
		       insert($1,"Identifier");}           
            |assignment
	    |ID',' dec1 {printf("%s was put\n",$1);
                         insert($1,"Identifier");} 
	    |assignment',' dec1
            ;
 
 
stmtblock:  '{' stmtlist '}'
            ;
 
stmtlist:   stmt stmtlist
            | stmt
            ;
 
argument:  expr
           |expr',' argument
	   | BAND ID
           | BAND ID',' argument
           ;
 
parameter:  type ID
            ;
 
paramlist:  parameter',' paramlist
            | parameter
            |
            ;
 
funccall:   ID'('')'
            | ID'('argument')'
            ;
 
funcdef:    type ID'('paramlist')' stmtblock
            ;
 
whileloop:  WHILE '(' expr ')' stmt
            | WHILE '(' expr ')' stmtblock
            ;
 
forloop:    FOR '(' expr1 ';' expr1 ';' expr1 ')' stmt
            | FOR '(' expr1 ';' expr1 ';' expr1 ')' stmtblock
            ;
 
ifstmt:     IF '(' expr ')' stmtblock elsestmt
            | IF '(' expr ')' stmt elsestmt
            ;

elsestmt:   ELSE ifstmt
            | ELSE stmtblock
            | ELSE stmt
            |  
            ;
%%
#include "lex.yy.c"
void yyerror(char *s) {
    flag=1;
    printf("Line %d: %s before: %s \n",line, s,yytext);
}

int main()
{

    yyin=fopen("functions.c","r");
    yyparse();

    if(!flag){
        printf("Parsing Successful\n");
    }
    else
        printf("Parsing Unsuccessful \n");
    display();
    cdisplay();
 
}

int yywrap()  
 {  
 return 1;  
 } 
