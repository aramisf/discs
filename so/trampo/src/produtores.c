#include "produtores.h"

int numCelulas(char *nome_arquivo) {

    int numcel;
    float a, b, c;
	FILE *arquivo_celulas;

	numcel = 0;
	arquivo_celulas = fopen(nome_arquivo, "r");

	while( fscanf (arquivo_celulas, "%f %f %f", &a, &b, &c) != EOF )
        numcel++;

    return numcel;
}

void iniciaSems() {

	int i;

	extern buffer buff;
	extern rajada dists[TAM_HASH];
	extern pthread_mutex_t celulas_mutex;
	extern pthread_mutex_t incr_mutex;
	extern pthread_mutex_t avlmutex;

	sem_init(&buff.full, 0, 0);
    sem_init(&buff.empty, 0, TAM_BUFFER);

    pthread_mutex_init(&buff.mutex, NULL);
    pthread_mutex_init(&incr_mutex, NULL);
    pthread_mutex_init(&celulas_mutex, NULL);
    pthread_mutex_init(&avlmutex, NULL);

//	for(i = 0; i < TAM_HASH; i++) {

		//pthread_mutex_init(&dists[i].raj_mutex, NULL);
		//dists[i].count = 0;
//	}

}

coord *getCelulas(char *nome_arquivo, unsigned long long int *numcelulas) {

    int i;
    int numcel;
    int tam;
    FILE *arq_celulas;
    coord *celulas;

    tam = 16;
    numcel = numCelulas(nome_arquivo);

	//entrada de dados
	arq_celulas = fopen(nome_arquivo, "r");

	// alocando memória
	celulas = (coord *) memalign (tam, numcel * sizeof(coord));

	for(i = 0; i < numcel; i++)
	 	fscanf(arq_celulas, "%f %f %f", &celulas[i].x, &celulas[i].y, \
		                                &celulas[i].z);
	fclose(arq_celulas);

	*numcelulas = numcel;

    return celulas;
}

float calculaDistancia(coord celulaJ, coord celulaK) {

	float a;
	float b;
	float c;
    float distJK;

	a = celulaJ.x - celulaK.x;
	b = celulaJ.y - celulaK.y;
	c = celulaJ.z - celulaK.z;

    distJK = sqrt (a*a + b*b + c*c);

    return distJK;
}

int insereRajada(float *dists) {

	int i = 0;
   extern buffer buff;


   /* When the buffer is not full add the item
      and increment the counter*/
   buff.buff[buff.tail] = dists;

   buff.tail = (buff.tail + 1) % TAM_BUFFER;
}

void *produzDist(void *threadDados) {

	int i;
    int cel1;
    int cel2;
	coord *d1;
	coord *d2;
    int celinit;
    int numcelulas;
	float dist_calc;
	extern buffer buff;
    extern coord *celulas;
	extern pthread_mutex_t incr_mutex;
	extern pthread_mutex_t celulas_mutex;
	extern int proxcelula;
	unsigned int numbuffer;
	threadAttr *tAtrr;
	rajada dists[TAM_HASH];

	tAtrr = (threadAttr *)threadDados;
    numcelulas = (int)tAtrr->numcelulas;
	celinit = (int)tAtrr->celinit;

	for(i = 0; i < TAM_HASH; i++) {

		dists[i].count = 0;
	}

	for(cel1 = celinit; celinit < numcelulas; cel1++) {

		for(cel2 = cel1 + 1; cel2 < numcelulas; cel2++) {

			//pthread_mutex_lock(&celulas_mutex);

			d1 = &celulas[cel1];
			d2 = &celulas[cel2];

			//pthread_mutex_unlock(&celulas_mutex);

			dist_calc = calculaDistancia(*d1, *d2);
			numbuffer = funcao_hash(&dist_calc);

			//pthread_mutex_lock(&dists[numbuffer].raj_mutex);
			dists[numbuffer].valores[dists[numbuffer].count] = dist_calc;
			dists[numbuffer].count++;

			if(dists[numbuffer].count == TAM_RAJADA) {

				sem_wait(&buff.empty);
				pthread_mutex_lock(&buff.mutex);

				insereRajada(dists[numbuffer].valores);
				dists[numbuffer].count = 0;
			  //  pthread_mutex_unlock(&dists[numbuffer].raj_mutex);

				pthread_mutex_unlock(&buff.mutex);
				sem_post(&buff.full);
			}
			//else
			//	pthread_mutex_unlock(&dists[numbuffer].raj_mutex);
		}

		pthread_mutex_lock(&incr_mutex);

		celinit = proxcelula;
		proxcelula++;

		pthread_mutex_unlock(&incr_mutex);
	}

	for(i = 0; i < TAM_HASH; i++) {

			if(dists[i].count > 0) {

				sem_wait(&buff.empty);
				pthread_mutex_lock(&buff.mutex);

				insereRajada(dists[i].valores);

				pthread_mutex_unlock(&buff.mutex);
				sem_post(&buff.full);
			}
	}

    pthread_exit(NULL);
}
