#!/usr/bin/env perl
# vim tw=0:ts=2:et:foldmethod=manual

use strict;
use warnings;

#######################
## Variaveis Globais ##
#######################

my $n;  # Num de vertices da triangulacao   Tipo: inteiro
my $m;  # Num de triangulos                 Tipo: inteiro

my $DCEL  = {}; # DCEL                      Tipo: referencia para uma hash de pares
                #                                 ordenados (tamanho: $n),
                #                                 indexada por inteiros

my $vertices;   # Adivinha..
my $arestas;    # ^^
my $triangulos;


###########
## Utils ##
###########

# Ajusta a malha de triangulos:
sub ashley {

  my $index = shift;

  # Vertices do triangulo '$index':
  my $v1 = shift;
  my $v2 = shift;
  my $v3 = shift;

  # Vizinhos
  my $t1 = shift;
  my $t2 = shift;
  my $t3 = shift;

  ${$triangulos}{$index}  = {
                              'vertices' => [$v1, $v2, $v3],
                              'vizinhos' => [$t1, $t2, $t3]
                            };

}

# Le entrada:
sub jessica {

  # Lendo num de vertices e triangulos:
  ($n, $m) = split ' ', <>;


  # Pra que gastar mais de uma linha de codigo para ler os vertices e empilhar
  # suas coordenadas em um vetor?
  push @$vertices, [ split ' ', <> ] for (1..$n);


  # Ashley vai montar os triangulos, e seus vizinhos.
  ashley($_, split(' ', <>)) for (1..$m);

  # TODO: Agora que lemos e construimos as estruturas basicas provenientes da
  # entrada, partimos para a construcao da DCEL
}


########################
## Programa principal ##
########################

jessica();

print "@$_\n" for (@$vertices);

