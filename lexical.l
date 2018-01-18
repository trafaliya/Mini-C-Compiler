%{

#include <stdio.h>
#include <string.h>
struct symboltable
{
	char token[100];
	char type[100];

}table[10000];

int i=0;

%}

letter [a-zA-Z]  
digit[0-9]  

%%  
{digit}+("E"("+"|"-")?{digit}+)? {strcpy(table[i].token,yytext);strcpy(table[i++].type,"Real Number");}

{digit}+"."{digit}+("E"("+"|"-")?{digit}+)? {strcpy(table[i].token,yytext);strcpy(table[i++].type,"Floating point number");}

"#include <"{letter}*".h>"|"#include<"{letter}*".h>" {strcpy(table[i].token,yytext);strcpy(table[i++].type,"Include Statement");}

"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while" {strcpy(table[i].token,yytext);strcpy(table[i].type,"Keyword");}

({letter}|"_")({letter}|{digit})* {strcpy(table[i].token,yytext);strcpy(table[i++].type,"Identifer");}


"&&"|"<"|">"|"<="|">="|"="|"+"|"-"|"?"|"*"|"/"|"%"|"&"|"||" {strcpy(table[i].token,yytext);strcpy(table[i++].type,"Operator");}

"{"|"["|"(" {strcpy(table[i].token,yytext);strcpy(table[i++].type,"Opening bracket"); }

"}"|"]"|")" {strcpy(table[i].token,yytext),strcpy(table[i++].type,"Closing bracket");}

"#"|"'"|"."|"\""|"," {strcpy(table[i].token,yytext),strcpy(table[i++].type,"Special Character");}

"\;" {strcpy(table[i].token,yytext);strcpy(table[i++].type,"Delimiter");}

"%d"|"%s"|"%c"|"%f"|"%e" {strcpy(table[i].token,yytext);strcpy(table[i++].type,"Format specifier");}

"\\n" {strcpy(table[i].token,yytext);strcpy(table[i++].type,"New line");}

"//"|"/*"|"*/" {strcpy(table[i].token,yytext);strcpy(table[i++].type,"Comments");}




%%  
 int yywrap()  
 {  
 return 1;  
 }  
 int main()  
 {  
 yyin=fopen("abc.txt","r");  
 yylex();  
 int j;
 for(j=0;j<i;j++)
 {
 	printf("%s - %s\n",table[j].token,table[j].type);
 }

 return 0;  
 }  
