#!/usr/bin/perl -I lib/

use strict;
use warnings;
use Getopt::Std;

################################################################################
# Os parametros tem o seguinte formato:                                        #
# ./$0 -c <arq1> -d <arq2> -s <arq3> z1..z5                                    #
#                                                                              #
# Onde:                                                                        #
# - z[1-5] sao numeros inteiros;                                               #
# - arq1 eh o arquivo texto a ser cifrado                                      #
# - arq2 eh o arquivo texto a ser decifrado                                    #
#   rotores;                                                                   #
# - arq3 eh o arquivo com os valores dos pinos de saida de cada rotor.         #
#                                                                              #
# arq3 eh opcional, mas ao menos uma dentre as opcoes c e d devem ser          #
# utilizadas.                                                                  #
################################################################################

use Rotor;

my %opts;                 # Armazena os arquivos com texto claro e cifrado
my $rotores;              # Numero de rotores
my @rotores;              # Lista de referencias para os rotores a serem
                          # criados
my @pinos_saida_rotores;  # Lista de numeros contendo a saida de cada rotor,
                          # ou seja, os pinos de saida aos quais cada pino de
                          # entrada esta ligado. O indice eh o indice do rotor
                          # ao qual cada sequencia pertence.

getopts("c:d:s:", \%opts);# Instancia as chaves da hash conforme os parametros
                          # passados ao programa

sub uso {

  print "\nUso:\n\t$0 [ -c <arq1>|-d <arq2>] [[-s <arq3>]] z1..zn\n";
  print "onde:\n<arq1>: arquivo com texto claro\n";
  print "<arq2>: arquivo com texto cifrado\n";
  print "<arq3>: arquivo com os valores dos pinos de saida de cada rotor\n";
  print "z1..zn: inteiros indicando os deslocamentos de cada rotor\n\n";
  exit 1;
}

uso() if not @ARGV or (not defined $opts{c} and not defined $opts{d});


if (not ($opts{c} xor $opts{d})) {

  print "Escolha apenas UMA dentre [cifrar,decifrar].\n";
  exit 1;
}

if (defined $opts{s}) {

  open (my $fh, "<", $opts{s}) or die "Erro ao abrir $opts{s}: $!\n";
  push @pinos_saida_rotores, [split] while <$fh>;
  close $fh;
}
else {

  push @pinos_saida_rotores, [split] while <DATA>;
}

# Com tamanhos diferentes, nao eh possivel instanciar todos os rotores
if (@pinos_saida_rotores != @ARGV) {

  print "Erro ao instanciar os pinos de saida dos rotores.\n";
  exit 1;
}

###
# Ok, se tudo deu certo ateh aqui, entao podemos comecar o programa
###

# um mapeamento de teclado, que eh usado apenas na entrada do usuario, a
# partir do momento em que entra-se nos circuitos das catracas, nao faz mais
# diferenca. O teclado sera usado novamente ao final da execucao.
my %teclado;
$teclado{$_}  = (ord $_) - 97 for 'a'..'z';


foreach (my $i=0; $i<@ARGV; $i++) {

  push @rotores, Rotor->sumona($ARGV[$i],$pinos_saida_rotores[$i]);

  # Aproveitando o laco para ligar os objetos (somente os jah criados)
  next if $i == 0;
  $rotores[$i-1]->{PROXIMO} = $rotores[$i];
  $rotores[$i]->{ANTERIOR}  = $rotores[$i-1];
}

if (defined $opts{c}) {

  open(my $cifrar, "<", $opts{c}) or die "Erro ao abrir arquivo $opts{c}: $!\n";
  print "### Cifrando texto do arquivo '$opts{c}'\n\n-->\t";
  while (<$cifrar>) {

    chomp;
    foreach (split //) {

      $rotores[0]->cifrar($teclado{$_}) if defined $teclado{$_};
    }
  }
  close $cifrar;
  print "\n\n### Feito\n";
}

if (defined $opts{d}) {

  open(my $decifrar, "<", $opts{d}) or die "Erro ao abrir arquivo $opts{d}: $!\n";
  print "\n### Decifrando texto do arquivo '$opts{d}'\n\n-->\t";
  while (<$decifrar>) {

    chomp;
    foreach (split //) {

      $rotores[-1]->decifrar($teclado{$_}) if defined $teclado{$_};
    }
  }
  close $decifrar;
  print "\n\n### Feito\n";
}

__DATA__
21 3 15 1 19 10 14 26 20 8 16 7 22 4 11 5 17 9 12 23 18 2 25 6 24 13
20 1 6 4 15 3 14 12 23 5 16 2 22 19 11 18 25 24 13 7 10 8 21 9 26 17
8 18 26 17 20 22 10 3 13 11 4 23 5 24 9 12 25 16 19 6 15 21 2 7 1 14
