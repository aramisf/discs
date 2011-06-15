#ifndef _CONSUMIDORES_H
#define _CONSUMIDORES_H

#define TRUE 1

#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include "produtores.h"
#include "hash.h"
#include "arvore-avl.h"

float* removeDist(void);
int numThreadsCons(int);
int contaDist(float *);
void *consomeDist();

#endif

