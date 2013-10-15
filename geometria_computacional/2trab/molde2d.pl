#!/usr/bin/perl
# vim: tw=0:ts=2:et

use strict;
use warnings;


########################
## Variaveis globais: ##
########################

my $n;          # num de pontos a serem lidos
my $pontos;     # lista de pontos lidos


#########################
## Programa principal: ##
#########################

chomp ($n = <STDIN>);             # Numero de pontos
for (my $i = 0; $i < $n; $i++) {  # Pontos com duas coordenadas

  chomp($_ = <STDIN>);
  push @$pontos, [split] ;
}


