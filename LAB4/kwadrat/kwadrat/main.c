#include <stdio.h>

double objetosc(unsigned long long a);

int main()
{
	double obj, szerokosc, dlugosc, wysokosc, grubosc;

	obj = objetosc(szerokosc, dlugosc, wysokosc, grubosc);

	printf("szerokosc: %lf\ndlugosc: %lf\nwysokosc: %lf\ngrubosc: %lf\nOBJETOSC: %lf", szerokosc, dlugosc, wysokosc, grubosc, obj);

	return 0;
}