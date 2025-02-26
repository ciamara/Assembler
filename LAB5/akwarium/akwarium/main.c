#include <stdio.h>

extern double objetosc(double szerokosc, double dlugosc, double wysokosc, double grubosc, double poziomwody, double piasek);

int main()
{
    double obj, szerokosc, dlugosc, wysokosc, grubosc, poziomwody, piasek;

    printf("Podaj szerokosc: ");
    scanf_s("%lf", &szerokosc);

    printf("Podaj dlugosc: ");
    scanf_s("%lf", &dlugosc);

    printf("Podaj wysokosc: ");
    scanf_s("%lf", &wysokosc);

    printf("Podaj grubosc: ");
    scanf_s("%lf", &grubosc);

    printf("Podaj poziom wody: ");
    scanf_s("%lf", &poziomwody);

    printf("Podaj piasek: ");
    scanf_s("%lf", &piasek);

	obj = objetosc(szerokosc, dlugosc, wysokosc, grubosc, poziomwody, piasek);

	printf("szerokosc: %lf\ndlugosc: %lf\nwysokosc: %lf\ngrubosc: %lf\npoziom wody: %lf\npiasek: %lf\nOBJETOSC: %0.3lf", szerokosc, dlugosc, wysokosc, grubosc, poziomwody, piasek, obj);

	return 0;
}