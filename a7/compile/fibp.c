#include "outfn.c"

int fib(int n)
{
	if (n<=2) return 1;
	else return fib(n-1) + fib(n-2);
}

int main()
{
	if (fib(6)==8) 
		printf("HelloWorld\n");
	else
		printf("GoodbyeWorld\n");
	
	return 42;
}
