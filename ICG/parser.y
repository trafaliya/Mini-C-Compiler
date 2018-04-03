%{
    void yyerror(char* s);
    #include<stdio.h>
    #include <string.h>
    #include<stdlib.h>
    #include<ctype.h>
    int flag=0,flag1=0,flag2=1,arg=0,targ;
    char futy[100];
    char ty[100],con[100];
    int fflag=0;
    int size=-999;
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
    void binary();
    void intostr(int q);
    void unary(); 
    void final();
    void label();
    void end();
    void cond();
    void push(char x[100]);
    void ifcond();
    void iflabel();
    int line=1,el=-1;
    char lastf[100];
    int top=0,vc=0,lc=0,clc,top1=0;
    struct stack{
	char a[100];
    }s[100];
    struct labelstack{
	int a;
    }st[100];
    struct funclabel{
	char a[100];
	int x;
	}f[100];
   
%}

%expect 2
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
%type <num> expr expr1
%token FOR WHILE IF ELSE
%token INT CHAR VOID INCLUDE RETURN

 
%right EQ PEQ MEQ DEQ MULEQ
%left AND OR BOR BAND
%left EQEQ NEQ
%left LT GT LEQ GEQ
%left PLUS MINUS 
%left DIV MULT MOD 
%right PLPL MIMI

%start first
 
%%
first:      INCLUDE first  
            | INCLUDE states 
            ;

states:     stmt states    
	    |stmt
	    |stmtblock
	    |stmtblock states 
	    
            ;
 
type:       INT {$$="INT";}
            | CHAR {$$="CHAR";}
            | VOID {$$="VOID";}
            ;
 
stmt:       ';'
            |expr';'
            |RETURN';' {}// if (strcmp(futy,"VOID")!=0) printf("The return type of function is not VOID \n"); }
            |RETURN expr';' { if (flag2!=1) printf("Line %d : The return expression is invalid \n",line); 
				else if(flag2==1 && strcmp(futy,"VOID")==0) printf("Line %d : Return type dosen't match function type %s\n",line,futy); printf("PUSH RESULT\n"); }
            |ifstmt
            |whileloop
            |forloop
            |funcdef
            |assignment';' 
            |declaration';'
            ;


 
expr:       expr OR{push("||");} expr {if($1==1 && $4==1)$$=1; else $$=-1;}
            | expr AND{push("&&"); } expr  {if($1==1 && $4==1)$$=1; else $$=-1;binary();}
            | expr BOR{push("|"); } expr  {if($1==1 && $4==1)$$=1; else $$=-1;binary();}
            | expr BAND{push("&"); } expr  {if($1==1 && $4==1)$$=1; else $$=-1;binary();}
            | expr EQEQ{push("=="); } expr  {if($1==1 && $4==1)$$=1; else $$=-1;binary();}
	    | expr NEQ{push("!="); } expr  {if($1==1 && $4==1)$$=1; else $$=-1;binary();}
            | expr GEQ{push(">="); } expr  {if($1==1 && $4==1)$$=1; else $$=-1;binary();}
            | expr LEQ{push("<="); } expr  {if($1==1 && $4==1)$$=1; else $$=-1;binary();}
            | expr LT{push("<"); } expr   {if($1==1 && $4==1)$$=1; else $$=-1;binary();}
            | expr GT{push(">"); } expr    {if($1==1 && $4==1)$$=1; else $$=-1; binary();}
            | expr MINUS{push("-"); } expr{if($1==1 && $4==1)$$=1; else $$=-1;binary();}
            | expr PLUS{push("+"); } expr {if($1==1 && $4==1)$$=1; else $$=-1;binary();}
            | expr DIV{push("/"); } expr  {if($1==1 && $4==1)$$=1; else $$=-1;binary();}
            | expr MULT{push("*"); } expr {if($1==1 && $4==1)$$=1; else $$=-1;binary();}
            | MIMI{push("-1"); } expr      {if($3==1)$$=1; else $$=-1;unary();}
            | PLPL{push("+1"); } expr      {if($3==1)$$=1; else $$=-1;unary();}
            | expr PLPL{push("+1"); }      {if($1==1)$$=1; else $$=-1;unary();}
            | expr MIMI{push("-1"); }      {if($1==1)$$=1; else $$=-1;unary();}
            | MINUS{push("-"); } expr     {if($3==1)$$=1; else $$=-1;unary();}
            | '('expr')'     {if($2==1)$$=1; else $$=-1;}
            | ID  {
		   push($1);
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
                   size=$1;
                   char *a=(char *)malloc(sizeof(char)*z);
                   while (y>0)
		   {
			a[z-1]=(y%10)+'0';
			y=y/10;
			z--;
		   }
		   if ($1==0)
		   {
			push("0");			
			cinsert("0","INT constant");
		   }	
		   else
		   {
			push(a);                        
			cinsert(a,"INT constant");}
		   } 
            | funccall {if (strcmp(prevcall,"INT")==0)  $$=1;  else $$=-1; flag2=0; push("RESULT");}
            | LITERAL {$$=1;flag1=0;flag2=1;}
            | STRING {$$=-1;flag1=0; cinsert($1,"CHAR constant");flag2=1;}
            ;
 
