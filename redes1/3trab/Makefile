CC = gcc
PREFIX = ${HOME}
BIBLIOTECA = cabecalho.h
OBJS = main.o diversos.o servidor.o cliente.o 
.c.o:
	@$(CC) -c -o $@ $<

token_ring: $(OBJS) cabecalho.h
	@echo "compilando..."
	@$(CC) -g -lpthread $(OBJS) -o $@ 

main.o:     main.c     $(BIBLIOTECA)
diversos.o: diversos.c $(BIBLIOTECA)
servidor.o: servidor.c $(BIBLIOTECA)
cliente.o:  cliente.c  $(BIBLIOTECA)

limpa:
	@rm -rf *~ 
	@rm -rf *.bak
	@rm -rf core*
	@echo "eliminando arquivos temporarios..."

faxina: limpa
	@rm -rf *.o
	@rm -rf token_ring
	@echo "eliminando arquivos objetos..."
	@echo "eliminando arquivo principal..."

