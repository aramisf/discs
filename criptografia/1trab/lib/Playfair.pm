#!/usr/bin/perl

use strict;
use warnings;

# Criando um modulo importavel, nao vo exportar nada aqui com o intuiro de
# manter o namespace limpo, jah que o programa usara forca bruta.
#
package Playfair;

our $matriz;    # Matriz do playfair, montada pelo gera_matriz, e utilizada
                # por algumas funcoes auxiliares.

our %ranking;   # Hash para organizar as chaves de maior sucesso

our @cinco_melhores  = (0);

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
# Saida: uma matriz representada na forma de uma string.
#
sub gera_matriz {

  my $chave     = lc shift;
  my $alfabeto  = join '', ('a'..'i','k'..'z'); # j == i

  # Uma vez que j == i, pois ocupam o mesmo lugar na matriz, vamos trocar
  # todos os j's por i's, para economizar alguns if's no futuro:
  $chave        =~ s/j/i/g;

  # Removendo caracteres repetidos na chave:
  1 while $chave =~ s/(.)(.*?)\1+/$1$2/g;

  $matriz    = $chave;

  # Remove da lista de caracteres os caracteres jah presentes na chave:
  $alfabeto     =~ s/[$chave]//g;
  $matriz       .= $alfabeto;

  #$matriz;   # Como ela eh uma variavel global, posso omitir daqui.
}

# Faz uma analise das frequencias de aparicao das letras, e gera um ranking.
sub analisa {

  my $chave           = shift;
  my $texto_decifrado = shift;

  my @vogais          = qw(a e o);    
  my @digrafos        = qw(de da oz se ao qu en te);
  my @trigrafos       = qw(que ent men nte est ndo ava ara);

  my $vogais          = 0;
  my $digrafos        = 0;
  my $trigrafos       = 0;

  # Contando as frequencias das vogais, digrafos e trigrafos:
  $vogais++ while $texto_decifrado =~ /[aeo]/g;  # i==j e u aparece mto pouco

  for (@digrafos) {

    $digrafos++ while $texto_decifrado =~ /$_/g;
  }

  for (@trigrafos) {

    $trigrafos++ while $texto_decifrado =~ /$_/g;
  }

  my $total = $vogais+$digrafos+$trigrafos;

  if ($total > $cinco_melhores[0]) {

    unshift @cinco_melhores, $total;
    $ranking{$total}  = $chave;
    @cinco_melhores   = @cinco_melhores[0..4];
  }

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
      $imprimir)      = @_;

  my $cont            = 1;    # Contador de linhas, p formatacao da saida.
  my $texto_decifrado = '';
  my $arq;

  gera_matriz($chave);


  if ($imprimir) {

    my $arquivo_de_saida  = "resultados/$chave.txt";

    open($arq, ">", "$arquivo_de_saida") or
      die "Erro ao abrir $arquivo_de_saida: $!";
  }

  # - Subdividir a string dois a dois caracteres, tratando os casos de
  #   duplicidade;
  $_                          = $texto_cifrado;

  while (/(.)(.)/g) {

    my ($um, $dois) = ($1,$2);

    # Examinando $um e $dois:
    #
    # x -> linha
    # y -> coluna
    my ($pos1,$pos2);
    my ($x1,$y1,$x2,$y2)  =
      (
        int((index $matriz,$um)   / 5),
            (index $matriz,$um)   % 5,

        int((index $matriz,$dois) / 5),
            (index $matriz,$dois) % 5,
      );

    # Mesma linha
    if ($x1 == $x2) {

      # move aa esquerda
      $y1   = --$y1 % 5;
      $y2   = --$y2 % 5;
      $pos1 = ($x1*5 + $y1);
      $pos2 = ($x2*5 + $y2);
    }
    elsif ($y1 == $y2) {
      # move acima
      $x1   = --$x1 % 5;
      $x2   = --$x2 % 5;
      $pos1 = ($x1*5 + $y1);
      $pos2 = ($x2*5 + $y2);
    }
    else {
      #troca ambos
      $pos1 = ($x1*5 + $y2);
      $pos2 = ($x2*5 + $y1);
    }

    if ($pos1 > 24 or $pos2 > 24) {
      print "Erros:\n";
      print "chave: $chave\n";
      print "matriz: $matriz\n";
      print "ANTES: um: '$um' ($pos1), dois '$dois'($pos2)\n";
    }
    my $prox_um   = substr $matriz,$pos1,1;
    my $prox_dois = substr $matriz,$pos2,1;

    # Imprimir o resultado em um arquivo, caso ele tenha sido passado como
    # parametro:
    if ($imprimir) {
      print $arq "$prox_um $prox_dois ";
      print $arq "\n" if $cont++ % 20 == 0;   # Quebra a linha na coluna 80?
    }

    $texto_decifrado  .= "$prox_um $prox_dois ";
  }

  analisa($chave,$texto_decifrado) if not $imprimir;

  if ($imprimir) {
    print $arq "\n";
    close $arq;
  }
  "Dae\n";
}

sub resultados {

  my $cifrado = shift;

  for (@cinco_melhores) {

    print "Chave: $ranking{$_}: $_\n";
    decrypt($ranking{$_},$cifrado,1);
  }
}

1;
