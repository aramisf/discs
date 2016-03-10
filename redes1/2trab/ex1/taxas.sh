#!/bin/bash
# Funcoes variadas para calcular estatisticas sobre os dados gerados com o ns2
# O programa deve receber 2 parametros, um arquivo existente e um valor, que
# corresponde a qtde de transmissores/receptores na rede.

if [[ -n "$1" && -f "$1" ]]; then
    export ARQ=$1
    export VARS=${ARQ//[^0-9]/}
else
    echo "Favor passar um arquivo existente como parametro"
    exit 1
fi
RECEBIDOS=$(cut -d" " -f1 ${ARQ} | grep -c r)
PERDIDOS=$(cut -d" " -f1 ${ARQ} | grep -c d)
ENVIADOS=$(echo "${RECEBIDOS} + ${PERDIDOS}" | bc -l)
TAXA=$(echo "(${RECEBIDOS} / ${ENVIADOS}) * 100" | bc -l)
count=0
input_file=$1
bc_args=""
SIZE=20

taxa_de_entrega () {
    echo "Número de pacotes recebidos = $RECEBIDOS"
    echo "Número de pacotes perdidos = $PERDIDOS"
    echo "Número de pacotes enviados = $ENVIADOS"
    echo "Taxa de entrega = $TAXA %"
}

# Calcula a latencia de banda, recebe 2 parametros, o arquivo .tr e o numero de
# transmissores/receptores correspondente. Ex. se o arquivo gerado contem 30
# transmissores, entao deve-se chamar esta funcao assim:
# $ latencia $ARQ $VARS
# No caso, podemos colocar este valor como segundo parametro do script
latencia () {
    if test ! -d latencias; then
        mkdir latencias
    fi
    for ((i=0; i < $VARS*7; i+=7)); do
        grep " $i$" $ARQ > latencias/$i.tr
        echo -n +
    done
    echo
    #head -$VARS $ARQ >| $TMP
    #RECEBIDOS=($(grep ^r $ARQ|head -$VARS))
    #exit 0
}

latencia
taxa_de_entrega

#
# Contagem amostral
#
count=0
for input_file in latencias/*
do
    tempo_inicio=$(cut -d' ' -f2 $input_file | head -1)
    tempo_fim=$(cut -d' ' -f2 $input_file | tail -1)
    latencia[$count]=$(echo $tempo_fim - $tempo_inicio|bc $bc_args)
    # who=$(tail -1 $input_file | cut -d' ' -f12)
    # echo $VARS $latencia[$count] >> latencia.in
    echo -n .
    count=$(($count + 1))
done
echo

#
# Calculando latencia
#
soma=0
for((i=0; i<$count; i++)); do
    soma=$(echo ${latencia[i]} + $soma | bc)
done
latencia_total=$(echo $soma / $count | bc $bc_args -l)

# gravando as latencias
lt=$(sed 's@\.@0&@g' <<< $latencia_total)
echo $VARS $lt >> latencia.plot
echo latencia $lt ms

