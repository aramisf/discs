#!/usr/bin/env perl
# vim tw=0:ts=2:et:foldmethod=manual

use strict;
use warnings;

#######################
## Variaveis Globais ##
#######################

my $n;  # Num de vertices da triangulacao   Tipo: inteiro
my $m;  # Num de triangulos                 Tipo: inteiro

my $DCEL  = {}; # DCEL                      Tipo: referencia para uma hash de pares
                #                                 ordenados (tamanho: $n),
                #                                 indexada por inteiros

my $vertices;   # Adivinha..
my $arestas;    # ^^
my $triangulos;     # Triangulos velhos;
my $malha_refinada; # Triangulos novos;

my $vOrds;          # Vertices ordenados em antihorario

# Usando hashes em dois caminhos:
# Vertices originais:
my %vOrigIdx2Coord;       # indice -> coordenada
my %vOrigCoord2Idx;       # coordenada -> indice

# Vertices ordenados:
my %vOrdsIdx2Coord;       # indice -> coordenada
my %vOrdsCoord2Idx;       # coordenada -> indice


###########
## Utils ##
###########

# Cria os triangulos e as monta a lista de arestas. Por enquanto estou num
# dilema, pois se montar a lista de arestas e usar a DCEL, os triangulos e seus
# vizinhos serao praticamente inuteis. No momento estou decidindo montar os
# triangulos mesmo assim.
sub ashley {

  # Varia de 1 a $m
  my $index = shift;

  # Vertices do triangulo '$index':
  my $v1 = shift;
  my $v2 = shift;
  my $v3 = shift;

  # Vizinhos
  my $t1 = shift;
  my $t2 = shift;
  my $t3 = shift;

  # Pode dizer q parece feio, mas depois eh bem melhor p acessar e ver se jah
  # existe uma aresta
  ${$arestas}{"$v1,$v2"} = [$v1, $v2];
  ${$arestas}{"$v2,$v3"} = [$v2, $v3];
  ${$arestas}{"$v3,$v1"} = [$v3, $v1];

  # Agora criando o triangulo da linha $index, que talvez nao seja utilizado no
  # futuro.
  ${$triangulos}{$index}  = {
                              'vertices'  => [$v1, $v2, $v3],
                              'arestas'   =>  [
                                                # Note que estou adicionando
                                                # aqui os mesmos rotulos que
                                                # adicionei na hash arestas.
                                                # Note tb que a ordem em que
                                                # sao adicionados eh a mesma
                                                # proveniente da entrada
                                                "$v1,$v2",
                                                "$v2,$v3",
                                                "$v3,$v1"
                                              ],
                              'vizinhos'  => [$t1, $t2, $t3]
                            };
} # /ashley

# Ordena vetores em sentido antihorario:
sub madeline {

  my $lista_de_pontos_ref = shift; # Lembrando que a fcao recebe uma referencia
                                   # para um array

  # Quadrantes:
  my (@q1,@q2,@q3,@q4); # Dados
  my (@q1_ord,@q2_ord,@q3_ord,@q4_ord); # Ordenados

  # Resultado final fica aqui:
  my @lista_ordenada;

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

  push @lista_ordenada, (@q1_ord, @q2_ord, @q3_ord, @q4_ord);

  return \@lista_ordenada;
} # /madeline

# Le entrada:
sub jessica {

  # Lendo num de vertices e triangulos:
  ($n, $m) = split ' ', <>;


  # Pra que gastar mais de uma linha de codigo para ler os vertices e empilhar
  # suas coordenadas em um vetor?
  push @$vertices, [ split ' ', <> ] for (1..$n);


  # Ashley vai montar os triangulos, e seus vizinhos *e tb as arestas (pelo
  # menos por enqto)*.
  ashley($_, split(' ', <>)) for (1..$m);

} #/jessica

# Cria as hashes indexadas:
sub connely {

  # Os originais sao indexados conforme posicao dada:
  for (my $i=0; $i < @$vertices; $i++) {

    $vOrigIdx2Coord{($i+1)} = @$vertices[$i];
    $vOrigCoord2Idx{"@{@$vertices[$i]}"} = $i+1;
  }

  # Agora os ordenados:
  for (my $i=0; $i < @$vOrds; $i++) {

    $vOrdsIdx2Coord{($i+1)} = @$vOrds[$i];
    $vOrdsCoord2Idx{"@{@$vOrds[$i]}"} = $i+1;
  }
} #/connely

#########
## Lib ##
#########

