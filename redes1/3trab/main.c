/* Declaracao de Bibliotecas. */

#include "cabecalho.h"

/* Programa Principal. */

int main (int argc, char *argv[]) {
    int i = 1;
    char ch;

    if (argc == 1 || argc-1 == NUM_SERVIDORAS) {
        if (argc == 1) 
            while ((ch = fscanf (stdin, "%s", (argv[i++] = (char *) malloc (sizeof(char)*STRING)))) != EOF);
        iniciar (argv);
    }
    else {
        printf ("Numero de servidoras deve ser igual a %d\n", NUM_SERVIDORAS);
        printf ("Ou digitar [programa executavel] < [arquivo com servidoras]\n");
        exit (-1);
    }
}
