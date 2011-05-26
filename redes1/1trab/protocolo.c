#include <stdio.h>
#include <stdlib.h>
#include <sys/poll.h>
#include <sys/types.h>
#include <sys/socket.h>
#include "protocolo.h"

byte SEQUENCIA_ENVIAR=0,SEQUENCIA_RECEBER=0;

int enviaPacote(conexao *conn, Pacote *p){

    int i;
    ssize_t tamPacote;
    byte buff[MAX_TAM_PACOTE];

    p->sequencia += SEQUENCIA_ENVIAR;
    p->paridade = paridade(p);

    tamPacote =  p->tamanho+5;
    memcpy(buff, p, 4);

    memcpy(&(buff[4]), p->dados,p->tamanho);

    buff[p->tamanho+4] = p->paridade;


    byte recBuff[MAX_TAM_PACOTE];
    struct pollfd pfd;
    int pollRet;
    int tentativas;
    int recebiAck;

    pfd.fd = conn->sock;
    pfd.events = POLLIN;

    recebiAck = 0;
    do {
        tentativas = 0;
        do {
            //funcao send envia para o fio
            if (send(conn->sock, buff, tamPacote, 0) != tamPacote) {
                perror("send");
                return 0;
            }
            //trata o timeout
            pollRet = poll(&pfd, 1, TIMEOUT);
            if (pollRet < 0) {
                perror("poll");
                return 0;
            } else if (pollRet == 0)
                printf("Timeout! mandando denovo, tentativa n: %d!\n", tentativas+1);
            tentativas++;
        } while (pollRet == 0 && tentativas < MAX_TIMEOUT_TENTATIVAS);

        if (pollRet == 0) {
            printf( "Timeout! O outro cliente provavelmente desconectou!\n");
            return 0;
        }

        if (recv(conn->sock, recBuff, TAM_ACK_NACK, 0) < TAM_ACK_NACK) {
            perror("recv");
            return 0;
        }
        if (recBuff[0] != MARCA_INICIO) {
            printf( "Pacote inválido: marca errada! Abortando!\n");
            return 0;
        }

        //if ((recBuff[2] & 0xff) != SEQUENCIA_ENVIAR) {
        if (recBuff[2] != SEQUENCIA_ENVIAR) {
            printf( "Recebi pacote com seqüência errada! Abortando!\n");
            printf("Eu queria %d, mas recebi %d\n",SEQUENCIA_ENVIAR,recBuff[2]);
            return 0;
        }


        //if ( (recBuff[3]) == N) {
        if ( (recBuff[3]) == Y)// {
            //caso tenha recebido nack
        //} else {
            recebiAck = 1;
        //}
    } while (! recebiAck);
    SEQUENCIA_ENVIAR = (SEQUENCIA_ENVIAR +1) % 256;
    //printf ("Sequencia a enviar: %d\n",SEQUENCIA_ENVIAR);

  //  printf("marca = %x\n",buff[0]);
  //  printf("tamanho = %d\n",buff[1]);
  //  printf("sequencia = %d\n",buff[2]);
  //  printf("tipo = %c\n",buff[3]);
  //  printf("paridade = %d\n\n",buff[p->tamanho+4]);

    return 1;
}

int recebePacote(conexao *conn,Pacote *p){
    byte buff[MAX_TAM_PACOTE],ant;
    ssize_t recebidos;
    int i;
    int terminou = 0;
    do {
        //recv recebe do fio o pacote
        do {
            recebidos = recv(conn->sock, buff, MAX_TAM_PACOTE, 0); 
            if (recebidos < 0) {
                perror("recv");
                return 0;
            }
        } while ((buff[0] != MARCA_INICIO));// while para qnd encontra o comeco de outra msg...


        //tira do buff os dados do pacote
        p->marca = buff[0];
        p->tamanho = buff[1];
        p->sequencia = buff[2];
        p->tipo = buff[3];

        memcpy(p->dados, &(buff[4]), p->tamanho);

        p->paridade = buff[p->tamanho+4];

        //        printf("marca = %x\n",buff[0]);
        //        printf("tamanho = %d\n",buff[1]);
        //        printf("sequencia = %d\n",buff[2]);
        //        printf("tipo = %c\n",buff[3]);
        //        printf("paridade = %d\n",buff[p->tamanho+4]);

        if(SEQUENCIA_RECEBER == 0)
            ant=255; // anterior recebe a sequencia anterior apos zerar a sequencia
        else
            ant=SEQUENCIA_RECEBER-1;


        if (p->sequencia != SEQUENCIA_RECEBER) {
            if (p->sequencia == ant){
                printf("Reenviando ack, pode nao ter recebido!\n");
                printf("mandaAck(conn, %d);\n",ant);
                mandaAck(conn, ant);
                continue;
            } else {
                printf("Erro! Seqüência incorreta! Abortando!\n");
                printf("Eu queria %d, mas veio %d\n",SEQUENCIA_RECEBER,ant);
                zeraSequencia();
                return 0;
            }
        }

        //verificacao de paridade
        if (paridade(p) != p->paridade) {
            mandaNack(conn, SEQUENCIA_RECEBER);
        } else {
            //manda ack
            mandaAck(conn, SEQUENCIA_RECEBER);
            terminou = 1;
        }
    } while (! terminou);

    SEQUENCIA_RECEBER = (SEQUENCIA_RECEBER + 1) % 256;
    return 1;
}