# Monta a DCEL, a partir dos triangulos dados:
sub noomi {

  for my $id_triangulo (keys %$triangulos) {

    # Agora vo montar a DCEL, considerando cara aresta como uma semi-aresta, q
    # vai sendo montada aos poucos

    my ($a1, $a2, $a3) = @{${$triangulos}{$id_triangulo}{'arestas'}};
    my ($v1, $v2, $v3) = @{${$triangulos}{$id_triangulo}{'vertices'}};
    my ($t1, $t2, $t3) = @{${$triangulos}{$id_triangulo}{'vizinhos'}};


    # Pegando os indices dos vertices 'anterior' e 'proximo' do vertice v1. Os
    # resultados contidos aqui se referem aos indices do vetor ordenado. Lembra
    # que temos os indices iniciando pelo 1
    my $coord_v1 = "@{$vOrigIdx2Coord{$v1}}";
    my $coord_v2 = "@{$vOrigIdx2Coord{$v2}}";
    my $coord_v3 = "@{$vOrigIdx2Coord{$v3}}";

    # Indices das coordenadas ordenadas:
    my $idx_v1_ord = $vOrdsCoord2Idx{$coord_v1};
    my $idx_v2_ord = $vOrdsCoord2Idx{$coord_v2};
    my $idx_v3_ord = $vOrdsCoord2Idx{$coord_v3};

    # Teste para acessar apenas indices validos em v1:
    my $safe_idx1_ant  = $idx_v1_ord - 1 || $#{$vOrds}+1;
    my $coord_v1_ant  = "@{$vOrdsIdx2Coord{$safe_idx1_ant}}";

    my $safe_idx1_prox = $idx_v1_ord % ($#{$vOrds}+1) + 1;
    my $coord_v1_prox = "@{$vOrdsIdx2Coord{$safe_idx1_prox}}";


    # Teste para acessar apenas indices validos em v2:
    my $safe_idx2_ant  = $idx_v2_ord - 1 || $#{$vOrds}+1;
    my $coord_v2_ant  = "@{$vOrdsIdx2Coord{$safe_idx2_ant}}";

    my $safe_idx2_prox = $idx_v2_ord % ($#{$vOrds}+1) + 1;
    my $coord_v2_prox = "@{$vOrdsIdx2Coord{$safe_idx2_prox}}";


    # Teste para acessar apenas indices validos em v3:
    my $safe_idx3_ant  = $idx_v3_ord - 1 || $#{$vOrds}+1;
    my $coord_v3_ant  = "@{$vOrdsIdx2Coord{$safe_idx3_ant}}";

    my $safe_idx3_prox = $idx_v3_ord % ($#{$vOrds}+1) + 1;
    my $coord_v3_prox = "@{$vOrdsIdx2Coord{$safe_idx3_prox}}";


    # E finalmente acessando anteriores e proximos:
    my $v1_ant  = $vOrigCoord2Idx{$coord_v1_ant};
    my $v1_prox = $vOrigCoord2Idx{$coord_v1_prox};

    my $v2_ant  = $vOrigCoord2Idx{$coord_v2_ant};
    my $v2_prox = $vOrigCoord2Idx{$coord_v2_prox};

    my $v3_ant  = $vOrigCoord2Idx{$coord_v3_ant};
    my $v3_prox = $vOrigCoord2Idx{$coord_v3_prox};

    # Montando a DCEL:
    ${$DCEL}{"$v1,$v2"} = {
                            'v1'  =>  $v1,
                            'v2'  =>  $v2,
                            'f1'  =>  $id_triangulo,
                            'f2'  =>  $t3,
                            'p1'  =>  "$v1_ant,$v1",
                            'p2'  =>  "$v2,$v2_prox"
                          };

    ${$DCEL}{"$v2,$v3"} = {
                            'v1'  =>  $v2,
                            'v2'  =>  $v3,
                            'f1'  =>  $id_triangulo,
                            'f2'  =>  $t1,
                            'p1'  =>  "$v2_ant,$v2 =",
                            'p2'  =>  "$v3,$v3_prox"
                          };

    ${$DCEL}{"$v3,$v1"} = {
                            'v1'  =>  $v3,
                            'v2'  =>  $v1,
                            'f1'  =>  $id_triangulo,
                            'f2'  =>  $t2,
                            'p1'  =>  "*$v3_ant,$v3",
                            'p2'  =>  "$v1,$v1_prox"
                          };
  }
} #/noomi

########################
## Programa principal ##
########################

jessica();
$vOrds = madeline($vertices);
connely();
noomi();
