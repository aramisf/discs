#ifndef SERVIDOR_H
#define SERVIDOR_H

#include "conexao.h"
#include "protocolo.h"


//extern byte SEQUENCIA_ENVIAR;
//extern byte SEQUENCIA_RECEBER;

int serve (conexao *);
void respondeComandos(conexao*, char*);//executa o comando e devolve a saida
void respondeGet(conexao*,char*);//recebe o arquivo
void respondePut(conexao*,char*);//envia o arquivo
void respondeCd(conexao*,char*);//envia o arquivo
void respondeLs(conexao*,char*);//envia o arquivo
void recebeErroCliente(conexao*,byte);//recebe a saida de erro do cliente

#endif
