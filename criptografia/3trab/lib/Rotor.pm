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

    # mapeamento dos pinos de saida
    my %pinos_saida;

    my @pinos_entrada   = 1..26;

    $hash{DESLOCAMENTO} = $deslocamento;

    # Sempre tem q ter ao menos uma linha foda ;)
    # Uma linha como esta sera executada tambem toda vez que um caractere for
    # lido da entrada. Conforme metodo 'gira_catraca'
    unshift @pinos_entrada, pop @pinos_entrada for (1..$deslocamento);

    @{$hash{PINOS_ENTRADA}} = @pinos_entrada;
    
    # Nessa linha sinistra, a hash $hash{PINOS_SAIDA} esta sendo criada com as
    # chaves obtidas a partir dos elementos da lista @$pinos_saida_ref, e os
    # valores de cada uma destas chaves esta sendo atribuido respectivamente a
    # um dos valores da lista retornada por 0..25. Eh como se eu estivesse
    # usando os valores da lista @$pinos_saida_ref como CHAVES da nova hash, e
    # os indices dessa mesma lista como VALORES para a nova hash. Isso sera
    # utilizado para 'apertar' a tecla correta da proxima catraca.
    @{$hash{PINOS_SAIDA}}{@$pinos_saida_ref}  = 0..25;

    # E como havera rotacao das catracas, ha necessidade de atualizar esta
    # hash, entao vamos armazenar tambem uma lista com os valores lidos
    @{$hash{PINOS_SAIDA_REF}}                 = @$pinos_saida_ref;

    # Todos os rotores sao iniciados com rodada == 0
    $hash{RODADA}           = 0;

    # Depois desta linha $hash sera um objeto da classe $classe :)
    bless \%hash  => $classe;
  }

  sub gira_catraca {

    my ($eu)  = @_;

    # conta rodada
    $eu->{RODADA}++;

    # gira uma vez os pinos de entrada
    unshift @{$eu->{PINOS_ENTRADA}}, pop @{$eu->{PINOS_ENTRADA}};

    # e uma vez os pinos de saida
    unshift @{$eu->{PINOS_SAIDA_REF}}, pop @{$eu->{PINOS_SAIDA_REF}};
    @{$eu->{PINOS_SAIDA}}{@{$eu->{PINOS_SAIDA_REF}}} = 0..25;

  }

  sub cifrar {

    my ($eu, $pino)  = @_;

    # Contando giros completos
    if ($eu->{RODADA} == 26) {

      $eu->{RODADA} = 0;
      $eu->{PROXIMO}->gira_catraca() if defined $eu->{PROXIMO};
    }

    # Aqui comeca a cifragem em si
    my $p1    = $eu->{PINOS_ENTRADA}[$pino];
    my $p2    = $eu->{PINOS_SAIDA}{$p1};

    # Deu boa, agora eh soh enviar o sinal para o pino de entrada do proximo
    # rotor
    $eu->{PROXIMO}->cifrar($p2) if defined $eu->{PROXIMO};

    # Soh imprime o resultado final quando for a ultima catraca
    print chr $p2+97," " if not defined $eu->{PROXIMO};

    # A primeira catraca gira ao final do processamento de cada caractere Caso
    # esta linha seja comentada, a saida ficara parecida com o exemplo do
    # livro, onde os 3 primeiros caracteres sao inseridos sem q a 1a catraca
    # gire
    $eu->gira_catraca() if not defined $eu->{ANTERIOR};
  }

  sub decifra {

    my ($eu, $pino)  = @_;

    # A primeira catraca gira a cada caractere processado
    $eu->gira_catraca() if not defined $eu->{ANTERIOR};

    # Contando giros completos
    if ($eu->{RODADA} == 26) {

      $eu->{RODADA} = 0;
      $eu->{PROXIMO}->gira_catraca() if defined $eu->{PROXIMO};
    }

    # Aqui comeca a cifragem em si
    my $p1    = $eu->{PINOS_ENTRADA}[$pino];
    my $p2    = $eu->{PINOS_SAIDA}{$p1};

    # Deu boa, agora eh soh enviar o sinal para o pino de entrada do proximo
    # rotor
    $eu->{PROXIMO}->cifrar($p2) if defined $eu->{PROXIMO};

    # Soh imprime o resultado final quando for a ultima catraca
    print chr $p2+97,"\n" if not defined $eu->{PROXIMO};
  }

  sub rotaciona {

    my ($eu)        = @_;

  }
1;
