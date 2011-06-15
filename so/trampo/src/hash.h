#ifndef __HASH_H
#define __HASH_H

#define TAM_HASH 32
#define MASK 10000

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "arvore-avl.h"

typedef struct Thash {

	AvlTree raiz;
    pthread_mutex_t hashmutex;
} Thash;

#endif
