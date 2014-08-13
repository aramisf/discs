#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Capture::Tiny ':all';

# Um dia eu entenderei a necessidade desse bloco
#BEGIN {
  use_ok("Rotor");
#}

my @pinos_saida = qw(21 3 15 1 19 10 14 26 20 8 16 7 22 4 11 5 17 9 12 23 18 2
                     25 6 24 13);

my $rotor = Rotor->sumona(0,\@pinos_saida);

isa_ok($rotor,"Rotor");
can_ok($rotor, qw(sumona cifrar decifrar gira_catraca));


## O caractere 'a' entra na linha zero, pressionando o pino 1 da entrada, que
## esta ligado ao pino 1 da saida, que conforme @pinos_saida esta na quarta
## posicao (ou seja, na quarta linha), que por sua vez corresponde aa letra 'd'
my $stdout  = capture sub { $rotor->cifrar((ord 'a') - 97) };

is($stdout, "d", "cifragem correta");

## Zerando
undef $rotor;

## E aqui o inverso, criando um novo (por causa do esquema das rotacoes
## internas)
$rotor = Rotor->sumona(0,\@pinos_saida);

isa_ok($rotor,"Rotor");
can_ok($rotor, qw(sumona cifrar decifrar gira_catraca));

$stdout = capture { $rotor->decifrar((ord 'd') - 97) };

is($stdout, 'a', "decifragem correta");

done_testing();
