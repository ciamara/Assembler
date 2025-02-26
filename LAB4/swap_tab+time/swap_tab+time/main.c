#include<stdio.h>

int swap(int tab[], unsigned int n, int pos1, int pos2);

typedef struct _czas {
	unsigned char godzina;
	unsigned char minuty;
} czas;

void daj_czas(czas* cz);

int main()
{
	int tab[] = { 1, 2, 3, 4, 5 };
	int wynik = swap(tab, 5, 1, 4);
	printf("returned %d\n", wynik);
	for (int i = 0; i < 5; i++)
	{
		printf("%d ", tab[i]);
	}
	printf("\n");
	int tab2[] = { 1, 2, 3, 4, 5 };
	wynik = swap(tab2, 5, 1, 5);
	printf("returned %d\n", wynik);
	for (int i = 0; i < 5; i++)
	{
		printf("%d ", tab2[i]);
	}
	printf("\n");

	czas cz;
	daj_czas(&cz);
	printf("Jest godzina: %02d:%02d\n", cz.godzina, cz.minuty);

	return 0;
}