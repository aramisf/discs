CC = gcc
CFLAGS = -Wall -ansi
SRC = ../src/
BINDIR = ../bin/
OBJDIR = ../obj/
OBJ = terapia-tumores.o hash.o produtores.o consumidores.o arvore-avl.o

all: make-tree $(OBJ)
	cd $(OBJDIR) && gcc $(OBJ) -o $(BINDIR)/terapia-tumores -lrt -lm -lpthread

make-tree:
	mkdir -p $(BINDIR)
	mkdir -p $(OBJDIR)

terapia-tumores.o: $(SRC)/terapia-tumores.c $(SRC)/terapia-tumores.h
	cd $(SRC) && gcc -c terapia-tumores.c -o $(OBJDIR)/terapia-tumores.o

produtores.o: $(SRC)/produtores.c $(SRC)/produtores.h
	cd $(SRC) && gcc -c produtores.c -o $(OBJDIR)/produtores.o

consumidores.o: $(SRC)/consumidores.c $(SRC)/consumidores.h
	cd $(SRC) && gcc -c consumidores.c -o $(OBJDIR)/consumidores.o

arvore-avl.o: $(SRC)/arvore-avl.c $(SRC)/arvore-avl.h
	cd $(SRC) && gcc -c arvore-avl.c -o $(OBJDIR)/arvore-avl.o

hash.o: $(SRC)/hash.c $(SRC)/hash.h
	cd $(SRC) && gcc -c hash.c -o $(OBJDIR)/hash.o

clean:
	rm -rf $(OBJDIR)
	rm -rf $(BINDIR)
