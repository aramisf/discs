CC = g++
SRC = graphgen.cc 
BIN = gerador

all:
	@echo "Compilando."
	@$(CC) -o $(BIN) $(SRC)
	@echo "Feito."

clean:
	@if [ -f $(BIN) ]; then rm $(BIN); fi
	@if [ -d resultados ]; then rm -r resultados; fi
	@echo "Feito."
