#include "hash.h"

extern unsigned long long int numdist;

void start_hash(Thash *hash) {

	int i;

	for (i = 0; i < TAM_HASH; i++) {

		pthread_mutex_init(&hash[i].hashmutex, NULL);
		hash[i].raiz = NULL;
	}
}

unsigned int funcao_hash (float *dist) {

	return ((unsigned int)(*dist * MASK)) % TAM_HASH;
}

int hash_insert (unsigned int indice, float *dist) {


//	pthread_mutex_unlock(&hash[indice].hashmutex);
}

void imprime_hash(Thash *hash) {

	int i;
    unsigned int cont=0;

	for(i = 0; i < TAM_HASH; i++) {

    	printTree(hash[i].raiz,&cont);
	}
	printf("n_uniq %u\n",cont);
	printf("sum_uniq %llu\n",numdist);
}
