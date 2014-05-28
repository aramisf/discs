#!/usr/bin/perl -I lib/

use strict;
use warnings;

################################################################################
# Os parametros tem o seguinte formato:                                        #
# ./$0 z1..z5 arq.txt                                                          #
#                                                                              #
# Onde:                                                                        #
# - z[1-5] sao numeros inteiros;                                               #
# - arq.txt eh o arquivo texto a ser cifrado/decifrado pela maquina de         #
#   rotores.                                                                   #
################################################################################

use Rotor;

#sub uso {
#
#  print "Uso:\n\t$0 z1..zn <arquivo texto>\n";
#  exit 1;
#}
#
#uso() if not @ARGV;
#uso() if $ARGV[-1] and not -f $ARGV[-1];


my $rotor = Rotor->sumona(2);
$rotor->cifra("abc def");

print $rotor->{CIFRADO},"\n";