expr1:      expr {$$=$1;}
            | assignment {$$=-1;}
            |  %empty {$$=1;}
            ;
            
assignment: ID{push($1); } EQ {push("="); } expr {if (!search($1)) printf("Line %d : %s not declared \n",line,$1); if ($5!=1) printf ("Line %d : Expression is not of type INT \n",line); final(); }
            |ID{push($1); } PEQ{push("="); } expr {if (!search($1)) printf("Line %d : %s not declared \n",line,$1);if ($5!=1) printf ("Line %d : Expression is not of type INT \n",line);final();} 
            |ID{push($1); } MEQ{push("="); } expr {if (!search($1)) printf("Line %d : %s not declared \n",line,$1);if ($5!=1) printf ("Line %d : Expression is not of type INT \n",line);final();} 
            |ID{push($1); } DEQ{push("="); } expr {if (!search($1)) printf("Line %d : %s not declared \n",line,$1);if ($5!=1) printf ("Line %d : Expression is not of type INT \n",line);final();} 
            |ID{push($1); } MULEQ{push("="); } expr {if (!search($1)) printf("Line %d : %s not declared \n",line,$1);if ($5!=1) printf ("Line %d : Expression is not of type INT \n",line);final();} 
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
            |ID'['expr']' EQ expr      {
		        if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                        if ($3!=1)
				printf("Line %d : Expression is not INT \n",line);
                        if (size!=-999)
			{
				if (size<1)
					printf("Line %d : Array size is less than 1 \n",line);
				else
					insert($1,"Identifier",0,0,"",scope,"",0,size,1);
				size=-999;} } 
            |ID'['expr']' EQ expr',' dec1     {
		        if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                        if ($3!=1)
				printf("Line %d : Expression is not INT \n",line);
                        if (size!=-999)
			{
				if (size<1)
					printf("Line %d : Array size is less than 1 \n",line);
				else
					insert($1,"Identifier",0,0,"",scope,"",0,size,1);
				size=-999;} } 
            |ID'['expr']'       {
		        if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                        if ($3!=1)
				printf("Line %d : Expression is not INT \n",line);
                        if (size!=-999)
			{
				if (size<1)
					printf("Line %d : Array size is less than 1 \n",line);
				else
					insert($1,"Identifier",0,0,"",scope,"",0,size,1);
				size=-999;} }      
            |assignment1
	    |ID',' dec1 {if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                       else
		                insert($1,"Identifier",0,0,"",scope,"",0,0,0);}

            |ID'['expr']'',' dec1 {
		        if (cdup($1))
				printf("Line %d : Redeclaration of identifier \n",line);
                        if ($3!=1)
				printf("Line %d : Expression is not INT \n",line);
                        if (size!=-999)
			{
				if (size<1)
					printf("Line %d : Array size is less than 1 \n",line);
				else
					insert($1,"Identifier",0,0,"",scope,"",0,size,1);
				size=-999;} }  
	    |assignment1',' dec1
            ;
 
 
stmtblock:  '{'{scope++; } stmtlist '}'{scope--; delete(scope+1); }
            ;
 
stmtlist:   stmt stmtlist
            | stmt
	    |stmtblock
	    |stmtblock stmtlist
            ;
 
