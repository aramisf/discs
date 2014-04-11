#!/usr/bin/perl

use strict;
use warnings;

# Criando um modulo importavel, nao vo exportar nada aqui com o intuiro de
# manter o namespace limpo, jah que o programa usara forca bruta.
#
package Playfair;


# Gera o conjunto de intervalos de caracteres para gerar as chaves por forca
# bruta. Os intervalos vao de 'a' a 'z', de 'aa' a 'zz' e assim por diante,
# ateh atingir o tamanho informado como parametro. Esta funcao eh meramente
# uma ferramenta para a funcao que criara a lista de chaves para a forca
# bruta.
#
# Parametros: um inteiro indicando a quantidade de inteiros na chave
# Saida: retorna referencia para um array com as meta-chaves
#
sub gera_meta_chaves {

  my $maxlen  = shift;
  my @meta_chaves;

  push @meta_chaves, ['a'x$_,'z'x$_] for 1..$maxlen;

  \@meta_chaves;
}

# Gera um conjunto de chaves, utilizando a funcao anterior como ferramenta.
# Esta funcao oferece uma funcionalidade que o usuario possa querer, caso nao
# possua um dicionario de palavras.
#
# Parametros: um inteiro indicando o tamanho maximo de cada chave
# Saida: um arquivo texto contendo o conjunto de chaves.
#
sub gera_chaves {

  my $tam         = shift;
  my $meta_chaves = gera_meta_chaves($tam);

  # Abrindo o arquivo de saida para escrever a lista
  open(my $saida, ">", "lista_forca_bruta.txt") or
    die "Erro ao abrir o arquivo de saida: $!\n";

  for my $ref (@$meta_chaves) {

    my $inicio  = $$ref[0];
    my $fim     = $$ref[1];

    #print $saida "$_\n" for $inicio..$fim;

    # Adicionando tratamento de chaves, omitindo palavras com caracteres
    # repetidos, para uma lista menor e para evitar a necessidade de tratar
    # caracteres recorrentes (no caso especifico do playfair):
    for ($inicio..$fim) {
      next if /(.).*?\1/;
      print $saida "$_\n";
    }
  }

  close $saida;
}

# Gera uma matriz de decriptografia, dada uma string como chave
#
# Parametros: uma string que sera considerada a chave de decriptografia
# Saida: uma matriz => referencia para uma lista.
#
sub gera_matriz {

  my $chave     = lc shift;
  my $alfabeto  = join '', ('a'..'i','k'..'z'); # j == i

  # Removendo caracteres repetidos na chave:
  1 while $chave =~ s/(.)(.*?)\1+/$1$2/g;

  # Uma vez que j == i, pois ocupam o mesmo lugar na matriz, vamos trocar
  # todos os j's por i's, para economizar alguns if's no futuro:
  $chave        =~ s/j/i/g;

  my $matriz    = $chave;

  # Remove da lista de caracteres os caracteres jah presentes na chave:
  $alfabeto     =~ s/\[$chave\]//g;
  $matriz       .= $alfabeto;

  my @matriz    = split '', $matriz;
  \@matriz;
}

# Decifra um texto global, usando uma chave passada como parametro.
#
# Parametros: - a chave a ser utilizada para decifrar o texto;
#             - uma string sem espacos entre os caracteres;
#             - um ponteiro para arquivo, que aqui eh assumido como ja aberto
#               para escrita;
#
# Saida:      um arquivo cujo nome eh a chave utilizada para decifrar o texto
#             passado como parametro.
sub decrypt {

  my ($chave,
      $texto_cifrado,
      $arquivo_de_saida)      = @_;


  # - Subdividir a string dois a dois caracteres, tratando os casos de
  #   duplicidade;

  # - fazer a decriptografia baseando-se na matriz de decriptografia atual;

  # Imprimir o resultado em um arquivo:
  "Dae\n";
}

1;
