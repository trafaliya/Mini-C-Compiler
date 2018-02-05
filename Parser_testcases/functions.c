
// Test case for defining user-defined functions and invoking them in the main function

#include <stdio.h>

void printpattern()                                //correct function declaration
{
	printf("*    \n");

}


int ret10[]                                      //Wrong brackets
{
	return 10;
}

void checkg10(int x)                              //correct function declaration
{
	if (x>10)
	{
		printf("%d is greater than 10\n",x);
	}
	else
		printf("%d is not greater than 10\n",x);
}
int main()
{
	int i,j;
        printpattern();                           //correct function call

	ret10{};                                //incorrect function call

	checkg10(i);                              //correct function call

}
