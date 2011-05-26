CC=gcc
CFLAGS=-O0 -g3 

all: cliente
all: servidor

cliente: main_cliente.c protocolo.o cliente.o servidor.o conexao.o
	$(CC) $(CFLAGS) -o cliente main_cliente.c protocolo.o cliente.o servidor.o conexao.o

servidor: main_servidor.c protocolo.o cliente.o servidor.o conexao.o
	$(CC) $(CFLAGS) -o servidor main_servidor.c protocolo.o cliente.o servidor.o conexao.o

protocolo.o: protocolo.h protocolo.c conexao.o
	$(CC) $(CFLAGS) -c protocolo.c -o protocolo.o

cliente.o: cliente.h cliente.c protocolo.o conexao.o
	$(CC) $(CFLAGS) -c cliente.c -o cliente.o

servidor.o: servidor.h servidor.h protocolo.o conexao.o
	$(CC) $(CFLAGS) -c servidor.c -o servidor.o

conexao.o: conexao.h conexao.c
	$(CC) $(CFLAGS) -c conexao.c -o conexao.o

test: teste

teste: teste.c protocolo.o cliente.o servidor.o conexao.o
	$(CC) $(CFLAGS) -o teste teste.c protocolo.o cliente.o servidor.o conexao.o

clean:
	rm *.o
	rm cliente
	rm servidor
