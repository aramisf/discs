#!/user/bin/perl

use warnings;
use strict;


my $n;  # num de arestas do 1o poligono
my $m;  # num de arestas do 2o poligono

my @n;  # cjto de pontos do 1o poligono
my @m;  # cjto de pontos do 2o poligono


# Lendo arquivos da entrada, o formato eh:
# numero_de_arestas_poligono_1
# x1 y1
# x2 y2
# ...
# xn yn
# numero_de_arestas_poligono_2
# x'1 y'1
# x'2 y'2
# ...
# x'n y'n


# Lendo o primeiro poligono
chomp ($n = <STDIN>);

for (my $i = 0; $i < $n; $i++) {

    chomp($_ = <STDIN>);
    push @n, $_;
}


# Lendo o segundo poligono
chomp ($m = <STDIN>);

for (my $i = 0; $i < $m; $i++) {

    chomp($_ = <STDIN>);
    push @m, $_;
}

print "N: $n\n";
print "$_ " for (@n);
print "\n";
print "M: $m\n";
print "$_ " for (@m);

