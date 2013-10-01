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

# Calculo da equacao da reta entre dois pontos dados. Os dois parametros
# recebidos aqui sao referencias para arrays.
sub calcula_eq_reta {

  my $pt_a = shift;
  my $pt_b = shift;

  #print "Recebi ponto a: @$pt_a\n";

  my %reta;   # Equacao da reta, indexada pelos coeficientes

  $reta{'a'} = sprintf "%.2f", $$pt_a[1] - $$pt_b[1];
  $reta{'b'} = sprintf "%.2f", $$pt_b[0] - $$pt_a[0];
  $reta{'c'} = sprintf "%.2f", $$pt_a[0] * $$pt_b[1] - $$pt_a[1] * $$pt_b[0];

  #print "EQ_RETA: $reta{'a'}x + $reta{'b'}y + $reta{'c'}\n";
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

  #print "\n\nCalcula intersecao retornando: @pt_intersec\n\n";
  return \@pt_intersec;
}

# Encontra a equacao de reta entre os dois pontos passados como parametro, e
# tambem o ponto dual, que eh o ponto 'oposto' `a reta formada pelos mesmos
# dois pontos dados. Os dois parametros recebidos sao referencias para os
# arrays dos pontos.
sub calcula_dual {

  my $pt_a = shift;
  my $pt_b = shift;

  #print "Calcula DUAL: '@$pt_a' '@$pt_b'\n";
  
  my $equacao     = calcula_eq_reta($pt_a, $pt_b);  # AQUI RETORNA UMA HASHREF
  my $pt_intersec = calcula_intersecao($equacao);   # RECEBE UMA HASHREF E RETORNA UM ARRAYREF
  my $pt_dual     = dual_do_ponto($pt_intersec);

  return $pt_dual;
}

# Calcula o dual de um ponto de intersecao dado. O ponto dado eh uma referencia
# para um array (x,y)
sub dual_do_ponto {

  my $pt_intersec = shift;
  my @ponto_dual = (0.0, 0.0);
  my $denom = sprintf "%.2f", $$pt_intersec[0] ** 2 + $$pt_intersec[1] ** 2;

  if ($denom != 0) {

    $ponto_dual[0] = sprintf "%.2f", - $$pt_intersec[0] / $denom;
    $ponto_dual[1] = sprintf "%.2f", - $$pt_intersec[1] / $denom;
  }

  else {

    $ponto_dual[0] = 0.0;
    $ponto_dual[1] = 0.0;
  }

  return \@ponto_dual;
}

sub ordena_anti_horario {

  my $lista_de_pontos = shift;  # Lembrando que a fcao recebe uma referencia
                                # para um array

  # Quadrantes:
  my (@q1,@q2,@q3,@q4);
  my (@q_ord1,@q_ord2,@q_ord3,@q_ord4);
  my @lista_ordenada_antihorario;

  #print "Lista: @$lista_de_pontos\n";
  for (@$lista_de_pontos) {

    print "Lendo @$_\n";
    if (@$_[0] > 1e-3 && @$_[1] > 1e-3) { # Com duas casas decimais 1e-3 sera
                                          # suficiente
      push @q2, [@$_];
    }
    elsif (@$_[0] < 1e-3 && @$_[1] > 1e-3) {
      push @q1, [@$_];
    }
    elsif (@$_[0] < 1e-3 && @$_[1] < 1e-3) {
      push @q3, [@$_];
    }
    else {
      push @q4, [@$_];
    }
  }

  sub comparador {

    my $p1 = $a; # Referencias p arrays
    my $p2 = $b; # Referencias p arrays

    print "COMPARADOR P1: $a\n";
    print "COMPARADOR P2: $b\n";
    exit 0;
    #return -1 if $p2[0] == 0;
    #return  1 if $p2[1] == 0;

    #my $a = $p1[0] != 0.0 ? $p0[1] / $p1[0] : $p1[0];
    #my $b = $p2[0] != 0.0 ? $p2[1] / $p2[0] : $p2[0];

    return $a <=> $b
  }

  # Agora eh soh ordenar os pontos nos quadrantes:
  # TODO: Passar arrays dois a dois:
  print "Q1: $_\n" for (@q1);
  for (my $ary = 0; $ary < @q1-1; $ary++) {
    push @q_ord1, sort comparador($q1[$ary],$q1[$ary+1]);
  }
  @q2 = sort comparador @q2;
  @q3 = sort comparador @q3;
  @q4 = sort comparador @q4;
  
  push @lista_ordenada_antihorario, (reverse @q1, @q3, @q4, @q2);

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
  my @elemento = split;
  push @n, \@elemento;
}

# Lendo o segundo poligono
chomp ($m = <STDIN>);         # Numero de pontos
for (my $i = 0; $i < $m; $i++) {  # Pontos com duas coordenadas

  chomp($_ = <STDIN>);
  my @elemento = split; 
  push @m, \@elemento;
}

#print "N: $n\n";
#for (@n){
#  print "@$_\n";
#}
#print "\n";
#print "M: $m\n";
#print "$_ " for (@m);

# Para cada um dos pontos, bora calcular a equacao da reta entre eles. Como
# sabemos, por definicao (do enunciado) que os pontos sao dados no sentido
# anti-horario, entao basta percorrer a lista dada.

for (my $i=0; $i < scalar @n-1; $i++) {

  push @dual_n, calcula_dual($n[$i], $n[$i+1]);
}
#push @dual_n, calcula_dual($n[-1], $n[0]);  # Para fechar o poligono
#print "Dual N:\n";
#print "$_\n" for @dual_n;

for (my $i=0; $i < scalar @m-1; $i++) {

  push @dual_m, calcula_dual($m[$i], $m[$i+1]);
}
push @dual_m, calcula_dual($m[-1], $m[0]);  # Para fechar o poligono
#print "Dual M:\n";
#print "$_\n" for @dual_m;

push @uniao_duais, (@dual_n, @dual_m);
#print "convex_hull (@uniao_duais)\n";
#convex_hull (\@uniao_duais);
ordena_anti_horario(\@uniao_duais);
#fecho_convexo(\@uniao_duais);

# TODO:
# - Fazer o fechamento convexo da uniao (ja ordenada);
# - Fazer o dual do fechamento.
