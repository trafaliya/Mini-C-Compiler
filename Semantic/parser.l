%{

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <stdbool.h>

char ty[100];

//int scope=0;

struct symboltable {
   char token[100];
   char type[100]; 
   char ty[100];
   int dim;
   int func;
   char para[1000];
   int nest;
   char pty[1000];
   int nar;
   int arrs;
   int isarr;
 
};

struct symboltable* stable[10000]; 
struct symboltable* stable1[10000];
struct symboltable* ctable[10000];
struct symboltable* dummyItem;
//strcpy (dummyItem->token,"-1");
struct symboltable* item;


int hashCode(char token[100]) {
   int i,x=0,j=strlen(token);
   x=0;
   for(i=j;i>=0;i--)
   {
   	x=x*10+token[i];
   	x%=10000;
   }
   
   return x%10000;
}



void insert(char a[100],char b[100],int c,int func,char p[100],int n, char tt[1000], int q,int w,int e) {


   struct symboltable *item = (struct symboltable*) malloc(sizeof(struct symboltable));
   strcpy(item->type,b);  
   strcpy(item->token,a);
   strcpy(item->ty,ty);
   item->dim=c;
   item->func=func;
   strcpy(item->para,p);
   item->nest=n;
   strcpy(item->pty,tt);
   item->nar=q;
   item->arrs=w;
   item->isarr=e;
   char token[100];
   if (strcmp(a,"printf")==0 || strcmp(a,"scanf")==0)
       strcpy(item->ty,"VOID");
   strcpy(token,item->token);
   int hashIndex = hashCode(token);
   if (stable[hashIndex]!=NULL)
   	if (strcmp(stable[hashIndex]->token,a)==0)
    	return;
   while(stable[hashIndex] != NULL && stable[hashIndex]->token != "-1") {
      
      ++hashIndex;
      hashIndex%=10000;
   }
	
   stable[hashIndex] = item;
   stable1[hashIndex] = item;
}

void delete(int s)
{
   int i = 0;

   struct symboltable *item = (struct symboltable*) malloc(sizeof(struct symboltable));
   for(i = 0; i<10000; i++) {
      
       if (stable[i]!=NULL)  
	   if(stable[i]->nest==s)
           {
               stable[i]=NULL;
           }

   }

}

int gtype(char a[100])
{int i = 0;

   struct symboltable *item = (struct symboltable*) malloc(sizeof(struct symboltable));
   for(i = 0; i<10000; i++) {
      
       if (stable[i]!=NULL && strcmp(stable[i]->token,a)==0)  
       {	   
	   if(strcmp(stable[i]->ty,"INT")==0)
           {
               return 1;
           }
           else if(strcmp(stable[i]->ty,"CHAR")==0)
           {
               return 2;
           }
	   else
		return 3;
       }
   }
}

void checkarg(char a[100],char b[1000], int n)
{
   int i = 0,j;

   struct symboltable *item = (struct symboltable*) malloc(sizeof(struct symboltable));
   for(i = 0; i<10000; i++) {
      
       if (stable[i]!=NULL && strcmp(stable[i]->token,a)==0)  
       {	   
	   if (stable[i]->nar!=n)
           {
		printf("Line %d : Number of arguments do not match\n",line);
                break;
           }
           for (j=0;j<stable[i]->nar;j++)
           {
	               
		if (stable[i]->pty[j]!=b[j])
		    printf("Line %d : Parameter %d type does not match \n",line,j);
           }
       }
   }	

}


int chfunc(char a[100])
{
   int hashIndex = hashCode(a);
   
   while(stable[hashIndex] != NULL) {
      if(strcmp(stable[hashIndex]->token,a)==0) {
         if (stable[hashIndex]->func==1)
         {
             strcpy(prevcall,stable[hashIndex]->ty);
             return 1;
         }
      }
		
      ++hashIndex;
      hashIndex%=10000;
   } 

   return 0;
}

void cinsert(char a[100],char b[100]) {

   
   struct symboltable *item = (struct symboltable*) malloc(sizeof(struct symboltable));
   strcpy(item->type,b);  
   strcpy(item->token,a);
   char token[100];
   strcpy(token,item->token);
   int hashIndex = hashCode(token);
   if (ctable[hashIndex]!=NULL)
   	if (strcmp(ctable[hashIndex]->token,a)==0)
    		return;
   while(ctable[hashIndex] != NULL && ctable[hashIndex]->token != "-1") {
      
      ++hashIndex;
      hashIndex%=10000;
   }
	
   ctable[hashIndex] = item;
}

int search(char a[100])
{
   int hashIndex = hashCode(a);
   
   while(stable[hashIndex] != NULL) {
      if(strcmp(stable[hashIndex]->token,a)==0) {
         if (stable[hashIndex]->nest<=scope)
         {
            strcpy(prevcall,stable[hashIndex]->ty); 
            if (stable[hashIndex]->isarr==1)
		flag2=0;
            return 1;
     	 } 
     }
		
      ++hashIndex;
      hashIndex%=10000;
   } 

   return 0;
}


int cdup(char a[100])
{
   int hashIndex = hashCode(a);
   while(stable[hashIndex] != NULL) {
      if(strcmp(stable[hashIndex]->token,a)==0) {
         if (stable[hashIndex]->nest==scope)
             return 1;
      }
		
      ++hashIndex;
      hashIndex%=10000;
   } 

   return 0;
}


int csearch(char a[100])
{
   int hashIndex = hashCode(a);
   while(ctable[hashIndex] != NULL) {
      if(strcmp(ctable[hashIndex]->token,a)==0) {
         return 1;
      }
		
      ++hashIndex;
      hashIndex%=10000;
   } 

   return 0;
}

void display() {
   int i = 0;
   printf("\nSymbol Table: \n");
   
   for(i = 0; i<10000; i++) {
	
      if(stable1[i] != NULL && stable1[i]->token!="-1")
         printf("%s \t %s \t %s \t %d \t %d \t %s \t %d\n",stable1[i]->token,stable1[i]->type,stable1[i]->ty,stable1[i]->arrs,stable1[i]->func,stable1[i]->para,stable1[i]->nest);

   }
}

void cdisplay() {
   int i = 0;
   printf("\nConstant Table: \n");	
   for(i = 0; i<10000; i++) {
	
      if(ctable[i] != NULL && ctable[i]->token!="-1")
         printf("%s \t %s\n",ctable[i]->token,ctable[i]->type);

   }
}



int i=0;

%}

