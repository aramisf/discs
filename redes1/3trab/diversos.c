/* Declaracao de Bibliotecas. */

#include "cabecalho.h"

/* Funcao que estabelece se a servidora comeca como cliente ou servidor. */

void iniciar (char *argv[]) {
    int thr_id;             // thread ID for the newly created thread
    pthread_t  p_thread;    // thread's structure 
    int n, a; 
    
    inicio = 0;
    fim = 0;
    quantidade_preenchida = 0;
    gethostname (&nome_maquina, STRING);
    conexao_servidor(argv);
    conexao_cliente (argv);
    system ("clear");
    if (!strcmp (argv[1], nome_maquina)) {
        printf ("Aguardando conexao com a rede.\n");
        n = sendto (sock_cliente, &pacote, TAM_PACOTE, 0, (struct sockaddr *)&server_cliente, length_cliente);
        openTime (TIMEOUT_1);
        n = recvfrom (sock_servidor, &pacote, TAM_PACOTE, 0, (struct sockaddr *)&client_servidor, &clientlen);
        if (n < 0) 
            error ("recvfrom");
        printf ("Rede conectada.\n");
        strcpy (pacote.dados, "bastao\n");
    }
    /* create a new thread that will execute 'do_loop()' */
    thr_id = pthread_create (&p_thread, NULL, cliente, (void*)&a);
    if (!strcmp (argv[1], nome_maquina)) 
        enviar (1, argv);   // funcao que determina que a maquina sera um cliente.
    else  
        servidor (argv);    // funcao que determina que a maquina sera um servidor.
}

/* Funcao que imprime mensagem de erro se alguma operacao do sistema falhar. */

void error (char *msg) {
    perror (msg);
    exit (0);
}

/* Funcao qeu implementa o timeout. */

void openTime (int timeout) {
    int tentativas = 0, acabou = 0, p;
    // Estrutura do poll para controlar o timeout.
    struct pollfd pfd;

    pfd.fd = sock_servidor;     // Escuta o Socket.
    pfd.events = POLLIN;        // Flag que indica recebimento.

    do {    // timeout.
        p = poll (&pfd, 1, timeout);    // Aguarda por um dado a ser lido.
        switch (p) {
            case 0:     // Deu timeout
                    strcpy (pacote.endereco_origem, nome_maquina);
                    strcpy (pacote.dados, "testar_rede\n");
                    fprintf (stdout, "Timeout %d\n", ++tentativas);
                    timeout = TIMEOUT_3;
                    enviar_mensagem ();
                    break;
            case -1:    // Deu erro no poll
                    printf ("Erro na execucao do poll!\n");
                    exit (-1);
            default:    // Valor positivo, significa que tem algo para ser lido.
                    acabou = 1;
                    break;
        }
    } while (!acabou && tentativas < MAX_TENTATIVAS);

    if (tentativas == MAX_TENTATIVAS) {
        printf ("Rede sem conexao.\n");
        exit (-1);
    }
}
