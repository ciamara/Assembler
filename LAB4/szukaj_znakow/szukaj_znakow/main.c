#include <stdio.h>

int wyszukaj_znak(wchar_t tablica[], unsigned int* znak);

int main() {

	wchar_t utf16[] = L"Hello, World!";
	unsigned int* znak = L'l';
	unsigned int* wsk = &znak;
	int ile = wyszukaj_znak(utf16, wsk);

	printf("\n%d\t%x\t%x", ile, *wsk, &utf16[7]);
}