%{

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <stdbool.h>
#include "y.tab.h"
struct symboltable {
   char token[100];
   char type[100];  
};

struct symboltable* stable[10000]; 
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

struct symboltable *search(char token[100]) {
   
   char hashIndex = hashCode(token);  
   while(stable[hashIndex] != NULL) {
	
      if(stable[hashIndex]->token == token)
         return stable[hashIndex]; 
      ++hashIndex;
      hashIndex%=10000;
		
   }        
	
   return NULL;        
}

void insert(char a[100],char b[100]) {

   printf("%s - %s\n",a,b);
   struct symboltable *item = (struct symboltable*) malloc(sizeof(struct symboltable));
   strcpy(item->type,b);  
   strcpy(item->token,a);
   char token[100];
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
}

void cinsert(char a[100],char b[100]) {

   printf("%s - %s\n",a,b);
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

struct symboltable* delete(struct symboltable* item) {
   char token[100];
   strcpy(token,item->token);
   int hashIndex = hashCode(token);
   while(stable[hashIndex] != NULL) {
      if(stable[hashIndex]->token == token) {
         struct symboltable* temp = stable[hashIndex]; 
         strcpy(stable[hashIndex]->token,"-1"); 
         return temp;
      }
		
      //go to next cell
      ++hashIndex;
   		hashIndex%=10000;
   }      
	
   return NULL;        
}

void cdisplay1(char a[1000],char b[1000])
{
	
	printf("%s - %s\n",a,b);
}

int i=0,line=1;

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

"char" {return CHAR;}
"else" {return ELSE;}
"for" {return FOR;}
"if" {return IF;}
"int" {return INT;}
"return" {return RETURN;}
"void" {return VOID;}
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

({letter}|"_")({letter}|{digit}|"_")* {insert(yytext,"Identifier"); return ID;}

\".*\"|\'.*\' {cinsert(yytext,"Character constant"); return STRING;}

[1-9][0-9]*|0 {cinsert(yytext, "Integer constant"); return NUM;}

. {printf("yyy a%sb xxx \n",yytext); return yytext[0];}


%%  

