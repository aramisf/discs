#!/usr/bin/perl
# vim: ts=2:foldmethod=manual:et:tw=0:sw=1

use strict;
use warnings;

#############
## Globais ##
#############

my $vertices;     # Hash indexada de vertices

# Valores mais distantes nos eixos. Estes serao os vertices candidatos para
# montar o primeiro simplexo. Indexados pelo rotulo do vertice, contendo o
# valor do eixo em questao
my %maior_x;
my %maior_y;
my %maior_z;

my %menor_x;
my %menor_y;
my %menor_z;


###########
## Funcs ##
###########

# Le os dados da entrada padrao e monta a lista indexada de vertices. As chaves
# sao inteiros q indexam a lista, e cada chave possui um array anonimo como
# valor, contento as 3 coordenadas do vetor indexado pelo numero da linha sendo
# lida.
sub arya {

  ${$vertices}{$.} = [split] while <>;
}

# Seleciona vetores candidatos a extremos para o simplexo inicial:
sub petyr {

  # Considera que os pares abaixo serao pares 'chave->valor' ao final desta
  # funcao
  my @max_x = (0,0);
  my @max_y = (0,0);
  my @max_z = (0,0);

  my @min_x = (0,999999999);
  my @min_y = (0,999999999);
  my @min_z = (0,999999999);

  # Ordenando as chaves numericamente pq quero q a busca seja conforme os dados
  # informados na entrada. Os primeiros valores serao os definidos, se houver
  # mais de um ponto extremo com uma coordenada especifica em um eixo, ele nao
  # sera considerado
  for (sort {$a <=> $b} keys %$vertices) {

    # Busca maior e menor coordenadas em x:
    if (${$vertices}{$_}->[0] > $max_x[1]) {

      $max_x[0] = $_;
      $max_x[1] = ${$vertices}{$_}->[0]

    } elsif (${$vertices}{$_}->[0] < $min_x[1]) {

      $min_x[0] = $_;
      $min_x[1] = ${$vertices}{$_}->[0]
    }

    # Busca maior e menor coordenadas em y:
    if (${$vertices}{$_}->[1] > $max_y[1]) {

      $max_y[0] = $_;
      $max_y[1] = ${$vertices}{$_}->[1]

    } elsif (${$vertices}{$_}->[1] < $min_y[1]) {

      $min_y[0] = $_;
      $min_y[1] = ${$vertices}{$_}->[1]
    }

    # Busca maior e menor coordenadas em z:
    if (${$vertices}{$_}->[2] > $max_z[1]) {

      $max_z[0] = $_;
      $max_z[1] = ${$vertices}{$_}->[2]

    } elsif (${$vertices}{$_}->[2] < $min_z[1]) {

      $min_z[0] = $_;
      $min_z[1] = ${$vertices}{$_}->[2]
    }
  } #/for (keys %$vertices)

  # Agora que os extremos foram encontrados, insiro-os nas hashes globais:
  %maior_x = @max_x;
  %maior_y = @max_y;
  %maior_z = @max_z;

  %menor_x = @min_x;
  %menor_y = @min_y;
  %menor_z = @min_z;

} #/petyr

##########
## Main ##
##########
