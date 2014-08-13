#!/bin/bash

TIMESTAMP='2014-01-01 00:00:00'
DESTINO=recentes/

# Cria diretorio caso nao haja
[ ! -d "$DESTINO" ] && mkdir $DESTINO

# Encontra apenas arquivos mais novos que TIMESTAMP
find .  -type f \
        -iname \*pdf \
        -newermt "$TIMESTAMP" \
        -maxdepth 1\
        -exec cp {} $DESTINO \;
