#    SWITCH
#    /     \ -> 1Gbps
#     ...       \
#10 X  --->    SWITCH
#          | ... |  -> 100Mbps
#         Maquinas
#
#-> Simular 3 minutos de vida da rede
#-> Escolher aleatoriamente 10 origens e 2 destinos
#-> Cada origem deve gerar as seguintes quantidades de mensagens
#   por segundo  1/10/100/1.000/10.000
#-> Gerar grafico com a taxa de entrega media:
#    TxEnt = Num Mesg Recebida / Num Msg Enviado
#-> Gerar grafico com o atraso medio
#    -> Achar p/ cada mensagem
#       Atraso = Tempo de chegada - Tempo de criacao da msg
#    -> Calcular media para todas as mensagens
#-> Repetir cada simulacao 3 vezes com sementes diferentes para
#   o gerador de numeros aleatorios e calcular a media
#-> Duplex
#
#*Obs - +0,2 para graficos no gnuplot
#
#10 e 12 nov

# Iniciando o simulador:
set ns [new Simulator]

# (des)?comentar para obter uma saida para o nam:
#set saida_nam [open mps1.nam w]
#$ns namtrace-all $saida_nam

# (des)?comentar para obter um arquivo .tr
set saida_tr [open tr_files/mps100.tr w]
$ns trace-all $saida_tr

# Mensagens por segundo
set MESGS 100

### VARIAVEIS
set SUBSWITCHES 10
set MAQS 7
set EMISSORES 10
set RECEPTORES 2
set START 0.0
set STOP 180.0
set END 181.0

# Maximo de maquinas da rede:
set MAX [expr $MAQS * $SUBSWITCHES]

# Semente:
set SEED 5

expr srand($SEED)

# Definindo procedimento para saida:
proc finish {} {

	global ns
    #global saida_nam
    global saida_tr
    $ns flush-trace
    #close $saida_nam
    close $saida_tr
	exit 0
}

proc aleatorio {seed} {

    return [expr {int(rand()* $seed)}]
}

# O switch principal:
set main_switch [$ns node]
$main_switch color yellow

# Switch principal conectado a 10 outros sub switches:
for {set i 0} {$i < $SUBSWITCHES} {incr i} {

	set sub_switch($i) [$ns node]
    $sub_switch($i) color green
	$ns duplex-link $sub_switch($i) $main_switch 1Gb 10ms DropTail

	# Conectando as maquinas a cada um dos sub switches:
	for {set j $i} {$j < [expr $MAQS*$SUBSWITCHES]} {incr j $SUBSWITCHES} {

		set maq($j) [$ns node]
        $maq($j) color blue
		$ns duplex-link $sub_switch($i) $maq($j) 100Mb 100ms DropTail
	}
}

# Criando os 2 destinos
set receptor1 [aleatorio $MAX]
set receptor2 [aleatorio $MAX]
while {$receptor1 == $receptor2} {

    set receptor2 [aleatorio $MAX]
}

set null0 [new Agent/Null]
set null1 [new Agent/Null]
$ns attach-agent $maq($receptor1) $null0
$ns attach-agent $maq($receptor2) $null1
$maq($receptor1) color orange
$maq($receptor2) color orange


# Criando as 10 origens aleatorias
for {set i 0} {$i < $EMISSORES} {incr i} {

    set emissor($i) [aleatorio $MAX]
    while {$emissor($i) == $receptor1 || $emissor($i) == $receptor2} {
        set emissor($i) [aleatorio $MAX]
    }

    set udp($i) [new Agent/UDP]
    $ns attach-agent $maq($emissor($i)) $udp($i)
    $maq($emissor($i)) color red

    # Agora, ligando uma aplicacao com as maquinas
    set cbr($i) [new Application/Traffic/CBR]
    set interval [expr 1.0 / $MESGS]
    $cbr($i) set interval_ $interval
    $cbr($i) set packetSize_ 500
    $cbr($i) attach-agent $udp($i)

    $ns connect $udp($i) $null0
    $ns connect $udp($i) $null1

    $ns at $START "$cbr($i) start"
    $ns at $STOP "$cbr($i) stop"
}

    $ns at $END "finish"
    $ns run