%option yylineno

letter [a-zA-Z]  
digit[0-9]  
notletter [^a-zA-Z]


%%  
[ \t] ;
[ \n] {line = line + 1;}

\/\/.* ;
\/\*(.*\n)*.*\*\/ ;

"#include <"{letter}*".h>"|"#include<"{letter}*".h>" {return INCLUDE; }

"char" {strcpy(ty,"CHAR"); return CHAR; }
"else" {return ELSE;}
"for" {return FOR;}
"if" {return IF;}
"int" {strcpy(ty,"INT"); return INT;}
"return" {return RETURN;}
"void" {strcpy(ty,"VOID"); return VOID;}
"while"  {return WHILE;}

"&&" {return AND;}
"<" {return LT;}
">" {return GT;}
"<=" {return LEQ;}
">=" {return GEQ;}
"=" {return EQ;}
"==" {return EQEQ;}
"!=" {return NEQ;}
"+=" {return PEQ;}
"-=" {return MEQ;}
"*=" {return MULEQ;}
"/=" {return DEQ;}
"+" {return PLUS;}
"-" {return MINUS;}
"*" {return MULT;}
"/" {return DIV;}
"%" {return MOD;}
"&" {return BAND;}
"||"  {return OR;}
"|" { return BOR;}
"++" {return PLPL;}
"--" {return MIMI;}

({letter}|"_")({letter}|{digit}|"_")* {
                                       char *p=(char *)calloc(strlen(yytext)+1,sizeof(char));
                                       strcpy(p,yytext);
                                       yylval.string=p; 
                                       return ID;
					}

\'.\' {
               char *p=(char *)calloc(strlen(yytext)+1,sizeof(char));
               strcpy(p,yytext);
               yylval.string=p; 
               return LITERAL;
              }                                      

\".*\" {
               char *p=(char *)calloc(strlen(yytext)+1,sizeof(char));
               strcpy(p,yytext);
               yylval.string=p; 
               return STRING;
              }



[1-9][0-9]*|0 {
               yylval.num=atoi(yytext);
               return NUM;
              }

. {return yytext[0];}


%%  
