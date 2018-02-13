%{
    void yyerror(char* s);
    #include<stdio.h>
    #include <string.h>
    #include<stdlib.h>
    #include<ctype.h>
    int flag=0;
    extern FILE *yyin;
    extern int yylineno;
    extern char *yytext;
    extern int line;
   
%}
 
%token ID NUM STRING FOR WHILE IF ELSE
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
            | ID
            | NUM 
            | funccall
            | STRING
            ;
 
expr1:      expr
            | assignment
            |  
            ;
            
assignment: ID op3 expr 
            ;
 
declaration:type ID 
            | type assignment
            ;
 
stmtblock:  '{' stmtlist '}'
            ;
 
stmtlist:   stmt stmtlist
            | stmt
            ;
 
argument:  expr
            |expr',' argument
 
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

void yyerror(char *s) {
    flag=1;
    printf(" line %d: %s at: %s \n",line, s,yytext);
}

int main()
{

    yyin=fopen("abc.c","r");

    yyparse();
    if(!flag){
        printf("Parsing Successful\n");
    }
 
}

int yywrap()  
 {  
 return 1;  
 } 