#ifndef CLIENTE_H
#define CLIENTE_H

#include "conexao.h"
#include "protocolo.h"


#define TAM_VET 100

int executaComandoRemoto(conexao*,char*);//envia comando para o servidor

int existeArquivo (char *comando); //verifica se exsite o arquivo para o put
void executaComandoLocal(char*);
int  enviaNomeComando(conexao*, char*);
void recebeCd(conexao*);
void recebeLs(conexao*);
void executaGet(conexao*,char*);//recebe o F e o arquivo

void executaPut(conexao*,char*);//manda F e o arquivo
 
void recebeResposta(conexao*); //recebe a resposta de um comando (X's)

int requisita(conexao *); //prompt para envio de comandos.

#endif
