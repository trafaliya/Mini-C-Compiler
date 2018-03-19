%{
    void yyerror(char* s);
    #include<stdio.h>
    #include <string.h>
    #include<stdlib.h>
    #include<ctype.h>
    int flag=0,flag1=0,flag2=1,arg=0;
    char futy[100];
    char ty[100];
    int scope=0,count=0;
    void delete(int s);
    char prevcall[1000];
    void cinsert(char a[100],char b[100]);
    int chfunc(char a[100]);
    int cdup(char a[100]);
    void insert(char a[100],char b[100],int c,int func,char p[100],int n, char tt[1000], int q, int w,int e);
    char pty[100],aty[100];
    char para[1000];
    void checkarg(char a[100],char b[1000], int n);
    int search(char a[100]);
    int gtype(char a[100]);
    int yylex();
    int line=1;
   
%}

%union
{
	int num;
	char *string;
}



%token <string> ID
%token <string> STRING
%token <string> LITERAL
%token <num> NUM
%type <string> type
%type <num> expr
%token FOR WHILE IF ELSE
%token INT CHAR VOID INCLUDE RETURN
%right PLPL MIMI  
 
%right EQ PEQ MEQ DEQ MULEQ
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
 
type:       INT {$$="INT";}
            | CHAR {$$="CHAR";}
            | VOID {$$="VOID";}
            ;
 
stmt:       ';'
            |expr';'
            |RETURN';' {}// if (strcmp(futy,"VOID")!=0) printf("The return type of function is not VOID \n"); }
            |RETURN expr';' { if (flag2!=1) printf("Line %d : The return expression is invalid \n",line); }
            |ifstmt
            |whileloop
            |forloop
            |funcdef
            |funccall';'
            |assignment';' 
            |declaration';'
            ;


 
expr:       expr OR expr {if($1==1 && $3==1)$$=1; else $$=-1;}
            | expr AND expr  {if($1==1 && $3==1)$$=1; else $$=-1;}
            | expr BOR expr  {if($1==1 && $3==1)$$=1; else $$=-1;}
            | expr BAND expr  {if($1==1 && $3==1)$$=1; else $$=-1;}
            | expr GEQ expr  {if($1==1 && $3==1)$$=1; else $$=-1;}
            | expr LEQ expr  {if($1==1 && $3==1)$$=1; else $$=-1;}
            | expr LT expr   {if($1==1 && $3==1)$$=1; else $$=-1;}
            | expr GT expr    {if($1==1 && $3==1)$$=1; else $$=-1; }
            | expr MINUS expr{if($1==1 && $3==1)$$=1; else $$=-1;}
            | expr PLUS expr {if($1==1 && $3==1)$$=1; else $$=-1;}
            | expr DIV expr  {if($1==1 && $3==1)$$=1; else $$=-1;}
            | expr MULT expr {if($1==1 && $3==1)$$=1; else $$=-1;}
            | MIMI expr      {if($2==1)$$=1; else $$=-1;}
            | PLPL expr      {if($2==1)$$=1; else $$=-1;}
            | expr PLPL      {if($1==1)$$=1; else $$=-1;}
            | expr MIMI      {if($1==1)$$=1; else $$=-1;}
            | MINUS expr     {if($2==1)$$=1; else $$=-1;}
            | '('expr')'     {if($2==1)$$=1; else $$=-1;}
            | ID  {
		   
		   if (!search($1))
		       printf("Line %d : %s not declared \n",line,$1);
                   if (strcmp(prevcall,"INT")==0)  $$=1;  else $$=-1;
			      }
            | NUM {$$=1;flag1=1;flag2=1;int x=$1,y=$1,z=0; 
                   while(x>0)
                   {
			x=x/10;
			z++;
                   }
                   char *a=(char *)malloc(sizeof(char)*z);
                   while (y>0)
		   {
			a[z-1]=(y%10)+'0';
			y=y/10;
			z--;
		   }
		   if ($1==0)
			cinsert("0","INT constant");
		   else
                        cinsert(a,"INT constant");} 
            | funccall {if (strcpy(prevcall,"INT")==0)  $$=1;  else $$=-1; flag2=0;}
            | LITERAL {$$=1;flag1=0;flag2=1;}
            | STRING {$$=-1;flag1=0; cinsert($1,"CHAR constant");flag2=1;}
            ;
 
expr1:      expr
            | assignment
            |  
            ;
            
assignment: ID EQ expr {if (!search($1)) printf("Line %d : %s not declared \n",line,$1); if ($3!=1) printf ("Line %d : Expression is not of type INT \n",line);}
            |ID PEQ expr {if (!search($1)) printf("Line %d : %s not declared \n",line,$1);if ($3!=1) printf ("Line %d : Expression is not of type INT \n",line);} 
            |ID MEQ expr {if (!search($1)) printf("Line %d : %s not declared \n",line,$1);if ($3!=1) printf ("Line %d : Expression is not of type INT \n",line);} 
            |ID DEQ expr {if (!search($1)) printf("Line %d : %s not declared \n",line,$1);if ($3!=1) printf ("Line %d : Expression is not of type INT \n",line);} 
            |ID MULEQ expr {if (!search($1)) printf("Line %d : %s not declared \n",line,$1);if ($3!=1) printf ("Line %d : Expression is not of type INT \n",line);} 
            ;

