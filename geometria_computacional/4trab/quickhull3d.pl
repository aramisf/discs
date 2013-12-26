#!/usr/bin/perl
# vim: ts=2:foldmethod=manual:et:tw=0:sw=1

use strict;
use warnings;

#############
## Globais ##
#############

my $vertices;     # Hash indexada de vertices

###########
## Utils ##
###########

# Le os dados da entrada padrao e monta a lista indexada de vertices. As chaves
# sao inteiros q indexam a lista, e cada chave possui um array anonimo como
# valor, contento as 3 coordenadas do vetor indexado por $linha.
sub arya {

  my $linha = 1;
  ${$vertices}{$linha++} = [split] while <>;
}

##########
## Main ##
##########

arya();

print "C: $_ V: @{${$vertices}{$_}}\n" for (keys %$vertices);
