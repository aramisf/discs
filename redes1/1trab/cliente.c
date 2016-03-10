#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include "cliente.h"

int executaComandoRemoto(conexao *conn,char *comando){

	int continua = enviaNomeComando(conn, comando);
	if (continua == 1) {
		if (strstr (comando, "get ") != NULL)
			executaGet(conn,(strchr(comando,' ')+1));
		else if (strstr (comando, "put ") != NULL)
			executaPut(conn,(strchr(comando,' ')+1));
		else if (strstr (comando, "ls") != NULL)
			recebeLs(conn);
		else if (strstr (comando, "cd ") != NULL)
			recebeCd(conn);

	}else if (continua == -1){
		if (strstr (comando, "get ") != NULL)
			executaGet(conn,(strchr(comando,' ')+1));
		else if (strstr (comando, "ls") != NULL)
			recebeLs(conn);
		else if (strstr (comando, "cd ") != NULL)
			recebeCd(conn);

	}
	
	return 1;
}

int enviaNomeComando(conexao *conn,char *comando){
	byte *dados;
	size_t tamanho, restantes;
	Pacote p;

	if (!existeArquivo(comando))
		return 0;
	
	tamanho = strlen(comando);
	dados = (byte *)comando;
	
	if(tamanho <= MAX_TAM_DADOS){
		if (strstr (comando, "get ") != NULL)	
			criaPacote(&p,tamanho,G,dados);
		if (strstr (comando, "put ") != NULL)	
			criaPacote(&p,tamanho,P,dados);
		if (strstr (comando, "cd ") != NULL)	
			criaPacote(&p,tamanho,C,dados);
		if (strstr (comando, "ls") != NULL)	
			//criaPacote(&p,tamanho,L,(byte*)'0');
			criaPacote(&p,tamanho,L,dados);

	}else{
		printf ("Tamanho do comando muito grande!!\n");
		return 0;	
	}
		
	if (enviaPacote(conn,&p) == 0)
		return -1;
	
	return 1;
}

int existeArquivo (char *comando){
	FILE *arq;
//	enviaComando(conn, comando);
	if (strstr (comando, "put ") != NULL){
		if(!(arq=fopen((strchr(comando,' ')+1),"r"))){ 
		        //arquivo nao existe
			puts("Arquivo inexistente no cliente!! ");
			return 0;
		}
		else
			fclose(arq);
	}
	return 1;
}

void executaGet(conexao *conn,char *arquivo){
	Pacote p;
	char *nome;
	char *tamanho;
	FILE *out;
	char c;	
	char vetor[MAX_TAM_DADOS];
	int i=0;
	unsigned long long int tam=0;
	int mult=1;
	char *codigo="1";

	recebePacote(conn,&p);
	if(p.tipo==E){	
		if (p.dados[0] == '2')
			printf ("Arquivo inexistente no servidor!! \n");
		recebePacote(conn,&p);
	}
	else {
		//recebe F (significa final de arquivo)
		recebePacote(conn,&p);
		out=popen("df -B 1 .|awk '{print $4}'| tail -1","r");		
		c=getc(out);
		while(c!=EOF){//imprime a saida do comando
            
			if((int)c-48 >= 0)
				tam=tam*mult+((int)c-48);
			mult=10;
			c=getc(out);
			i++;
		}
		if (tam < atoi(p.dados)){
			printf("Nao possui espaço em disco suficiente para o arquivo!!\n");
			mandaE(conn,codigo);	
			mandaZ(conn);	
		}
		else{
			mandaZ(conn);//sempre aceita
			//tirar as pastas do nome do arquivo
			nome=strrchr(arquivo,'/');
			if(nome==NULL)
				nome=arquivo;
			else
				nome=nome+1;
			
			recebeArquivo(conn,nome);
		}
	}
}

void executaPut(conexao *conn,char *arquivo){
	Pacote p;

	//manda F
	mandaF(conn,arquivo);

	//manda Z
	mandaZ(conn);

	//recebe, se for E, recebe o erro
	recebePacote(conn,&p);
	if(p.tipo==E){
		if (p.dados[0]=='1')
			printf("O servidor nao possui espaço suficiente para receber o arquivo\n");
	}
	else {//se for Z, comeca a mandar o arquivo
		enviaArquivo(conn,arquivo);
	}
	mandaZ(conn);
	//no final manda um Z
}

void recebeCd(conexao *conn){
	Pacote p;

	recebePacote(conn,&p);
	if(p.tipo==E) {
		if (p.dados[0] == '0')
			printf ("Diretório inexistente no servidor!! \n");
		recebePacote(conn,&p);
	}

}

void recebeLs(conexao *conn){
	Pacote p;
	int i;

	recebePacote(conn,&p);
	while(p.tipo==X){
		for(i = 0; i < p.tamanho; i++){
			printf("%c",p.dados[i]);
		}
		recebePacote(conn,&p);
	}
}

int requisita(conexao *conn) { //prompt do cliente
	int i, num_vets;
	char *comando, c;
	Pacote p;
	int loop =1;
	comando=(char *)malloc(TAM_VET*sizeof(char));

    while(loop){
        printf("ftp >> ");

        num_vets=1;//numero de alocacoes		

        c=getchar();
        while(isspace(c)) //elimina espaços a esquerda do comando
            c=getchar();

        i=0;
        while(c != '\n'){//le comando
            if(i >= TAM_VET * num_vets){
                //realoca string se o comando for maior q TAM_VET
                num_vets++;
                comando=(char*)realloc(comando,num_vets * TAM_VET * sizeof(char));
            }
            comando[i]=c;
            i++;
            c=getchar();
        }
        comando[i]='\0';

        if (strstr(comando,"exit") != NULL){
            loop=0;
            criaPacote(&p,0,S,NULL);
            enviaPacote (conn, &p);
        }
        else {
            if((strstr (comando, "lcd ") != NULL) || (strstr (comando, "lls") != NULL)){
                executaComandoLocal(comando);
            }
            else if ((strstr (comando, "get ") != NULL) || (strstr (comando, "put ") != NULL) || (strstr (comando, "ls") != NULL) || (strstr (comando, "cd ") != NULL)) {
                executaComandoRemoto(conn,comando);
                zeraSequencia();
            }
            else
                printf ("Comando nao disponivel!!\n");
        }
    }	

	return 1;
}

void executaComandoLocal(char *comando){
    FILE *out;
    char c;	

    if((strstr (comando, "lcd ") != NULL)){//se for CD muda o diretorio do programa		
        if (chdir((strchr(comando,' ')+1)) == -1)
            printf ("Diretório inexistente no cliente!! \n");
    }
    else if((strstr (comando, "lls") != NULL)){
        out=popen(&(comando[1]),"r");
        c=getc(out);
        while(c!=EOF){//imprime a saida do comando
            printf("%c",c);		
            c=getc(out);
        }
        pclose(out);	
    }
}
