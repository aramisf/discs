/* Declaracao de Bibliotecas. */

#include "cabecalho.h"

/* Funcao que efutua a conexao servidor. */

void conexao_servidor(char *argv[]) {
    int num_porta_servidor;

    sock_servidor = socket (AF_INET, SOCK_DGRAM, 0); 
    if (sock_servidor < 0) 
        error("Opening socket");
    lengt_servidor = sizeof(server_servidor);
    bzero (&server_servidor, lengt_servidor);            
    server_servidor.sin_family = AF_INET;        
    server_servidor.sin_addr.s_addr = INADDR_ANY;
    num_porta_servidor = porta_servidor (argv);
    server_servidor.sin_port = htons(num_porta_servidor);
    if (bind (sock_servidor, (struct sockaddr *)&server_servidor, lengt_servidor) < 0)
        error ("Erro na ligacao.");
    clientlen = sizeof(struct sockaddr_in);
}

/* Funcao que recebe uma mensagem e verifica o tratamento que deve ser dada a mensagem. */

void servidor (char *argv[]) {
    int condicao = 0;
    int n;

    if (!strcmp (argv[1], nome_maquina))
        openTime (TIMEOUT_1);
    else
        openTime (TIMEOUT_2);
    n = recvfrom (sock_servidor, &pacote, TAM_PACOTE, 0, (struct sockaddr *)&client_servidor, &clientlen);
    if (n < 0) 
        error ("recvfrom");

    if (!strcmp(pacote.dados, "bastao\n"))  // indica que possui o bastao.
        enviar (1, argv);
    else if (!strcmp (pacote.endereco_origem, nome_maquina)) {   // terminou o ciclo no anel.
        if (strcmp(pacote.dados, "testar_rede\n")) {
            fim = (fim + 1) % TAM_MAX;
            quantidade_preenchida --;
            strcpy (pacote.dados, "bastao\n");
            enviar (0, argv);
        }
        else { 
            strcpy (pacote.dados, "bastao\n"); // recria o bastao.
            enviar (1, argv);   // reinicia o processo somente na servidora inicial.
        }
    }
    else if (!strcmp(pacote.dados, "testar_rede\n"))   // simplesmente repassa a mensagem.
        enviar (0, argv);
    else {                      // mensagem recebida e que sera retransmitida.
        printf ("%s", pacote.dados);
        sleep (TEMPO_ESPERA);
        enviar (0, argv);
    }
}

/* Funcao que determina o numero da porta do servidor. */
    
int porta_servidor (char *argv[]) {
    int i = 1;
    int vetor_portas [NUM_SERVIDORAS] = {6666, 6667, 6668, 6669};
    
    while (strcmp (nome_maquina, argv[i])) 
        i++;
    return vetor_portas [i-1];
}
