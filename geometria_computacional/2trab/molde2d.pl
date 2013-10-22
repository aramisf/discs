#!/usr/bin/perl
# vim: tw=0:ts=2:et

use strict;
use warnings;


#########################
## ariaveis globais: ##
#########################

my $n;          # num de pontos a serem lidos
my $pontos;     # lista de pontos lidos
my $vetores;    # vetores das retas (B-A)


####################
## erramentas : ##
####################

sub calcula_vetores {

  for (my $i=0; $i < @$pontos-1; $i++) {

    push @$vetores, [
                      $$pontos[$i+1][0] - $$pontos[$i][0],
                      $$pontos[$i+1][1] - $$pontos[$i][1]
                    ];
  }

  push @$vetores, [
                    $$pontos[0][0] - $$pontos[@$pontos-1][0],
                    $$pontos[0][1] - $$pontos[@$pontos-1][1]
                  ];

} # /calcula_vetores

##########################
## rograma principal: ##
##########################

chomp ($n = <STDIN>);             # Numero de pontos
for (my $i = 0; $i < $n; $i++) {  # Pontos com duas coordenadas

  chomp($_ = <STDIN>);
  push @$pontos, [split];
}

calcula_vetores();
