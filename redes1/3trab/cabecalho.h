/* Declaracao de Bibliotecas. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/poll.h>
#include <pthread.h>
#include <semaphore.h>

/* Declaracao de Constantes. */

#define NUM_SERVIDORAS          4        // indica quantas servidoras pertencem ao anel.
#define MAX_TENTATIVAS          4        // numero maximo de tentativas para ver se a rede esta conectada.
#define STRING                255        // tamanho maximo do nome da servidora e conteudo dos dados.
#define TAM_MAX                50        // tamanho maximo do buffer.
#define TAM_PACOTE sizeof(Pacote)        // tamanho de 1 pacote.
#define TEMPO_ESPERA            2        // tempo que cada maquina segura a mensagem ate se deslocar para a proxima maquina.
#define TIMEOUT_1            8000        // tempo de espera por um sinal da maquina argv[1].
#define TIMEOUT_2           13000        // tempo de espera por um sinal da maquian diferente de argv[1].
#define TIMEOUT_3            1000        // tempo de espera dentro do loop de timeout.
/* Declaracao de Estruturas. */

struct Pacote {
    char dados [STRING]; 
    char endereco_origem [STRING]; 
};
typedef struct Pacote Pacote;

/* Declaracao de Prototipos. */

void * cliente              (void *);
void conexao_cliente        (char *[]);
void conexao_servidor       (char *[]);
void determinar_servidor    (char *[], char []); 
void enviar                 (int, char *[]);
void enviar_mensagem        (void); 
void error                  (char *);
void iniciar                (char *[]);
void openTime               (int);
int  porta_servidor         (char *[]);
int  porta_cliente          (char *[]);
void servidor               (char *argv[]);

/* Declaracao de variaveis globais. */

int quantidade_preenchida, inicio, fim;
Pacote pacote, buffer [TAM_MAX];
char nome_maquina [STRING];
int sock_servidor, lengt_servidor, clientlen, sock_cliente, length_cliente;
struct sockaddr_in server_servidor, client_servidor, server_cliente;
struct hostent *hp;
