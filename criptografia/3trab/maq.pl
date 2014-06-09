#!/usr/bin/perl -I lib/

use strict;
use warnings;
use Getopt::Std;

################################################################################
# Os parametros tem o seguinte formato:                                        #
# ./$0 z1..z5 arq.txt                                                          #
#                                                                              #
# Onde:                                                                        #
# - z[1-5] sao numeros inteiros;                                               #
# - arq.txt eh o arquivo texto a ser cifrado/decifrado pela maquina de         #
#   rotores.                                                                   #
################################################################################

use Rotor;

my %opts;                 # Armazena os arquivos com texto claro e cifrado
my $rotores;              # Numero de rotores
my @rotores;              # Lista de referencias para os rotores a serem
                          # criados

getopts("c:d:", \%opts);  # Instancia as chaves da hash conforme os parametros
                          # passados ao programa

sub uso {

  print "\nUso:\n\t$0 -c <arq1> -d <arq2> z1..zn\n";
  print "onde:\n<arq1>: arquivo com texto claro\n";
  print "<arq2>: arquivo com texto cifrado\n";
  print "z1..zn: inteiros indicando os deslocamentos de cada rotor\n\n";
  exit 1;
}

uso() if not @ARGV or (not defined $opts{c} and not defined $opts{d});

$rotores = @ARGV;
#@rotores = @ARGV;

#print sprintf "passados %d parametros\n", scalar @ARGV;
print "ARGV: @ARGV\n";
print "Cifrar arq $opts{c}\n" if defined $opts{c};
print "Decifrar arq $opts{d}\n" if defined $opts{d};
print "criarei $rotores rotores com os respectivos deslocamentos: @ARGV\n";

foreach (@ARGV) {

  push @rotores, Rotor->sumona($_);
}

print "Rotores: @rotores\n";
print "Rotor: $_->{DESLOCAMENTO}\n" for @rotores;
