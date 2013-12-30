#!/usr/bin/perl
# vim: ts=2:foldmethod=manual:et:tw=0:sw=1

use strict;
use warnings;

#############
## Globais ##
#############

my $BORDA = 999999999;  # Limite do espaco euclidiano
my $vertices;           # Hash indexada de vertices

# Valores mais distantes nos eixos. Estes serao os vertices candidatos para
# montar o primeiro simplexo. A variavel abaixo armazena a lista dos rotulos de
# tais vertices.
my $extremos;


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

  # Indice 0 -> rotulo do vertice;
  # Indice 1 -> valor da coordenada; (local, apenas para comparacao)
  my @max_x = (0,-$BORDA);
  my @max_y = (0,-$BORDA);
  my @max_z = (0,-$BORDA);

  my @min_x = (0,$BORDA);
  my @min_y = (0,$BORDA);
  my @min_z = (0,$BORDA);

  # Ordenando as chaves numericamente pq quero q a busca seja conforme os dados
  # informados na entrada. Os primeiros valores serao os definidos, se houver
  # empate, o primeiro ponto encontrado sera o ponto q fica.
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

  # Retornando os indices dos extremos encontrados, na sequencia:
  # menor x, maior x,
  # menor y, maior y,
  # menor z, maior z.

  return  [ $min_x[0],$max_x[0],
            $min_y[0],$max_y[0],
            $min_z[0],$max_z[0],
          ];

} #/petyr

##########
## Main ##
##########
