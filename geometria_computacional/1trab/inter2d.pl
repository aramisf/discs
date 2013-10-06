#!/usr/bin/perl
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
my @uniao_duais;      # cjto uniao, cujo dual do fechamento eh a resposta do
                      # problema

my @uniao_duais_ord;  # @uniao_duais_ord eh uma lista de refs p array.
my @fechamento;       # cujo dual eh a resposta do problema
my @intersecao;       # cjto de pontos da intersecao


#########################
## Funcoes auxiliares: ##
#########################

# Calculo da equacao da reta entre dois pontos dados. Os dois parametros
# recebidos aqui sao referencias para arrays.
sub calcula_eq_reta {

  my $pt_a = shift;
  my $pt_b = shift;

  my %reta;   # Equacao da reta, indexada pelos coeficientes

  $reta{'a'} = $$pt_a[1] - $$pt_b[1];
  $reta{'b'} = $$pt_b[0] - $$pt_a[0];
  $reta{'c'} = $$pt_a[0] * $$pt_b[1] - $$pt_a[1] * $$pt_b[0];

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

  return \@pt_intersec;
}

# Encontra a equacao de reta entre os dois pontos passados como parametro, e
# tambem o ponto dual, que eh o ponto 'oposto' `a reta formada pelos mesmos
# dois pontos dados. Os dois parametros recebidos sao referencias para os
# arrays dos pontos.
sub calcula_dual {

  my $pt_a = shift;
  my $pt_b = shift;

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
  my (@q1,@q2,@q3,@q4);                 # Dados
  my (@q1_ord,@q2_ord,@q3_ord,@q4_ord); # Ordenados

  # Resultado final fica aqui:
  my @lista_ordenada_antihorario;

  # Percorro a lista de pontos dada e insiro cada ponto em seu respectivo
  # quadrante:
  for (@$lista_de_pontos_ref) {

    if (@$_[0] >= 0) {

      # 1o quadrante
      if (@$_[1] >= 0) {
        push @q1, [@$_];
      }

      # 4o quadrante
      elsif (@$_[1] < 0) {
        push @q4, [@$_];
      }
    }

    elsif (@$_[0] < 0) {

      # 2o quadrante
      if (@$_[1] >= 0) {
        push @q2, [@$_];
      }

      # 3o quadrante
      elsif (@$_[1] < 0) {
        push @q3, [@$_];
      }
    }
  } # /for(@$lista_de_pontos_ref)


  # De posse dos quadrantes ja formados, ordenamos primeiro em X, e, se houver
  # empate, em Y. Note que para cada quadrante deve existir uma ordenacao
  # caracteristica, pois queremos que esteja ordenado no sentido anti-horario
  @q1_ord = sort { $$b[0] <=> $$a[0] or $$a[1] <=> $$b[1] } @q1;
  @q2_ord = sort { $$b[0] <=> $$a[0] or $$b[1] <=> $$a[1] } @q2;
  @q3_ord = sort { $$a[0] <=> $$b[0] or $$b[1] <=> $$a[1] } @q3;
  @q3_ord = sort { $$a[0] <=> $$b[0] or $$a[1] <=> $$b[1] } @q4;

  push @lista_ordenada_antihorario, (@q1_ord, @q2_ord, @q3_ord, @q4_ord);

  # Lista de referencias para arrays
  return @lista_ordenada_antihorario;
} # /ordena_antihorario

## Fecho convexo:
# Neste caso a lista que a funcao recebe jah esta ordenada, entao parte do
# algorito ja esta feita.
sub fecho_convexo {

  return @_ if @_ < 2;
  my @lista = @_;

  # O algoritmo divide os pontos em dois conjuntos:
  my @cima;
  my @baixo;

  my $i = 0;
  while ($i < @lista) {

    my $i_cima = my $i_baixo = $i;
    my ($x, $y_cima) = @{$lista[$i]};
    my $y_baixo = $y_cima;

    # Encontra pelo menos o menor e maior Y para o X atual
    while (++$i < @lista and $lista[$i][0] == $x) {

      my $y = $lista[$i][1];

      if ($y < $y_baixo) {
        $i_baixo = $i;
        $y_baixo = $y;
      }
      elsif ($y > $y_cima) {
        $i_cima = $i;
        $y_cima = $y;
      }
    }

    while (@baixo >= 2) {

      my ($ox, $oy) = @{$baixo[-2]};
      last if ($baixo[-1][1] - $oy) * ($x - $ox) < ($y_baixo - $oy) * ($baixo[-1][0] - $ox);
      pop @baixo;
    }

    push @baixo, $lista[$i_baixo];

    while (@cima >= 2) {

      my ($ox, $oy) = @{$cima[-2]};
      last if ($cima[-1][1] - $oy) * ($x - $ox) > ($y_cima - $oy) * ($cima[-1][0] - $ox);
      pop @cima;
    }

    push @cima, $lista[$i_cima];
  }

  # Removendo duplicatas
  shift @cima if $cima[0][1] == $baixo[0][1];
  pop @cima if @cima and $cima[-1][1] == $baixo[-1][1];

  return (@baixo, reverse @cima);
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


# Para cada um dos pontos, bora calcular a equacao da reta entre eles. Como
# sabemos, por definicao (do enunciado) que os pontos sao dados no sentido
# anti-horario, entao basta percorrer a lista dada.

for (my $i=0; $i < scalar @n-1; $i++) {

  push @dual_n, calcula_dual($n[$i], $n[$i+1]);
}
# Para fechar o poligono
push @dual_n, calcula_dual($n[-1], $n[0]);

for (my $i=0; $i < scalar @m-1; $i++) {

  push @dual_m, calcula_dual($m[$i], $m[$i+1]);
}
# Para fechar o poligono
push @dual_m, calcula_dual($m[-1], $m[0]);

# Unindo as listas de duais
push @uniao_duais, (@dual_n, @dual_m);

# Ordenando no sentido anti-horario:
@uniao_duais_ord = ordena_anti_horario(\@uniao_duais);

# Encontrando o fechamento convexo do conjunto de pontos:
@fechamento = fecho_convexo(@uniao_duais_ord);

for (my $i=0; $i < @fechamento-1; $i++) {
  push @intersecao, calcula_dual($fechamento[$i],$fechamento[$i+1]);
}


# Imprimindo a saida na tela:
print scalar @intersecao."\n";
for (@intersecao) {
  print sprintf "%.2f %.2f\n", @$_;
}

exit 0;
