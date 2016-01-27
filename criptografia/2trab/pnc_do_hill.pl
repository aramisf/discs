#!/usr/bin/perl

use strict;
use warnings;

# Esse programa tem como objetivo testar o comportamento do programa com a
# cifra de Hill, e descobrir a matriz chave de codificação utilizada.  NOTA:
# na 1a fase do trabalho, onde eh assumido que a matriz inserida no codigo
# possui inversa, aqui isso nao faz a menor diferenca, uma vez que a inversa
# eh utilizada para decifrar textos cifrados. O objetivo deste trabalho eh
# encontrar a matriz utilizada para cifrar.

use Matrix;

# Y = KX, onde:
#   - Y eh a matriz cifrada
#   - X eh a matriz conhecida, onde a linha [1,0,0] fica como um vetor vertical
#     de forma que os 3 primeiros caracteres da palavra do texto claro formam a
#     primeira coluna de $X, e os cifrados, a 1a coluna de $Y.
#   - K eh a matriz chave
my ($X, $X_inv, $Y, $K);


# Alimentando o programa com a matriz X, obtemos a matriz Y, e a partir de
# ambas podemos obter K.

# Geradores da Matrix X
my ($c11,$c12,$c13) = ('b','d','d');
my ($c21,$c22,$c23) = ('b','e','d');
my ($c31,$c32,$c33) = ('b','d','e');

# Geradores da Matrix Y
my @e;
my ($e11,$e12,$e13);
my ($e21,$e22,$e23);
my ($e31,$e32,$e33);

$X = new Math::Matrix ([(ord $c11)-97,(ord $c21)-97,(ord $c31)-97],
                       [(ord $c12)-97,(ord $c22)-97,(ord $c32)-97],
                       [(ord $c13)-97,(ord $c23)-97,(ord $c33)-97]);

$X_inv = $X->invert();


# Debug:
#my $I = $X->multiply($X_inv);
#print "$X\n$X_inv\n$I\n";

# Criando um arquivo com texto claro para alimentar o programa cifrador
open(my $arq_teste, '>', "pnc_do_hill.txt");
print $arq_teste "$c11$c12$c13$c21$c22$c23$c31$c32$c33\n";
close $arq_teste;

# Assumindo que o programa existe, pego a saida
chomp($_  = `./hill "pnc_do_hill.txt"`);

# Debug:
#print "Saida do programa:\n'$_'\n";

# Os 3 1os caracteres lidos da saida formarao a 1a coluna da matriz $Y
while (/(.) (.) (.)/g) {

  # Debug
  #print sprintf "|$1: %d | $2: %d | $3: %d |\n", (ord $1)-97, (ord $2)-97, (ord $3)-97;
  push @e, [(ord $1)-97, (ord $2)-97, (ord $3)-97];
}

($e11,$e12,$e13)  = @{$e[0]};
($e21,$e22,$e23)  = @{$e[1]};
($e31,$e32,$e33)  = @{$e[2]};

# Debug:
#print "E:\n'$e11 $e12 $e13'\n'$e21 $e22 $e23'\n'$e31 $e32 $e33'\n";


# Os 3 1os caracteres lidos formarao a 1a coluna de $Y
$Y  = new Math::Matrix( [$e11, $e21, $e31],
                        [$e12, $e22, $e32],
                        [$e13, $e23, $e33]);

# Sabe-se que a primeira coluna de $Y eh formada pela multiplicacao de $K pela
# primeira coluna de $X -> $Y = $K*$X.
# Logo:
# $Y * $X^-1 = $K * $X * $X^-1
# $Y * $X^-1 = $K * matriz identidade


# Calculando a matriz chave:
$K  = $Y->multiply($X_inv);

# Debug:
#print "Y:\n$Y\n";
#print "X:\n$X\n";
#print "X^1:\n$X_inv\n";
#print "K:\n$K\n";

# Formatando a saida p ficar bonitinha
foreach my $l (@$K){

  my ($e1,$e2, $e3) = @{$l};
  print sprintf "%d %d %d\n", $e1%26, $e2%26, $e3%26;
}

