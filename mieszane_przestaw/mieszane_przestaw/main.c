#include <stdio.h>

void przestaw(int tabl[], int n);

int main()
{
	int n = 6;
	int tabl[] = { 6, 5, 4, 3, 2, 1};

	przestaw(tabl, n);

	for (int i = 0; i < n; i++) {
		printf("%d ", tabl[i]);
	}
	printf("\n");


	return 0;
}