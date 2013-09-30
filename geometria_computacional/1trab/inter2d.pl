#!/user/bin/perl
# vim: tw=0:ts=2:et

use warnings;
use strict;


########################
## Variaveis globais: ##
########################

my $n;  # num de arestas do 1o poligono
my $m;  # num de arestas do 2o poligono

my @n;  # cjto de pontos do 1o poligono
my @m;  # cjto de pontos do 2o poligono

my @eqs_n;  # equacoes de reta dos poligonos n e m.
my @eqs_m;  # sao vetores de hashes.

my @dual_n;       # cjto de pontos duais do 1o poligono
my @dual_m;       # cjto de pontos duais do 2o poligono
my @uniao_duais;  # cjto uniao, cujo dual eh a resposta do problema


#########################
## Funcoes auxiliares: ##
#########################

# Calculo da equacao da reta entre dois pontos dados:
sub calcula_eq_reta {

  my @ponto_a = split ' ', shift;
  my @ponto_b = split ' ', shift;

  my %reta;   # Equacao da reta, indexada pelos coeficientes

  $reta{'a'} = sprintf "%.2f", $ponto_a[1] - $ponto_b[1];
  $reta{'b'} = sprintf "%.2f", $ponto_b[0] - $ponto_a[0];
  $reta{'c'} = sprintf "%.2f", $ponto_a[0]*$ponto_b[1] - $ponto_a[1]*$ponto_b[0];

  print "EQ_RETA: $reta{'a'}x + $reta{'b'}y + $reta{'c'}\n";
  return \%reta;

}

# Calcula o ponto de intersecao entre a reta dada e a reta perpendicular a ela,
# que passa pelo ponto (0,0). Retorna *um* ponto, e o conjunto de pontos duais formara um poligono dual.
sub calcula_intersecao {

  my $eq_ref = shift;
  my @pt_intersec = (0.0,0.0);

  if ($$eq_ref{'a'} == 0) {
    $pt_intersec[0] = 0.0;
    $pt_intersec[1] = sprintf "%.2f", -$$eq_ref{'c'} / $$eq_ref{'b'};
  }

  elsif ($$eq_ref{'b'} == 0) {
    $pt_intersec[1] = 0.0;
    $pt_intersec[0] = sprintf "%.2f", -$$eq_ref{'c'} / $$eq_ref{'a'};
  }

  else {
    $pt_intersec[0] = sprintf "%.2f", $$eq_ref{'c'} / $$eq_ref{'b'} /
        (-$$eq_ref{'a'} / $$eq_ref{'b'} - $$eq_ref{'b'} / $$eq_ref{'a'});

    $pt_intersec[1] = sprintf "%.2f", $$eq_ref{'b'} / $$eq_ref{'a'} * $pt_intersec[0];
  }

  return "$pt_intersec[0] $pt_intersec[1]";
}

# Encontra a equacao de reta entre os dois pontos passados como parametro, e
# tambem o ponto dual, que eh o ponto 'oposto' `a reta formada pelos mesmos
# dois pontos dados. Os dois pontos vem no formato de string: "0.0 0.0"
sub calcula_dual {

  my $pt_a = shift;
  my $pt_b = shift;
  
  my $equacao     = calcula_eq_reta($pt_a, $pt_b);  # AQUI RETORNA UMA HASHREF
  my $pt_intersec = calcula_intersecao($equacao);   # RECEBE UMA HASHREF E RETORNA UMA STRING
  my $pt_dual     = dual_do_ponto($pt_intersec);

  return $pt_dual;
}

sub dual_do_ponto {

  my @pt_intersec = split ' ', shift;
  my @ponto_dual = (0.0, 0.0);
  my $denom = sprintf "%.2f", $pt_intersec[0] ** 2 + $pt_intersec[1] ** 2;

  if ($denom != 0) {

    $ponto_dual[0] = sprintf "%.2f", - $pt_intersec[0] / $denom;
    $ponto_dual[1] = sprintf "%.2f", - $pt_intersec[1] / $denom;
  }

  else {

    $ponto_dual[0] = 0.0;
    $ponto_dual[1] = 0.0;
  }

  return "$ponto_dual[0] $ponto_dual[1]";
}


#########################
## Programa principal: ##
#########################

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
chomp ($n = <STDIN>);             # Numero de pontos
for (my $i = 0; $i < $n; $i++) {  # Pontos com duas coordenadas

  chomp($_ = <STDIN>);
  push @n, sprintf ("%.2f %.2f", split);
}

# Lendo o segundo poligono
chomp ($m = <STDIN>);         # Numero de pontos
for (my $i = 0; $i < $m; $i++) {  # Pontos com duas coordenadas

  chomp($_ = <STDIN>);
  push @m, sprintf ("%.2f %.2f", split);
}

#print "N: $n\n";
#print "$_ " for (@n);
#print "\n";
#print "M: $m\n";
#print "$_ " for (@m);

# Para cada um dos pontos, bora calcular a equacao da reta entre eles. Como
# sabemos, por definicao (do enunciado) que os pontos sao dados no sentido
# anti-horario, entao basta percorrer a lista dada.

for (my $i=0; $i < scalar @n-1; $i++) {

  push @dual_n, calcula_dual($n[$i], $n[$i+1]);
}
push @dual_n, calcula_dual($n[-1], $n[0]);  # Para fechar o poligono
print "Dual N:\n";
print "$_\n" for @dual_n;

for (my $i=0; $i < scalar @m-1; $i++) {

  push @dual_m, calcula_dual($m[$i], $m[$i+1]);
}
push @dual_m, calcula_dual($m[-1], $m[0]);  # Para fechar o poligono
print "Dual M:\n";
print "$_\n" for @dual_m;


# TODO:
# - Uniao dos duais dos poligonos n e m;
# - Ordenar a uniao;
# - Fazer o fechamento convexo da uniao (ja ordenada);
# - Fazer o dual do fechamento.
