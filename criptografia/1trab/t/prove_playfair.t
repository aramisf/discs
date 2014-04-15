#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

# Importacao do modulo:
require_ok("Playfair");


# Testando a geracao das chaves, passando um tamanho maximo de chaves:
my $MAXLEN  = 6;
my $meta_chaves_ref = Playfair::gera_meta_chaves($MAXLEN);
is @$meta_chaves_ref, $MAXLEN, "Meta-chave com tamanho correto";


# Testando a geracao da matriz de decriptografia, dada uma chave qualquer.
# Note que escolhi representar uma matriz por uma string, pq preferi trabalhar
# direto com os indices.
is  Playfair::gera_matriz("ZAraFa"),
    "zarfbcdeghiklmnopqstuvwxy",
    "Teste 1 de geracao de matriz";

is  Playfair::gera_matriz("zaRafA"),
    "zarfbcdeghiklmnopqstuvwxy",
    "Teste 2 de geracao de matriz";

is  Playfair::gera_matriz("XerxEs"),
    "xersabcdfghiklmnopqtuvwyz",
    "Teste 3 de geracao de matriz";

is  Playfair::gera_matriz("xerxes"),
    "xersabcdfghiklmnopqtuvwyz",
    "Teste 4 de geracao de matriz";

# Level carioca
is  Playfair::gera_matriz("XehRrxish"),
    "xehrisabcdfgklmnopqtuvwyz",
    "Teste 5 de geracao de matriz";


# A funcao decrypt deve criar um arquivo com o conteudo decifrado. Como isso
# nao eh mto simples de ser testado, fazemos o teste pela existencia do
# arquivo, verificando se ele possui o nome correto e o conteudo tambem, para
# tanto, pegamos uma palavra cifrada e a deciframos, e entao lemos do arquivo
# de saida e comparamos com o resultado esperado.

my $chave = 'camisa';
my $arq   = 'teste_camisa';
my $crypt = "rhiwdimt";     # Note q o texto passado para a funcao jah vem sem
                            # os espacos entre os caracteres.

Playfair::decrypt($chave,$crypt,$arq);

ok( -f $arq, "Decrypt cria o arquivo de saida");
open(my $arq_read, "<", $arq);

my $result = '';
while(<$arq_read>) {

  $result .= $_;
}

is $result, "pl ay fa ir \n", "Decifrado com sucesso";
is `rm -f $arq`, '', "Arquivo teste removido com sucesso.";

done_testing();
