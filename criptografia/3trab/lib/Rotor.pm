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


  # Por convencao, a galera coloca _ antes dos nomes, mas o metodo aqui se
  # torna privado porque esta sendo referenciado na variavel $desloca, que eh
  # visivel apenas dentro do escopo local, ou seja, apenas pelos metodos
  # internos da Classe.
  # TODO: 'our'?
  my $desloca = sub {

    my ($eu,$deslocamento,$txt)  = @_;
    my $deslocado;

    if ($deslocamento eq '+') {
      for (split //, $txt) {

        $deslocado  .= chr ((ord) + $eu->{DESLOCAMENTO});
      }

      $eu->{CIFRADO}  = $deslocado;
    }

    # XXX: Quando isso aqui for ativado, tem que inverter a ordem dos rotores.
    elsif ($deslocamento eq '-') {

      for (split //, $txt) {

        $deslocado  .= chr ((ord) - $eu->{DESLOCAMENTO});
      }

      $eu->{DECIFRADO}  = $deslocado;
    }

  };  #/my $desloca


  # Ae, metodos publicos;

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

    my ($eu, $txt)  = @_;
    $eu->$desloca('+', $txt);
  }

  sub decifra {

    my ($eu, $txt)  = @_;
    $eu->$desloca('-', $txt);
  }
1;
