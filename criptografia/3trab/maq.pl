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
my @saida_rotores;        # Lista de numeros contendo a saida de cada rotor,
                          # ou seja, os pinos de saida aos quais cada pino de
                          # entrada esta ligado. O indice eh o indice do rotor
                          # ao qual cada sequencia pertence.

getopts("c:d:s:", \%opts);# Instancia as chaves da hash conforme os parametros
                          # passados ao programa

sub uso {

  print "\nUso:\n\t$0 -c <arq1> -d <arq2> z1..zn\n";
  print "onde:\n<arq1>: arquivo com texto claro\n";
  print "<arq2>: arquivo com texto cifrado\n";
  print "z1..zn: inteiros indicando os deslocamentos de cada rotor\n\n";
  exit 1;
}

uso() if not @ARGV or (not defined $opts{c} and not defined $opts{d});

if (defined $opts{s}) {

  open (my $fh, "<", $opts{s}) or die "Erro ao abrir $opts{s}: $!\n";
  push @saida_rotores, [split] while <$fh>;
  close $fh;
}
else {

  push @saida_rotores, [split] while <DATA>;
}

# Com tamanhos diferentes, nao eh possivel instanciar todos os rotores
if (@saida_rotores != @ARGV) {

  print "Erro ao instanciar os pinos de saida dos rotores.\n";
  exit 1;
}
$rotores = @ARGV;
#@rotores = @ARGV;

#print sprintf "passados %d parametros\n", scalar @ARGV;
print "ARGV: @ARGV\n";
print "Cifrar arq $opts{c}\n" if defined $opts{c};
print "Decifrar arq $opts{d}\n" if defined $opts{d};
print "criarei $rotores rotores com os respectivos deslocamentos: @ARGV\n";

foreach (my $i=0; $i<@ARGV; $i++) {

  push @rotores, Rotor->sumona($ARGV[$i],$saida_rotores[$i]);
}

print "Rotores: @rotores\n";
print "Rotor: $_->{DESLOCAMENTO}\nENTRADA: @{$_->{PINOS_ENTRADA}}\nSAIDA: @{$_->{PINOS_SAIDA}}\n" for @rotores;

print "\nDATA:\n";
print "@$_\n" for @saida_rotores;

__DATA__
21 3 15 1 19 10 14 26 20 8 16 7 22 4 11 5 17 9 12 23 18 2 25 6 24 13
20 1 6 4 15 3 14 12 23 5 16 2 22 19 11 18 25 24 13 7 10 8 21 9 26 17
8 18 26 17 20 22 10 3 13 11 4 23 5 24 9 12 25 16 19 6 15 21 2 7 1 14
