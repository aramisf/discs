#!/usr/bin/env perl
# vim tw=0:ts=2:et:foldmethod=manual

use strict;
use warnings;

#######################
## Variaveis Globais ##
#######################

my $n;  # Num de vertices da triangulacao   Tipo: inteiro
my $m;  # Num de triangulos                 Tipo: inteiro

my $nuvem       # Nuvem de pontos           Tipo: referencia para uma hash de pares
                #                                 ordenados (tamanho: $n),
                #                                 indexada por inteiros



# Lendo dados da entrada padrao:
