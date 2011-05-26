#include <stdio.h>
#include <unistd.h>
#include "servidor.h"

void respondeComandos(conexao *conn, char *comando) {
	
	if (strstr (comando, "get ") != NULL)
		respondeGet(conn,(strchr(comando,' ')+1));
	else if (strstr (comando, "put ") != NULL)
		respondePut(conn,(strchr(comando,' ')+1));
	else if (strstr (comando, "ls") != NULL)
		respondeLs(conn, comando);
	else if (strstr (comando, "cd ") != NULL){
		respondeCd(conn, comando);
	}		
}

void respondeGet(conexao *conn, char *arquivo) {
	FILE *arq;
	Pacote p;
	byte *codigo="2";
	int codigo_erro	;

	if(!(arq=fopen(arquivo,"r"))){//arquivo nao existe, manda E
		mandaE(conn,codigo);	
		mandaZ(conn);
	}
	else {
		fclose(arq);
		mandaF(conn,arquivo);//manda F do arquivo
		mandaZ(conn);
		recebePacote(conn,&p);
		if(p.tipo==E){//deu erro, entao recebe a saida de erro do cliente
			recebePacote(conn,&p);	
		}
		else {//envia o arquivo
			enviaArquivo(conn,arquivo);
			mandaZ(conn);
		}
	}
}

void respondeCd(conexao *conn, char *comando) {
	byte *codigo="0";
	Pacote p;
	if(chdir((strchr(comando,' ')+1)) == -1){//se deu algum erro, mando um E, o pacote do erro precisa conter o codigo 0
		mandaE(conn,codigo);	
	}
	criaPacote(&p,0,Y,0);
	enviaPacote(conn,&p);	
}

void respondeLs(conexao *conn, char *comando) {
	size_t lidos;
	char *nComando;	
	FILE  *out;
	Pacote p;
	byte dados[MAX_TAM_DADOS];
	out=popen(comando,"r");//executa o comando
	do {//envia a saida do comando (X's)
		lidos=fread(dados,sizeof(byte),MAX_TAM_DADOS,out);
        //printf("Tamanho de lidos: %d\n",(int)lidos);
		if(lidos>0){
			criaPacote(&p,lidos,X,dados);
			enviaPacote(conn,&p);
		}
	}while(lidos==MAX_TAM_DADOS);
	mandaZ(conn);		
	pclose(out);
	
	
}

void respondePut(conexao *conn, char *arquivo) {
	Pacote p;
	char *nome;

	//recebe F
	recebePacote(conn,&p);
	while(p.tipo!=Z){
		recebePacote(conn,&p);
	}
	mandaZ(conn);//sempre aceita
	
	//tirar as pastas do nome do arquivo
	nome=strrchr(arquivo,'/');
	if(nome==NULL)
		nome=arquivo;
	else
		nome=nome+1;

	recebeArquivo(conn,nome);
}

int serve(conexao *conn) {
	Pacote p;
	char *comando;
	size_t tamanho=0;
	int loop = 1;

	while(loop){
		recebePacote(conn,&p);
		if(p.tipo==S){
			loop=0;
		}
		else{
			// se o pacote recebido for um cd, ls, put ou get
			if((p.tipo==C) || (p.tipo == L) || (p.tipo == P) || (p.tipo == G)){
				tamanho=p.tamanho+1;
				comando=(char*)malloc(tamanho);
				memcpy(comando,p.dados,tamanho-1);
				comando[tamanho-1]='\0';
			}
			printf("Recebi comando: %s\n",comando);
			if (p.tipo == L)
				comando = "ls ";
			respondeComandos(conn,comando);
            bzero(&comando,tamanho);
			free(comando);
			zeraSequencia();
		}
	}

	return 1;
}

