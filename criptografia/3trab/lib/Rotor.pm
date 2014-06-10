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

        # TODO: corrigir conforme novas especificacoes
        $deslocado  .= chr ((ord) + $eu->{DESLOCAMENTO});
      }

      $eu->{CIFRADO}  = $deslocado;
    }

    # XXX: Quando isso aqui for ativado, tem que inverter a ordem dos rotores.
    elsif ($deslocamento eq '-') {

      for (split //, $txt) {

        # TODO: corrigir conforme novas especificacoes
        $deslocado  .= chr ((ord) - $eu->{DESLOCAMENTO});
      }

      $eu->{DECIFRADO}  = $deslocado;
    }

    # TODO: inserir rotacao
  };  #/my $desloca


  # Ae, metodos publicos;

  sub sumona {

    # o 3o parametro deve ser uma referencia
    my ($classe,$deslocamento,$pinos_saida_ref) = @_;

    # O objeto em si
    my %hash;

    # um mapeamento de teclado
    my %teclado;

    my @pinos_entrada   = 1..26;

    $teclado{$_}        = (ord $_) - 97 for 'a'..'z';

    $hash{DESLOCAMENTO} = $deslocamento;
    $hash{TECLADO}      = %teclado;

    # Sempre tem q ter ao menos uma linha foda ;)
    unshift @pinos_entrada, pop @pinos_entrada for (1..$deslocamento);

    @{$hash{PINOS_ENTRADA}} = @pinos_entrada;
    @{$hash{PINOS_SAIDA}}   = @$pinos_saida_ref;

    # Todos os rotores sao iniciados com rodada == 0
    $hash{RODADA}           = 0;

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