int mandaAck(conexao *conn, byte sequencia){
	Pacote p;
	criaPacote(&p,0,Y,0);
	p.sequencia = sequencia;
	p.paridade = paridade(&p);

	byte ack[TAM_ACK_NACK];
	ack[0] = p.marca;
	ack[1] = p.tamanho;
	ack[2] = p.sequencia;
	ack[3] = p.tipo;
	ack[4] = p.paridade;

	if (send(conn->sock, ack, TAM_ACK_NACK, 0) != TAM_ACK_NACK) {
		perror("send");
		return 0;
	}

	return 1;

}

int mandaNack(conexao *conn, byte sequencia){
	Pacote p;
	criaPacote(&p,0,N,0);
	p.sequencia = sequencia;
	p.paridade = paridade(&p);

	byte nack[TAM_ACK_NACK];
	nack[0] = p.marca;
	nack[1] = p.tamanho;
	nack[2] = p.sequencia;
	nack[3] = p.tipo;
	nack[4] = p.paridade;

	if (send(conn->sock, nack, TAM_ACK_NACK, 0) != TAM_ACK_NACK) {
		perror("send");
		return 0;
	}

	return 1;
}
//z = fim 
void mandaZ(conexao *conn){
	Pacote p;
	criaPacote(&p,0,Z,0);
	enviaPacote(conn,&p);
}
//erro
void mandaE(conexao *conn,byte *codigo){
	Pacote p;
	criaPacote(&p,1,E,codigo);
	enviaPacote(conn,&p);
}
//tamanho do arquivo em bytes
void mandaF(conexao *conn, char *arquivo){
	FILE *arq;
	long int tamanho,tamF,restantes;
	byte *dados,tam[100],*fd;
	Pacote p;
	char *nome;

	arq=fopen(arquivo,"r");
	fseek(arq,0,SEEK_END);
	tamanho = ftell(arq);//pega tamanho do arquivo
	fclose(arq);

	//tirar as pastas do nome do arquivo
	nome=strrchr(arquivo,'/');
	if(nome==NULL)
		nome=arquivo;
	else
		nome=nome+1;

	sprintf((char*)tam,"%ld",tamanho);
	tamF=strlen((char *)tam); 
	fd=(byte*)malloc(tamF+1);//+1 por causa do '\0'.
	sprintf((char *)fd,"%ld",tamanho);
	
	if(tamF <= MAX_TAM_DADOS){
		criaPacote(&p,tamF,F,fd);
		enviaPacote(conn,&p);
	}
	else {
		restantes=tamF;
		dados = fd;	
		do {
			criaPacote(&p,MAX_TAM_DADOS,F,dados);
			enviaPacote(conn,&p);
			dados = &(dados[MAX_TAM_DADOS]);
			restantes -= MAX_TAM_DADOS;
		}
		while(restantes > MAX_TAM_DADOS);
		
		if(restantes>0){
			criaPacote(&p,restantes,F,dados);
			enviaPacote(conn,&p);
		}
	}
	free(fd);	
}

void criaPacote(Pacote *novo,byte tamanho,byte tipo, byte *dados){

	novo->marca = MARCA_INICIO;
	novo->tamanho = tamanho;
	novo->sequencia = 0;
	novo->tipo = tipo;
	memcpy(novo->dados,dados,tamanho);
	//strncpy(novo->dados,dados,tamanho);
	//memmove(novo->dados,dados,tamanho);
}

byte paridade(Pacote *p){
	byte paridade;
	int i,n;

	//paridade do tamanho com a sequencia e o tipo da msg
	paridade = p->tamanho ^ p->sequencia ^ p->tipo;
	
	for(i = 0; i < p->tamanho; i++)
		paridade = paridade ^ p->dados[i];
    
	return paridade;
}

void enviaArquivo(conexao *conn,char *nome){
	FILE *arq;
	byte dados[MAX_TAM_DADOS];
	Pacote p;
	size_t lidos;

	arq=fopen(nome,"r");
	
	do {
		lidos=fread(dados,sizeof(byte),MAX_TAM_DADOS,arq);
		if(lidos>0){
			criaPacote(&p,lidos,D,dados);
			enviaPacote(conn,&p);
		}
	}
	while(lidos==MAX_TAM_DADOS);
	
	fclose(arq);
}

void recebeArquivo(conexao *conn,char *nome){
	Pacote p;
	byte tipo;
	FILE *arq;

	if((arq=fopen(nome,"w"))) //arquivo ja existe
		fclose(arq);//limpa o arquivo para escreve-lo novamente

	recebePacote(conn,&p);	
	tipo = p.tipo;
	while(tipo == D){//enquanto receber pacotes D, poe ele no arquivo
		poeNoArquivo(&p,nome);
		recebePacote(conn,&p);
		tipo = p.tipo;
	}
}

void poeNoArquivo(Pacote *p,char *nome){
	FILE *arq;

	arq=fopen(nome,"a");

	fwrite(p->dados,sizeof(byte),p->tamanho,arq);

	fclose(arq);
}

void zeraSequencia(){
	SEQUENCIA_ENVIAR=0;
	SEQUENCIA_RECEBER=0;	
}
