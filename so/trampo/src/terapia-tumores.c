#include "terapia-tumores.h"

buffer buff;
coord *celulas;
rajada dists[TAM_HASH];
Thash hash[TAM_HASH];

pthread_mutex_t celulas_mutex;
pthread_mutex_t incr_mutex;
pthread_mutex_t avlmutex;

unsigned int proxcelula;
unsigned long long int numdist;
unsigned long long int ndistrmv;

int main(int argc, char *argv[]) {

	int i;
    int thrd;
	int numthreadscons;
	int numthreadsprod;
	unsigned long long int numcelulas;
	pthread_attr_t attr;

	numthreadsprod = atoi(argv[2]);
	numthreadscons = atoi(argv[3]);

	threadAttr threadsDados[numthreadsprod];
	pthread_t threadsProd[numthreadsprod];
	pthread_t threadsCons[numthreadscons];

	celulas = getCelulas(argv[1], &numcelulas);

	buff.head = 0;
	buff.tail = 0;
	ndistrmv = 0;
	proxcelula = numthreadsprod;

	start_hash(hash);

	/* Iniciando Semafaros */
	iniciaSems();

    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

	/* Quantidade total de distanciads que serao calculadas */
	numdist = ((numcelulas - 1) * numcelulas) / 2;

    /* Aqui sao abertas as threads produtoras */
	for (thrd = 0; thrd < numthreadsprod; thrd++) {

        /* Colocando os parametros da thread em uma estrutura */
		threadsDados[thrd].numcelulas = numcelulas;
        threadsDados[thrd].celinit = thrd;

        pthread_create(&threadsProd[thrd], &attr, &produzDist, \
                      (void *) &threadsDados[thrd]);
	}

	for (thrd = 0; thrd < numthreadscons; thrd++) {

        pthread_create(&threadsCons[thrd], &attr, &consomeDist, NULL);
    }

	/* Esperando Threads produtoras terminarem sua execucao */
	for (thrd = 0; thrd < numthreadsprod; thrd++) {

        pthread_join(threadsProd[thrd], NULL);
    }

	printf("terminou producao !\n");


	    printf("numthreadscons = %d\n", numthreadscons);
	for (thrd = 0; thrd < numthreadscons; thrd++) {

        pthread_join(threadsCons[thrd], NULL);
	    printf("numthreadscons = %d\n", numthreadscons);
    }

	imprime_hash(hash);

    return 0;
}
