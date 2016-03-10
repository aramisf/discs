#ifndef _CELULA_H
#define _CELULA_H

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <semaphore.h>
#include <pthread.h>
#include "hash.h"

#define TAM_COORD 7
#define TAM_RAJADA 1024
#define TAM_BUFFER 1024

typedef struct coord { float x; float y; float z; } coord;

typedef struct threadAttr {

    int celinit;
    int celfim;
    int numcelulas;
    coord *celulas;
} threadAttr;

typedef struct rajada {

	int count;
	float valores[TAM_RAJADA];
} rajada;

typedef struct {

    float *buff[TAM_BUFFER];
    int head;
    int tail;
    sem_t full;
    sem_t empty;
    pthread_mutex_t mutex;
} buffer;

int insereDist(float);
int numCelulas(char *);
int numThreadsProd(int, int *);
void *produzDist(void *);
float calculaDistancia(coord, coord);
coord *getCelulas(char *, unsigned long long int *);

#endif

