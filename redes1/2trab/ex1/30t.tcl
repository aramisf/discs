# Enunciado:
# 12. Rede em estrela montada como 2 árvores, em cada uma um switch principal,
# conectado com 6 switches a 100Mbps, cada um destes com 20 máquinas a 10 Mbps,
# os 2 switches principais conectados por um cabo a 1Gbps.
# - variar a qtde de transmissores 30/40/50/60 transmissores - todos os
# transmissores em uma das árvoes;
# - 10 receptores - todos os receptores na outra árvore;
# - cada transmissor gera 20 mensagens por segundo;
# - atraso da transmissão 10 ms;
# - simular 3 minutos de vida da rede;
# - gerar gráfico da taxa de entrega e da latência da rede.

# Iniciando o simulador:
set ns [new Simulator]

# Escolhendo um arquivo para saida:
#set out30 [open out30.nam w]

#$ns namtrace-all $out30

set saida30 [open saida30.tr w]
$ns trace-all $saida30

# Variaveis:
set RECS 10
set SWITCHES 2
set SUBSWITCHES 6
set TRANS30 30

# Definindo procedimento para saida:
proc finish {} {

	global ns out30 saida30
    $ns flush-trace
	# Fechando arquivo
	close $out30
    close $saida30
	# Saindo
	exit 0
}


# Os 2 switches principais:
for {set i 0} {$i < $SWITCHES} {incr i} {

	set main_switch($i) [$ns node]
}

# Ligados por um cabo a 1Gbps:
$ns duplex-link $main_switch(0) $main_switch(1) 1Gb 10ms DropTail

# Cada switch principal conectado a 6 outros sub switches totalizam 12 switches:
for {set i 0} { $i < [expr $SUBSWITCHES*2] } {incr i} {

	# Defininfo os sub switches:
	set sub_switch($i) [$ns node]

	# Jah aproveitando e ligando os caras (a 100Mb) nos principais:
	$ns duplex-link $sub_switch($i) $main_switch([expr $i/$SUBSWITCHES]) 100Mb 10ms DropTail


	# Conectando as 20 maquinas a cada um dos sub switches:
	for {set j $i} {$j < 240} {incr j 12} {

		# Definindo as maquinas:
		set maq($j) [$ns node]

		# Conectando elas aos sub switches:
		$ns duplex-link $sub_switch($i) $maq($j) 10Mb 100ms DropTail
	}
}

# Mais uns loops aqui para controlar quem serao os transmissores e quem serao
# os receptores:

# Receptores: (estao na 2a arvore)
for {set i 0} {$i < 10} {incr i} {

	set null($i) [new Agent/Null]

	# Soma 120 aqui, para pegar as maquinas da outra arvore:
	$ns attach-agent $maq([expr $i+120]) $null($i)

}

# 30 Transmissores: (estao na 1a arvore)
for {set i 0} {$i < $TRANS30} {incr i} {

	set udp($i) [new Agent/UDP]

	# Depois dessa linha, a maq(i) sera um agente udp
	$ns attach-agent $maq($i) $udp($i)

    # Agora conecta a maq atual com uma da outra arvore
    $ns connect $udp($i) $null([expr $i/($TRANS30/$RECS)])

    # Definindo as propriedades da conexao
    $udp($i) set fid_ $i
    $udp($i) set packetSize_ 500

	# Agora, ligando uma aplicacao com as 30 maquinas
	set cbr($i) [new Application/Traffic/CBR]
	#$cbr($i) set packetSize_ 500
	$cbr($i) set interval_ 0.00005
	$cbr($i) attach-agent $udp($i)

    $ns at 0 "$cbr($i) start"
    $ns at 10.0 "$cbr($i) stop"
}

	# Finalizando
	$ns at 10.5 "finish"

	# Vai Filhao!
	$ns run

