#ifndef CONEXAO_H
#define CONEXAO_H


#define PLACA "eth0"
typedef struct _conexao {
    int sock;
    char *placa_rede;
} conexao;

int abreSocket(conexao *);//abre a conexao com RAW SOCKET
int fechaSocket(conexao *);//fecha a conexao
#endif
