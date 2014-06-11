#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use_ok("Rotor");

my @pinos_saida = qw(21 3 15 1 19 10 14 26 20 8 16 7 22 4 11 5 17 9 12 23 18 2 25 6 24 13);

my $rotor = Rotor->sumona(0,\@pinos_saida);
diag "\nGerou um rotor corretamente"
  if isa_ok($rotor,"Rotor");

diag "Todos os metodos sao acessiveis\n"
  if can_ok($rotor, qw(sumona cifrar decifrar gira_catraca));

# O caractere 'a' entra na linha zero, pressionando o pino 1 da entrada, que
# esta ligado ao pino 1 da saida, que conforme @pinos_saida esta na quarta
# posicao (ou seja, na quarta linha), que por sua vez corresponde aa letra 'd'
my $char  = $rotor->cifrar((ord 'a') - 97);
diag "De boa a cifragem char: $char\n" 
  if is($char, 'd', "cifragem correta");
  #if is($rotor->cifrar((ord 'a') - 97), 'd', "cifragem correta");

# Zerando
undef $rotor;

# E aqui o inverso, criando um novo (por causa do esquema das rotacoes
# internas)
$rotor = Rotor->sumona(0,\@pinos_saida);
$char  = $rotor->decifrar((ord 'd') - 97);

diag "De boa a decifragem char: $char\n"
  if is($char, 'a', "decifragem correta");
  #if is($rotor->decifrar((ord 'd') - 97), 'a', "decifragem correta");


done_testing();
