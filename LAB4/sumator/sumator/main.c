#include <stdio.h>
#include <stdlib.h>

char * suma(char tablica, int rozm1, int rozm2, int rozm3, int rozm4);

int main() {

	char c;
	int x = 0;
	int size = 30;
	int y = 0;
	int a, b;
	int index;
	char tablica[30][4];
	char tablica2[1][1];
	char wynik[61];
	int koniec = 0;
	int liczba = 0;
	int rozm1 = 0;
	int rozm2 = 0;
	int rozm3 = 0;
	int rozm4 = 0;

	for (c = getch(); c != '\n'; x++) {

		if ((x == size) && (c != '\0')) {
			**tablica2 = malloc(size * 2);
			for (a = 0; a < 4;a++) {
				for (b = 0; b < (size * 2);b++) {
					tablica2[a][b] = tablica[a][b];
				}
			}
			size *= 2;
		}
		if (c == '\0') {
			liczba++;
			switch(liczba) {
			case 1:
				rozm1 = x;
			case 2:
				rozm2 = x;
			case 3:
				rozm3 = x;
			case 4:
				rozm4 = x;
			}
			y++;
		}
		if (size > 30) {
			tablica2[x][y] = c;
		}
		else if (size<=30){
			tablica[x][y] = c;
		}
	}
	if (size > 30) {
		*wynik = suma(tablica2,rozm1,rozm2,rozm3,rozm4);
	}
	else if (size <= 30) {
		*wynik = suma(tablica, rozm1, rozm2, rozm3, rozm4);
	}

	for (index = 0; koniec != 1; index++) {

		if (wynik[index] == '\0') {
			koniec = 1;
		}
		printf("%c", wynik[index]);
	}
}