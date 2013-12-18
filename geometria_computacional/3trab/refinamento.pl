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

# Cria os triangulos e as monta a lista de arestas. Por enquanto estou num
# dilema, pois se montar a lista de arestas e usar a DCEL, os triangulos e seus
# vizinhos serao praticamente inuteis. No momento estou decidindo montar os
# triangulos mesmo assim.
sub ashley {

  # Varia de 1 a $m
  my $index = shift;

  # Vertices do triangulo '$index':
  my $v1 = shift;
  my $v2 = shift;
  my $v3 = shift;

  # Vizinhos
  my $t1 = shift;
  my $t2 = shift;
  my $t3 = shift;

  # Pode dizer q parece feio, mas depois eh bem melhor p acessar e ver se jah
  # existe uma aresta
  ${$arestas}{"$v1, $v2"} = [$v1, $v2];
  ${$arestas}{"$v2, $v3"} = [$v2, $v3];
  ${$arestas}{"$v3, $v1"} = [$v3, $v1];

  # Agora criando o triangulo da linha $index, que talvez nao seja utilizado no
  # futuro.
  ${$triangulos}{$index}  = {
                              'vertices'  => [$v1, $v2, $v3],
                              'arestas'   =>  [
                                                # Note que estou adicionando
                                                # aqui os mesmos rotulos que
                                                # adicionei na hash arestas
                                                "$v1, $v2",
                                                "$v2, $v3",
                                                "$v3, $v1"
                                              ],
                              'vizinhos'  => [$t1, $t2, $t3]
                            };
} # /ashley

# Le entrada:
sub jessica {

  # Lendo num de vertices e triangulos:
  ($n, $m) = split ' ', <>;


  # Pra que gastar mais de uma linha de codigo para ler os vertices e empilhar
  # suas coordenadas em um vetor?
  push @$vertices, [ split ' ', <> ] for (1..$n);


  # Ashley vai montar os triangulos, e seus vizinhos *e tb as arestas (pelo
  # menos por enqto)*.
  ashley($_, split(' ', <>)) for (1..$m);

} #/jessica

########################
## Programa principal ##
########################

jessica();

print "@$_\n" for (@$vertices);

for (keys %$arestas) {
  print "Chave: $_\nValor: @{${$arestas}{$_}}\n";
}