argumentlist:	argument',' {arg++;} argumentlist
				| argument  {arg++;}
				;
				

argument:	BAND ID  						        {if (!search($2))  printf("Line %d : %s not declared \n",line,$2); printf("PUSH PARAM %s\n",$2);}
			| ID     						{if (!search($1))  printf("Line %d : %s not declared \n",line,$1); if (gtype($1)==1) aty[arg]= 'I'; if (gtype($1)==2) aty[arg]= 'C'; if (gtype($1)==3) aty[arg]= 'V';printf("PUSH PARAM %s\n",$1);}
			| NUM    						{aty[arg] = 'I'; printf("PUSH PARAM %d\n",$1);}
			| STRING 						{aty[arg] = 'C'; printf("PUSH PARAM %s\n",$1);}
			| LITERAL						{aty[arg] = 'C';printf("PUSH PARAM %s\n",$1);}
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
		     printf("POP %s\n",$2);
		    }        
	;
 
paramlist:  parameter',' paramlist
            | parameter
            | %empty
            ;
 
funccall:   ID'('')'{
		     if (!search($1))  printf("Line %d : %s not declared \n",line,$1);  
                     else 
                         if (!chfunc($1))  printf("Line %d : ID is not a function \n",line);printf("CALL %s,0\n",$1);
		     checkarg($1,"",0);
						}
            | ID'('argumentlist')'{if (!search($1))  printf("Line %d : %s not declared \n",line,$1);  
                               else if (!chfunc($1))  printf("Line %d : ID is not a function \n",line);
                               else
				{
					checkarg($1,aty,arg);
					targ=arg;
					arg=0;
				}
                               printf("CALL %s,%d\n",$1,targ);}
            ;
 
funcdef:    type ID{printf("\nFUNC BEGIN %s: \n",$2);} '('  paramlist')'{ fflag=1; strcpy(lastf,$2); strcpy(ty,$1); strcpy(futy,$1); if (cdup($2)) printf("Line %d : Redeclaration of identifer \n",line); else insert($2,"Function",0,1,para,scope,pty,count,0,0);  count=0;int i;memset(para, 0, sizeof para); }  stmtblock {printf("FUNC END\n\n"); }
            ;

subroutine:  %empty {label(); }
             ;

sub1:	%empty {cond(); }
	;

sub2:	%empty {ifcond(); }
	;

sub3:	%empty {iflabel(); }
	;

whileloop:  WHILE subroutine '(' expr sub1 ')' stmt {if($4!=1)printf("Line %d : While expression is not of type INT \n",line);  end();}
            | WHILE subroutine '(' expr sub1 ')' stmtblock {if($4!=1)printf("Line %d : While expression is not of type INT \n",line); end();}
            ;
 
forloop:    FOR  '(' expr1 ';' subroutine expr1 sub1 ';' expr1 ')' {if($6!=1)printf("Line %d : For expression is not of type INT \n",line-1); }stmt {end();} 
            | FOR '(' expr1 ';' subroutine expr1 sub1';' expr1 ')' {if($6!=1)printf("Line %d : For expression is not of type INT \n",line-1); }stmtblock {end();}
            ;
 
ifstmt:     IF '(' expr sub2 ')' stmtblock sub3 elsestmt {if($3!=1)printf("Line %d : If expression is not of type INT \n",line); if (el!=-1) printf("\nLABEL %d: \n",el); el=-1;}
            | IF '(' expr sub2 ')' stmt sub3 elsestmt {if($3!=1)printf("Line %d : If expression is not of type INT \n",line); if (el!=-1) printf("\nLABEL %d: \n",el); el=-1;}
            ;

elsestmt:    
            ELSE  stmtblock 
            | ELSE stmt
            | %empty
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
    yyin=fopen("test3.c","r");
    yyparse();
    if (!fflag && !flag)
    {
        printf("Line %d : No functions were defined \n",line-1);
    }
    if (strcmp(lastf,"main")!=0 && !flag)
    {
        printf("Line %d : main wasn't the last function \n",line-1);
    }
    if(!flag){
        printf("\nParsing Successful\n");
    }
    else
        printf("\nParsing Unsuccessful \n");
    display();
    cdisplay();
 
}

int yywrap()  
 {  
 return 1;  
 } 
