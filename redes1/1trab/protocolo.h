#ifndef PROTOCOLO_H
#define PROTOCOLO_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "conexao.h"

//Definicoes do protocolo (estilo kermit)
#define MARCA_INICIO 0x7E  // marca do início do pacote (padrao)
#define MAX_TAM_DADOS 252  // tamanho maximo do campo de dados de cada pacote
#define MAX_TAM_PACOTE 257 //tamanho maximo de um pacote 
#define TIMEOUT 2000       // timeout
#define MAX_TIMEOUT_TENTATIVAS 16
#define TAM_ACK_NACK 25


#define C 'C' // cd
#define L 'L' // ls
#define P 'P' // put
#define G 'G' // get

#define D 'D' // dados
#define E 'E' // erro
    	      // erro pode ser divido em 3, 
	          // 0: diretorio inexistente
              // 1: arquivo imenso
              // 2: arquivo inexistente
#define F 'F' // tamanho do arquivo em bytes
#define N 'N' // NACK
#define X 'X' // imprime na tela
#define Y 'Y' // ACK
#define Z 'Z' // fim da acao corrente
#define S 'S' // termina o cliente e o servidor

typedef unsigned char byte;  //definicao de byte

typedef struct pacote {
	byte marca;
	byte tamanho;
    byte sequencia;
	byte tipo;
	byte dados[MAX_TAM_DADOS];
	byte paridade;
} Pacote;

int enviaPacote (conexao *conn, Pacote *p);
int recebePacote (conexao *conn, Pacote *p);
int mandaAck(conexao*, byte);  //envia ack
int mandaNack(conexao*, byte); //envia nack

byte paridade(Pacote *);

void zeraSequencia();
void criaPacote(Pacote *,byte tamanho, byte tipo, byte *dados); //criacao de pacote
void mandaZ(conexao*);    // envia um z
void mandaE(conexao*,byte *);    // envia um erro
void mandaF(conexao*,char*); //envia o tamanho do arquivi
void enviaArquivo(conexao *, char* ); // manda os pacotes D
void recebeArquivo(conexao*, char*); // recebe os pacotes D ate chegar um Z e poe no arquivo
void poeNoArquivo(Pacote*, char*);   

#endif
