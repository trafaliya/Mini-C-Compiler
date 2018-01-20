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
   if (j>4)
   		j=4;
   for(i=j;i>=0;i--)
   {
   	x=x+token[i]*pow(10,j-i);
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

int i=0;

%}

letter [a-zA-Z]  
digit[0-9]  

%%  
{digit}+("E"("+"|"-")?{digit}+)? {cinsert(yytext,"Real Number");}

{digit}+"."{digit}+("E"("+"|"-")?{digit}+)? {cinsert(yytext,"Floating point number");}

"\""(.*)"\"" {cinsert(yytext,"Character constant");}


"#include <"{letter}*".h>"|"#include<"{letter}*".h>" {insert(yytext,"Include statement"); }

"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while" {insert(yytext,"Keyword");}

({letter}|"_")({letter}|{digit})* {insert(yytext,"Identifier");}


"&&"|"<"|">"|"<="|">="|"="|"+"|"-"|"?"|"*"|"/"|"%"|"&"|"||" {insert(yytext,"Operators");}

"{"|"["|"(" {insert(yytext,"Opening bracket"); }

"}"|"]"|")" {insert(yytext,"Closing bracket");}

"#"|"'"|"."|"\""|"," {insert(yytext,"Special characters");}

"\;" {insert(yytext,"Delimiter");}

"%d"|"%s"|"%c"|"%f"|"%e" {insert(yytext,"Format Specifier");}

"\\n" {insert(yytext,"New line");}

"//"|"/*"|"*/" {insert(yytext,"Commment");}

"@"|"$" {insert(yytext,"Lexical error");}

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
