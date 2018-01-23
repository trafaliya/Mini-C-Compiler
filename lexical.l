%{

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <stdbool.h>

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

int i=0;

%}

letter [a-zA-Z]  
digit[0-9]  
notletter [^a-zA-Z]

%%  
{digit}+("E"("+"|"-")?{digit}+)? {cinsert(yytext,"Real Number");}

{digit}+"."{digit}+("E"("+"|"-")?{digit}+)? {cinsert(yytext,"Floating point number");}

"\""(.*)"\"" {cinsert(yytext,"Character constant");}


"#include <"{letter}*".h>"|"#include<"{letter}*".h>" {cdisplay1(yytext,"Include statement"); }

"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while" {cdisplay1(yytext,"Keyword");}

({letter}|"_")({letter}|{digit})* {insert(yytext,"Identifier");}

"&&"|"<"|">"|"<="|">="|"="|"+"|"-"|"?"|"*"|"/"|"%"|"&"|"||" {cdisplay1(yytext,"Operators");}

"{"|"["|"(" {cdisplay1(yytext,"Opening bracket"); }

"}"|"]"|")" {cdisplay1(yytext,"Closing bracket");}

"#"|"'"|"."|"\""|"," {cdisplay1(yytext,"Special characters");}

"\;" {cdisplay1(yytext,"Delimiter");}

"%d"|"%s"|"%c"|"%f"|"%e" {cdisplay1(yytext,"Format Specifier");}

"\\n" {cdisplay1(yytext,"New line");}

\/\/.*"\n" {cdisplay1(yytext,"Single line Comment");}

"/*"([^*]|\*+[^*/]*)*\*+"/" {cdisplay1(yytext,"Multi Line Commment");}

"@"|"$" {cdisplay1(yytext,"Lexical error");}

" "|"\t"|"\n"


%%  



void display() {
   int i = 0;
	
   for(i = 0; i<10000; i++) {
	
      if(stable[i] != NULL && stable[i]->token!="-1")
         printf("%s - %s\n",stable[i]->token,stable[i]->type);

   }
}

void cdisplay() {
   int i = 0;
	
   for(i = 0; i<10000; i++) {
	
      if(ctable[i] != NULL && ctable[i]->token!="-1")
         printf("%s - %s\n",ctable[i]->token,ctable[i]->type);

   }
}

 int yywrap()  
 {  
 return 1;  
 }  
 int main()  
 {  
 yyin=fopen("abc.txt","r");  
 yylex();  
 int j;
 printf("\n\nSymbol table: \n \n");
 display();
 printf("\n\nConstant table: \n \n");
 cdisplay();


 return 0;  
 }  
