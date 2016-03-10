#!/bin/bash

TIMESTAMP='2014-01-01 00:00:00'
DESTINO=recentes/

[ ! -d "$DESTINO" ] && mkdir $DESTINO

find .  -type f \
        -iname \*pdf \
        -newermt "$TIMESTAMP" \
        -maxdepth 1\
        -exec cp {} $DESTINO \;
