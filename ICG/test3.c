#include <stdio.h>

int abc(int a,int b,int c)
{
	a=b*c;
	return a;
}


int main()
{
	int x,y,z,a,b,c,d;	
	a=b*c+d;
	while (a<5)
	{
		x=y+z;
	}
	
	b=c*d+a-x;

	if (a<5)
		x=x+2;
	else if (a>5)
		y=y+2;
        else
		z=z+2;		
 
	x=abc(10,20,y);
	abc(30,40,50);	
}
