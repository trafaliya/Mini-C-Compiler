
// Test case for for loop, while loop, nested while loop and if-else statements

#include <stdio.h>

int main()
{
	int i,j=0;

        for (i=0;i<10;i++)                     // valid for loop
	{
		printf("%d \n",i);
	}

        for [i=0;i<10;i++]                      // incorrect brackets
        {
		printf("%d \n",i);
        }

        while (i<20)                           // valid nested while loops
	{
		j=0;
		while (j<3)
		{
			j++;
		}
	}
	while (x<9                              // no closing brackets
		x++;

        if (i<20)                              // valid if-else statements
	{
		printf("Hello World \n");
	}
	else if (i>20)
	{
		printf("Bye World \n");
	}
	else
		printf("Equality \n");


	else [i<20]                                 // invalid if-else statement
		printf("Nothing happens \n");

}
