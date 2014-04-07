#!/usr/bin/perl

package Playfair;   # TODO: To pensando se faco um modulo ou uma classe, mas
                    # acho q vai ser um modulo mesmo

use strict;
use warnings;

# Gera o conjunto de intervalos de caracteres para gerar as chaves por forca
# bruta. Os intervalos vao de 'a' a 'z', de 'aa' a 'zz' e assim por diante,
# ateh atingir o tamanho informado como parametro.
#
# Parametros: um inteiro indicando a quantidade de inteiros na chave
# Saida: retorna o array com as meta-chaves
#
sub gera_meta_chaves {

  # Se for uma classe
  #my $self    = $_[0];
  #my $maxlen  = $_[1];

  # Mas se for um modulo:
  my $maxlen  = shift;

  my @meta_chaves;
  push @meta_chaves, ['a'x$_,'z'x$_] for 1..$maxlen;

  @meta_chaves;
}

# Decifra um texto global, usando uma chave passada como parametro.
#
# TODO: ver um esquema para gerar a matriz de decifragem.
#
# Parametros: uma string (que pode ser um texto gigante)
# Saida:      um arquivo cujo nome eh a chave utilizada para decriptografar o
#             texto passado como parametro.
sub decrypt {

  # - Subdividir a string dois a dois caracteres, tratando os casos de
  #   duplicidade;
  my $texto_claro = shift;

  # - fazer a decriptografia baseando-se na matriz de decriptografia atual;

  # Imprimir o resultado em um arquivo:
  "Dae\n";
}

# TODO:
# Parametros: uma string que corresponde aa chave de criptografia
# Saida:      a matriz, que deve ser armazenada no proprio objeto
sub gera_matriz {

}
1;
