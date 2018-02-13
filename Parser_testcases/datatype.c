// Test case for data types, declarations and assignment statements

#include <stdio.h>

int main()
{
	char a;             //valid char assignment

	int xyz;           //invalid identifier
	int x=10;           //valid int assignment
        int y=10,z=5;
	
        z*=10+y/=1;   //invalid assigment
	y+=5;
	x-=1;
	
        z=x+y;              //valid statement
	return 0;

}
