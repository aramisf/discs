#include <stdio.h>

#include "conexao.h"
#include "protocolo.h"
#include "cliente.h"
#include "servidor.h"

int main(int argc,char *argv[]){
    conexao c;


   c.placa_rede = PLACA;
   //abre o socket do servidor
    if (! abreSocket(&c)) {
	printf("Erro ao abrir socket! Saindo...\n");
	return 1;
    }

	   if (! serve(&c)) {
	       printf( "Erro ao responder comandos! Abortando!\n");
	       fechaSocket(&c);
	       return 1;
	   }
    

    if (! fechaSocket(&c)) {
      printf("Erro ao fechar socket!\n");
	return 1;
    }

    return 0;
}