assignment1: ID EQ expr {
		        if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                       else
		                insert($1,"Identifier",0,0,"",scope,"",0,0,0); if ($3!=1) printf ("Line %d : Expression is not of type INT \n",line);} 
	     |ID PEQ expr {
		        if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                       else
		                insert($1,"Identifier",0,0,"",scope,"",0,0,0); if ($3!=1) printf ("Line %d : Expression is not of type INT \n",line);} 
 
	     |ID MEQ expr {
		        if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                       else
		                insert($1,"Identifier",0,0,"",scope,"",0,0,0); if ($3!=1) printf ("Line %d : Expression is not of type INT \n",line);} 

	     |ID DEQ expr {
		        if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                       else
		                insert($1,"Identifier",0,0,"",scope,"",0,0,0); if ($3!=1) printf ("Line %d : Expression is not of type INT \n",line);}

	     |ID MULEQ expr {
		        if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                       else
		                insert($1,"Identifier",0,0,"",scope,"",0,0,0); if ($3!=1) printf ("Line %d : Expression is not of type INT \n",line);}  
            ;
 
declaration:type dec1 
            ;

dec1:       ID        {
		        if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                       else
		                insert($1,"Identifier",0,0,"",scope,"",0,0,0);}
	    |ID'['NUM']'       {
		        if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                        else
		                insert($1,"Identifier",0,0,"",scope,"",0,$3,1);
                        if ($3<1)
				printf("Line %d : Array size is less than 1 \n",line);}           
            |assignment1
	    |ID',' dec1 {if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                       else
		                insert($1,"Identifier",0,0,"",scope,"",0,0,0);}
	    |ID'['NUM']'',' dec1 {if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                       else
		                insert($1,"Identifier",0,0,"",scope,"",0,$3,1);
		       if ($3<1)
				printf("Line %d : Array size is less than 1 \n",line);}  
	    |assignment1',' dec1
            ;
 
 
stmtblock:  '{'{scope++; } stmtlist '}'{scope--; delete(scope+1);}
            ;
 
stmtlist:   stmt stmtlist
            | stmt
            ;
 
argumentlist:	argument',' {arg++;} argumentlist
				| argument  {arg++;}
				;
				

argument:	BAND ID  						        {if (!search($2))  printf("Line %d : %s not declared \n",line,$2);}
			| ID     						{if (!search($1))  printf("Line %d : %s not declared \n",line,$1); if (gtype($1)==1) aty[arg]= 'I'; if (gtype($1)==2) aty[arg]= 'C'; if (gtype($1)==3) aty[arg]= 'V';}
			| NUM    						{aty[arg] = 'I';}
			| STRING 						{aty[arg] = 'C';}
			| LITERAL						{aty[arg] = 'C';}
			;
 
parameter:  type ID {char t[100];
                     strcpy(t,$1);
                     pty[count]=$1[0];
                     count++;
		     strcat(t," ");
		     strcat(t,$2);
		     insert($2,"Identifier",0,0,"",scope+1,"",0,0,0);
		     if (strcmp($1,"VOID")==0)
		         printf ("Line %d : Parameter cannot be void \n",line);
                     else
		     {
		         if (strcmp(para,"")==0)
			    strcpy(para,t);
		         else
			    {
			    strcat(para,",");
			    strcat(para,t);
			    }
		     }
		    }        
	;
 
paramlist:  parameter',' paramlist
            | parameter
            |
            ;
 
funccall:   ID'('')'{if (!search($1))  printf("Line %d : %s not declared \n",line,$1);  
                     else 
                         if (!chfunc($1))  printf("Line %d : ID is not a function \n",line);}
            | ID'('argumentlist')'{if (!search($1))  printf("Line %d : %s not declared \n",line,$1);  
                               else if (!chfunc($1))  printf("Line %d : ID is not a function \n",line);
                               else
				{
					checkarg($1,aty,arg);
					arg=0;
				}
                              }
            ;
 
funcdef:    type ID'('paramlist')'{ strcpy(ty,$1); strcpy(futy,$1); if (cdup($2)) printf("Line %d : Redeclaration of function \n",line); else insert($2,"Function",0,1,para,scope,pty,count,0,0);  count=0;int i;memset(para, 0, sizeof para);} stmtblock
            ;
 
whileloop:  WHILE '(' expr ')' stmt {if($3!=1)printf("Line %d : While expression is not of type INT \n",line); }
            | WHILE '(' expr ')' stmtblock {if($3!=1)printf("Line %d : While expression is not of type INT \n",line); }
            ;
 
forloop:    FOR '(' expr1 ';' expr1 ';' expr1 ')' stmt
            | FOR '(' expr1 ';' expr1 ';' expr1 ')' stmtblock
            ;
 
ifstmt:     IF '(' expr ')' stmtblock elsestmt {if($3!=1)printf("Line %d : If expression is not of type INT \n",line); }
            | IF '(' expr ')' stmt elsestmt {if($3!=1)printf("Line %d : If expression is not of type INT \n",line); }
            ;

elsestmt:   ELSE ifstmt 
            | ELSE stmtblock
            | ELSE stmt
            |  
            ;
%%
#include "lex.yy.c"

/*char* get(int a)
{
	char x[100];
	if (a==1)
		strcpy(x,"INT");
	if (a==2)
		strcpy(x,"CHAR");
	if (a==3)
		strcpy(x,"VOID");
	return x;
      

}*/
void yyerror(char *s) {
    flag=1;
    printf("Line %d: %s before: %s \n",line, s,yytext);
}

int main()
{
    //{ strcpy(ty,$1); insert($2,"Identifier",0,1,para,scope);}
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
