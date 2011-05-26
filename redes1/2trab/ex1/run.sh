#!/bin/bash
# Este script supoe que o ns esta configurado e rodando corretamente
for i in 30 40 50 60 ;do
    echo rodando ns $i
    ns ${i}t.tcl &&
    echo calculando as taxas $i
    ./taxas.sh saida$i.tr
done &&
echo plotando.
gnuplot saida.gnu latencia.gnu
