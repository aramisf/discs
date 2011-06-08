/* Declaracao de Bibliotecas. */

#include "cabecalho.h"

/* Funcao que efutua a conexao cliente. */

void conexao_cliente (char *argv[]) {
    int num_porta_cliente;
    char nome_servidor [STRING];

    sock_cliente = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock_cliente < 0) 
        error ("socket");
    server_cliente.sin_family = AF_INET;
    determinar_servidor (argv, nome_servidor);  // determinar qual eh o servidor deste cliente.
    hp = gethostbyname(nome_servidor);
    if (hp == 0) 
        error ("Unknown host");
    bcopy((char *)hp->h_addr, (char *)&server_cliente.sin_addr, hp->h_length);
    num_porta_cliente =  porta_cliente (argv);
    server_cliente.sin_port = htons(num_porta_cliente);
    length_cliente = sizeof(struct sockaddr_in);
}

/* Funcao para inserir um novo pacote na lista. */

void * cliente (void* data) {
    while (1) {
        if (quantidade_preenchida < TAM_MAX) {
            fgets (buffer[inicio].dados, STRING-1, stdin);
            strcpy (buffer[inicio].endereco_origem, nome_maquina);
            inicio = (inicio + 1) % TAM_MAX;
            quantidade_preenchida++;
        }
        else {
            printf ("Buffer cheio. Aguardar liberacao de buffer.\n");
            while (quantidade_preenchida == TAM_MAX);
            printf ("Buffer com espaco. Liberado para acrescentar mensagens.\n");
        }
    }
}

/* Funcao para enviar uma nova mensagem ou apenas retransmitir. 
 * Quando esta nesta funcao a maquina sera um cliente. */

void enviar (int condicao, char *argv[]) {
    if (condicao == 1) {        // indica que esta com o bastao.
        if (inicio != fim)
            strcpy (pacote.dados, buffer[fim].dados);
            strcpy (pacote.endereco_origem, buffer[fim].endereco_origem);
    }
    enviar_mensagem ();
    servidor (argv);            // a maquina volta a ser um servidor.
}

/* Funcao que envia uma mensagem. */

void enviar_mensagem (void) {
    int n;
    
    n = sendto (sock_cliente, &pacote, TAM_PACOTE, 0, (struct sockaddr *)&server_cliente, length_cliente);
    if (n < 0) 
        error ("Sendto");
}

/* Funcao que determina o numero da porta do cliente. */

int  porta_cliente  (char *argv[]) {
    int i = 0;
    int vetor_portas [NUM_SERVIDORAS] = {6666, 6667, 6668, 6669};
    
    while (strcmp (nome_maquina, argv[i])) 
        i++;
    if (i == 1)
        return vetor_portas [NUM_SERVIDORAS-1];
    else
        return vetor_portas[i-2];
}

/* Funcao que determina qual eh o servidor. */

void determinar_servidor (char *argv[], char nome_servidor [STRING]) {
    int i = 0;
    
    while (strcmp (nome_maquina, argv[i])) 
        i++;
    if (i == 1)
        strcpy (nome_servidor, argv[NUM_SERVIDORAS]);
    else 
        strcpy (nome_servidor, argv[i-1]);
}
