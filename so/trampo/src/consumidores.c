#include "consumidores.h"

int numThreadsCons(int numthreadsprod) {

    return numthreadsprod;
}

float* removeDist() {

	float *dists;
    extern buffer buff;

	dists = buff.buff[buff.head];
	buff.head = (buff.head + 1 ) % TAM_BUFFER;

	return dists;
}

void *consomeDist() {

   extern int cont;
   float *dists;
   extern buffer buff;
   extern pthread_mutex_t avlmutex;
   extern Thash hash[TAM_HASH];
   extern unsigned long long int ndistrmv;
   extern unsigned long long int numdist;
   unsigned long long int aux;

   while(TRUE) {

       sem_wait(&buff.full);
       pthread_mutex_lock(&buff.mutex);

       dists = removeDist();
//	   ndistrmv += TAM_RAJADA;
       aux = ndistrmv+TAM_RAJADA;

       if (aux < numdist) {

          ndistrmv = aux;
       }
       else {

          ndistrmv = ndistrmv+(numdist-ndistrmv);
       }
	   if(ndistrmv == numdist) {

	       //printf("TERMINOU!!!\n");
	   	   contaDist(dists);
		   imprime_hash(hash);
		   exit(0);
	   }

	   pthread_mutex_unlock(&buff.mutex);
       sem_post(&buff.empty);

	   contaDist(dists);
   }

   pthread_exit(NULL);
}

int contaDist(float *dist) {

	int i;
	int tam;
	unsigned int indice;
	extern pthread_mutex_t avlmutex;
    extern Thash hash[TAM_HASH];

	indice = funcao_hash(&dist[0]);

	pthread_mutex_lock(&(hash[indice].hashmutex));

	for(i = 0; i < TAM_RAJADA; i++) {

		hash[indice].raiz = Insert(dist[i], hash[indice].raiz);
	}

	pthread_mutex_unlock(&(hash[indice].hashmutex));
	return 0;
}
