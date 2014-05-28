#!/usr/bin/perl

use strict;
use warnings;


################################################################################
# Definindo a Classe Rotor. O programa principal vai gerenciar a quantidade de #
# rotores existente, pegando a saida do i-esimo rotor e usando-a para          #
# alimentar o (i+1)-esimo elemento. O numero de rotores eh definido pela       #
# quantidade de parametros numericos (somente numeros naturais) passados como  #
# parametro na entrada. Veja os comentarios do programa principal              #
################################################################################

package Rotor;

  sub sumona {

    my ($classe,$deslocamento) = @_;
    my %hash;

    # Caso nao seja passado um parametro de instanciacao, o rotor move apenas
    # uma posicao
    $hash{DESLOCAMENTO} = $deslocamento || 1;

    # Depois desta linha $hash sera um objeto da classe $classe :)
    bless \%hash  => $classe;
  }

  sub cifra {

    my ($eu,$txt)  = @_;
    my $cifrado;

    for (split //, $txt) {

      $cifrado  .= chr ((ord) + $eu->{DESLOCAMENTO});
    }

    $eu->{CIFRADO}  = $cifrado;
  }

1;
