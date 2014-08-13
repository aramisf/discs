#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Capture::Tiny ':all';

################################################################################
# Teste de erros de execucao do programa, saidas etc                           #
#                                                                              #
# Codigos de erros para as saidas:                                             #
# - 1: Erro ao chamar o programa;                                              #
# - 2: Excesso de opcoes na linha de comando;                                  #
# - 3: Erro nos dados informados pelo usuario;                                 #
################################################################################

my ($stdout, $stderr, $exit);

my $executavel    = "./maq.pl";

my $saida_erro_1a = " ";
my @saida_erro_1b = ("-c null", 3, 1);
my @saida_erro_1c = ("-d feii", 0, 0);
my @saida_erro_1d = (2, 4, 5);

my @saida_erro_2  = ("-c teste1", "-d teste2");
my @saida_erro_3  = ("-c teste_cifra", 1, 2);

($stdout, $stderr, $exit) = capture { system ($executavel, $saida_erro_1a); };
# pq o comando system tem um retorno diferente do que ele recebeu, precisa
# fazer esse shift aqui:
$exit >>= 8;

# Mantendo a linha abaixo p fins hostoricos:
#diag "stdout: '$stdout'\nexit: $exit\nstderr: $stderr\n" if not
like $stdout, qr/uso/i, "Trata erro 1a corretamente";
is $exit, 1, "Saida de erro 1a correta";

($stdout, $stderr, $exit) = capture { system ($executavel, @saida_erro_1b); };
$exit >>= 8;
like $stderr, qr/^Erro ao instanciar/i, "Trata erro 1b corretamente";
is $exit, 3, "Saida de erro 1b correta";

($stdout, $stderr, $exit) = capture { system ($executavel, @saida_erro_1c); };
$exit >>= 8;
like $stderr, qr/^Erro ao instanciar/i, "Trata erro 1c corretamente";
is $exit, 3, "Saida de erro 1c correta";

($stdout, $stderr, $exit) = capture { system ($executavel, @saida_erro_1d); };
$exit >>= 8;
like $stdout, qr/uso/i, "Trata erro 1d corretamente";
is $exit, 1, "Saida de erro 1d correta";

($stdout, $stderr, $exit) = capture { system ($executavel, @saida_erro_2); };
$exit >>= 8;
like $stdout, qr/uso/i, "Trata erro 2 corretamente";
is $exit, 1, "Saida de erro 2 correta";

($stdout, $stderr, $exit) = capture { system ($executavel, @saida_erro_3); };
$exit >>= 8;
like $stderr, qr/Erro ao instanciar/i, "Trata erro 3 corretamente";
is $exit, 3, "Saida de erro 3 correta";

done_testing();
