#!/bin/bash

# This script must do:
#-> To generate an average delivery rate graphic:
#-> To generate an average delay graphic
#    -> Achar p/ cada mensagem
#       Atraso = Tempo de chegada - Tempo de criacao da msg
#    -> Calcular media para todas as mensagens
#-> Repetir cada simulacao 3 vezes com sementes diferentes para
#   o gerador de numeros aleatorios e calcular a media

# Variaveis globais
CONTINUE="nao"
COUNT=0
bc_args='-l'

check_args () {

    if [ -n "$1" ] && [ -f "$1" ]; then
        echo "Meus Parametros: $@"
        export ARQ=$1
        export ARQ_LINES=$(wc -l $ARQ|cut -d' ' -f1)
        echo "LINHAS: $ARQ_LINES"
        export ID_MSG=$(sort -k12 -n $ARQ|tail -1|cut -d' ' -f12)
        echo "$ID_MSG mensagens"
        export ADDER=${ARQ//[^0-9]/}
        echo "Adder: $ADDER"
        export CONTINUE="sim"
    else
        read -p "Calcular taxa de entrega para todos os arquivos .tr neste diretorio?[S/n] " ANSW
        if test -z "$ANSW"  || [[ "$ANSW" =~ [Ss].* ]]; then
            CONTINUE="sim"
            echo "aceito"
        else
            CONTINUE="nao"
            echo "rejeitado"
        fi
    fi
}

calcula_taxa () {
    export RECEBIDOS=$(cut -d" " -f1 ${ARQ} | grep -c r)
    export PERDIDOS=$(cut -d" " -f1 ${ARQ} | grep -c d)
    export ENVIADOS=$(echo "${RECEBIDOS} + ${PERDIDOS}" | bc -l)
    export TAXA=$(echo "(${RECEBIDOS} / ${ENVIADOS}) * 100" | bc -l)
}

exibe_taxa () {
    echo -e "Exibindo valores para o arquivo $ARQ:\n"
    echo "Número de pacotes recebidos = $RECEBIDOS"
    echo "Número de pacotes perdidos = $PERDIDOS"
    echo "Número de pacotes enviados = $ENVIADOS"
    echo "Taxa de entrega = $TAXA %"
    echo $ADDER $TAXA >> taxa.plot
    echo $TAXA $ADDER >> tax.plot
}

organiza_taxa () {

    if [ -n "$ARQ" ]; then
        calcula_taxa
        exibe_taxa
    else
        for arq in tr_files/*; do
            $0 $arq
        done
    fi
}

# Calcula a latencia de banda, recebe 2 parametros, o arquivo .tr e o numero de
# transmissores/receptores correspondente. Ex. se o arquivo gerado contem 30
# transmissores, entao deve-se chamar esta funcao assim:
# $ latencia $ARQ $VARS
# No caso, podemos colocar este valor como segundo parametro do script
gera_ListadeLatencia () {
    if test ! -d latencias; then
        mkdir latencias
    fi
    for ((i=0; i < 10; i++)); do
        # Pegando a id de cada pacote (final da linha)
        grep " $((i*($ID_MSG/10)))$" $ARQ > latencias/$i.tr
        echo -n +
    done
    echo
    #head -$VARS $ARQ >| $TMP
    #RECEBIDOS=($(grep ^r $ARQ|head -$VARS))
    #exit 0
}


#
# Contagem amostral
#
calcula_latencia () {
    gera_ListadeLatencia
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
        latencia_total=$(echo $soma / $count | bc $bc_args)

        # gravando as latencias
        export lt=$(sed 's@\.@0&@g' <<< $latencia_total)
        echo $ADDER $lt >> latencia.plot
        echo $lt $ADDER >> lat.plot
        echo latencia $lt ms

}

criner () {

    [ -d latencias ] && rm -r latencias
    #[ -f latencia.plot ] && rm latencia.plot
    #[ -f taxa.plot ] && rm taxa.plot
}

harry_plotter () {

    gnuplot taxa.gnu
    gnuplot tax.gnu
    gnuplot latencia.gnu
    gnuplot lat.gnu
}
### MAIN
main () {

    check_args $@
    if [[ "$CONTINUE" == "sim" ]]; then
        organiza_taxa
        calcula_latencia
    else
        echo "Abortado"
        exit 1
    fi
}

criner
main $@
harry_plotter

