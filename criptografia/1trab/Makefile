# Parametros do grep. Note o $$ no final, ele vai se tornar um $ para o grep,
# essa sintaxe eh do makefile.
GREP_OPTS=-E ^[a-zA-Z]{1,6}$$

# Parametros do iconv (meu salvador)
ICONV_OPTS=-f ISO8859-1 -t ascii//TRANSLIT

# Dicionarios em portugues, emprestados do aspell ;)
BR=/usr/share/dict/brazilian
PT=/usr/share/dict/portuguese

# Minhas listas locais:
WD=wordlists
MY_BR=$(WD)/lista_br
MY_PT=$(WD)/lista_pt
PT_BR=$(WD)/lista_pt-br
FINAL=lista

# Nome do executavel
EXEC=playfair

# Diretorio com os resultados
RESULTADOS=resultados

all:
	@echo "Criando o executavel"
	@cp pf.pl $(EXEC)
	@chmod +x $(EXEC)
	@echo "Criando diretorio para os resultados.."
	@mkdir $(RESULTADOS) 2>/dev/null
	@echo "Criando diretorio para listas de palavras..."
	@echo "Criando lista de palavras..."
	@mkdir $(WD) 2> /dev/null
	@iconv $(ICONV_OPTS) $(BR) -o $(MY_BR)
	@iconv $(ICONV_OPTS) $(PT) -o $(MY_PT)
	@grep $(GREP_OPTS)  $(MY_BR) > $(PT_BR)
	@grep $(GREP_OPTS)  $(MY_PT) >> $(PT_BR)
	@sort -u $(PT_BR) -o $(FINAL)
	@echo -n "\nExecute o programa com:\n\n\t./playfair "
	@echo "<arquivo com texto cifrado> <arquivo com chaves para decifrar (por ex: lista)>\n"


clean:
	@echo "Removendo listas.."
	@rm -rf $(WD)
	@rm -f $(FINAL)
	@echo "Removendo executavel.."
	@rm -f $(EXEC)
	@echo "Removendo diretorio dos resultados.."
	@rm -rf $(RESULTADOS)
	@echo "Feito"


teste:
	@echo "Testando sistema:"
	@prove -I lib/


