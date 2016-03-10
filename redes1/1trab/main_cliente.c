#include <stdio.h>

#include "conexao.h"
#include "protocolo.h"
#include "cliente.h"
#include "servidor.h"

int main(){
	conexao c;

	c.placa_rede = PLACA;

	//abre o socket
	if (! abreSocket(&c)) {
		fprintf(stderr, "Erro ao abrir socket! Saindo...\n");
		return 1;
	}

	//chama o loop do cliente
	if (! requisita(&c)) {
		fprintf(stderr, "Erro ao executar comandos! Abortando!\n");
		fechaSocket(&c);
		return 1;
	} 

	if (! fechaSocket(&c)) {
		fprintf(stderr, "Erro ao fechar socket!\n");
		return 1;
	}

	return 0;
}
