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
my $triangulos;

my $vertices_ordenados; # Antihorario       Tipo: hash q implementa uma lista
                        #                         duplamente ligada


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
  ${$arestas}{"$v1, $v2"} = [$v1, $v2];
  ${$arestas}{"$v2, $v3"} = [$v2, $v3];
  ${$arestas}{"$v3, $v1"} = [$v3, $v1];

  # Agora criando o triangulo da linha $index, que talvez nao seja utilizado no
  # futuro.
  ${$triangulos}{$index}  = {
                              'vertices'  => [$v1, $v2, $v3],
                              'arestas'   =>  [
                                                # Note que estou adicionando
                                                # aqui os mesmos rotulos que
                                                # adicionei na hash arestas
                                                "$v1, $v2",
                                                "$v2, $v3",
                                                "$v3, $v1"
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


  # Criando uma lista ligada para melhorar a vida. Pq no happy hour rola um
  # double
  my %lista_ligada;

  for my $i (0..$#lista_ordenada) {

    my $rotulo = join ",", @{$lista_ordenada[$i]};
    $lista_ligada{$rotulo} =
      {
        'ant'   => join(",", @{$lista_ordenada[$i-1]}),
        'agora' => $i,
        # Sabe pq o mod aqui no fim neh?
        'prox'  => join(",", @{$lista_ordenada[($i+1)%$#lista_ordenada]})
      };

  }

  return \%lista_ligada;
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

########################
## Programa principal ##
########################

jessica();

$vertices_ordenados = madeline($vertices);

#print "@$_\n" for (@$vertices);
#print "- - - \n";
#print "@$_\n" for (@$vertices_ordenados);

for my $k (keys %$vertices_ordenados) {

  print "Chave1: $k\n";
  print "Valor: '${$vertices_ordenados}{$k}'\n";
  for my $j (keys ${$vertices_ordenados}{$k}) {

    print "\tSub chave: $j\n";
    print "\tValor: '${$vertices_ordenados}{$k}{$j}'\n\n";
  }
}

