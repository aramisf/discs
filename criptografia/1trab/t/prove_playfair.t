#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

# Importacao do modulo:
require_ok("Playfair");


# Retorno da funcao decrypt
#is Playfair::decrypt(), "Dae\n", "Decrypt funciona";  # Testa retorno da funcao


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


done_testing();
