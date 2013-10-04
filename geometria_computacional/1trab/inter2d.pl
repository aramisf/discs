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

my @dual_n;           # cjto de pontos duais do 1o poligono
my @dual_m;           # cjto de pontos duais do 2o poligono
my @uniao_duais;      # cjto uniao, cujo dual eh a resposta do problema
my @uniao_duais_ord;  # cjto uniao ORDENADO, cujo dual eh a resposta do problema


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

  $reta{'a'} = $$pt_a[1] - $$pt_b[1];
  $reta{'b'} = $$pt_b[0] - $$pt_a[0];
  $reta{'c'} = $$pt_a[0] * $$pt_b[1] - $$pt_a[1] * $$pt_b[0];

  #print "EQ_RETA: $reta{'a'}x + $reta{'b'}y + $reta{'c'}\n";
  return \%reta;

}

# Calcula o ponto de intersecao entre a reta dada e a reta perpendicular a ela,
# que passa pelo ponto (0,0). Retorna *um* ponto, e o conjunto de pontos duais
# formara um poligono dual.
sub calcula_intersecao {

  my $eq_ref = shift;
  my @pt_intersec = (0.0,0.0);

  if ($$eq_ref{'a'} == 0) {
    $pt_intersec[0] = 0.0;
    $pt_intersec[1] = -$$eq_ref{'c'} / $$eq_ref{'b'};
  }

  elsif ($$eq_ref{'b'} == 0) {
    $pt_intersec[1] = 0.0;
    $pt_intersec[0] = -$$eq_ref{'c'} / $$eq_ref{'a'};
  }

  else {
    $pt_intersec[0] = $$eq_ref{'c'} / $$eq_ref{'b'} /
        (-$$eq_ref{'a'} / $$eq_ref{'b'} - $$eq_ref{'b'} / $$eq_ref{'a'});

    $pt_intersec[1] = $$eq_ref{'b'} / $$eq_ref{'a'} * $pt_intersec[0];
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
  my $denom = $$pt_intersec[0] ** 2 + $$pt_intersec[1] ** 2;

  if ($denom != 0) {

    $ponto_dual[0] = - $$pt_intersec[0] / $denom;
    $ponto_dual[1] = - $$pt_intersec[1] / $denom;
  }

  else {

    $ponto_dual[0] = 0.0;
    $ponto_dual[1] = 0.0;
  }

  return \@ponto_dual;
}

sub ordena_anti_horario {

  my $lista_de_pontos_ref = shift;  # Lembrando que a fcao recebe uma referencia
                                    # para um array
  # Quadrantes:
  my (@q1,@q2,@q3,@q4);
  my (@q1_ord,@q2_ord,@q3_ord,@q4_ord);

  # E suas respectivas referencias (que serao usadas na ordenacao):
  my @q_refs      = (\@q1,\@q2,\@q3,\@q4);
  my @q_ord_refs  = (\@q1_ord,\@q2_ord,\@q3_ord,\@q4_ord);

  # Resultado final fica aqui:
  my @lista_ordenada_antihorario;

  for (@$lista_de_pontos_ref) {

    # x > 0 e y > 0 -> 1o quadrante
    if (@$_[0] > 1e-5 && @$_[1] > 1e-5) { # Com duas casas decimais 1e-5 sera
                                          # suficiente
      push @q1, [@$_];
      #print "pushando \@q1, [@$_]\n";
    }

    # x < 0 e y > 0 -> 2o quadrante
    elsif (@$_[0] < 1e-5 && @$_[1] > 1e-5) {

      push @q2, [@$_];
      #print "pushando \@q2, [@$_]\n";
    }

    # x < 0 e y < 0 -> 3o quadrante
    elsif (@$_[0] < 1e-5 && @$_[1] < 1e-5) {

      push @q3, [@$_];
      #print "pushando \@q3, [@$_]\n";
    }

    # x > 0 e y < 0 -> 4o quadrante
    else {

      push @q4, [@$_];
      #print "pushando \@q4, [@$_]\n";
    }
  } # /for(@$lista_de_pontos_ref)

  sub comparador { 

    my $p1 = $a; # Referencia p array
    my $p2 = $b; # Referencia p array

    my $a = $$p1[0] != 0.0 ? $$p1[1] / $$p1[0] : $$p1[0];
    my $b = $$p2[0] != 0.0 ? $$p2[1] / $$p2[0] : $$p2[0];

    return $a <=> $b;
  } # /comparador

  # Agora eh soh ordenar os pontos nos quadrantes:
  # Primeiro, percorro a lista dos vetores dos quadrantes:
  for (my $i = 0; $i < @q_refs; $i++) {

    # Dae percorro cada um dos arrays:
    #print "for (my \$ary = 0; \$ary < ", @{$q_refs[$i]}-1 ,"; \$ary++)\n";
    for (my $ary = 0; $ary < @{$q_refs[$i]}-1; $ary++) {

      push @{$q_ord_refs[$i]}, sort comparador(@{$q_refs[$i]}[$ary], @{$q_refs[$i]}[$ary+1]);

      # tem q tirar o ultimo pq o sort retorna dois elementos, e somente o
      # primeiro deve ficar ateh que se chegue no final do laco.
      pop @{$q_ord_refs[$i]} if ($ary < @{$q_refs[$i]}-2);
    }
  } # /for (@q_refs)

  push @lista_ordenada_antihorario, (@q1_ord, @q2_ord, @q3_ord, @q4_ord);

  #print "Lista Final:\n";
  #print "@$_\n" for (@lista_ordenada_antihorario);
  return \@lista_ordenada_antihorario;
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
#print "@$_\n" for (@m);

# Para cada um dos pontos, bora calcular a equacao da reta entre eles. Como
# sabemos, por definicao (do enunciado) que os pontos sao dados no sentido
# anti-horario, entao basta percorrer a lista dada.

for (my $i=0; $i < scalar @n-1; $i++) {

  push @dual_n, calcula_dual($n[$i], $n[$i+1]);
}
push @dual_n, calcula_dual($n[-1], $n[0]);  # Para fechar o poligono
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
@uniao_duais_ord = @{ordena_anti_horario(\@uniao_duais)};
print "Uniao Duais ordenada:\n";
print "@$_\n" for (@uniao_duais_ord); # Essa blzinha aqui eh uma lista de refs
                                      # p array.
#fecho_convexo(\@uniao_duais);

# TODO:
# - Fazer o fechamento convexo da uniao (ja ordenada);
# - Fazer o dual do fechamento;
# - Tirar os print que nao serao mais usados com certeza.
