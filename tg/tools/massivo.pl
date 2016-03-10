#!/usr/bin/perl

use strict;
use warnings;

use File::Path qw/make_path/;

my $resultados = "./resultados";

make_path($resultados) and print "Criando diretorio com os resultados, aguarde\n"
                    if not -d $resultados;

my @dims = (5,7,9,11,13,15,17,20);

print "Gerando matrizes aleatorias, aguarde... ";

for (my $i = 0; $i < 10; $i++) {

    for (@dims) {

        `./gerador $_ -w -f $resultados/${i}_${_}x${_}.txt`;
    }
}

print "feito\n";
exit 0;
