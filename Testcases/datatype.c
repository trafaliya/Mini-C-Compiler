
// Test case for data types, declarations and assignment statements

#include <stdio.h>

int main()
{
	char a;             //valid char assignment
	char a[100];        //valid char assignment
        
	int 5xyz;           //invalid identifier
	int x=10;           //valid int assignment      
        x=2*q;              //invalid assignment
  
        float z=30.0;       //valid float assignment
        float @y=25.0;      //invalid float assignment
	float y=25.1.0;      //invalid float assignment

        z=x+y;              //valid statement
	return 0;

}
