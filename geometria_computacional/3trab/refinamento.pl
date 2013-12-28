#!/usr/bin/env perl
# vim tw=0:ts=2:et:foldmethod=manual

use strict;
use warnings;

#######################
## Variaveis Globais ##
#######################

my $n;          # Num de vertices da triangulacao   Tipo: inteiro
my $m;          # Num de triangulos                 Tipo: inteiro

my $vertices;   # Hash indexando os vertices
my $triangulos; # Hash indexando os triangulos

###########
## Utils ##
###########

# Le entrada:
sub jessica {

  # Lendo num de vertices e triangulos:
  ($n, $m) = split ' ', <>;


  # Pra que gastar mais de uma linha de codigo para ler os vertices e empilhar
  # suas coordenadas em um vetor?
  ${$vertices}{$_} = [ split ' ', <> ] for (1..$n);


  # Ashley vai montar os triangulos, e seus vizinhos *e tb as arestas (pelo
  # menos por enqto)*.
  ashley($_, split(' ', <>)) for (1..$m);

} #/jessica

# Retorna um vertice novo (ponto medio) para cada triangulo dado.
sub julia {

  my $t = shift;
  my ($v1,$v2,$v3) = @{${$triangulos}{$t}{'vertices'}};

  my ($x1,$y1) = @{${$vertices}{$v1}};
  my ($x2,$y2) = @{${$vertices}{$v2}};
  my ($x3,$y3) = @{${$vertices}{$v3}};

  my $x = ($x1+$x2+$x3)/3;
  my $y = ($y1+$y2+$y3)/3;

  return [$x,$y];
} #/julia

# Recebe uma string com 3 numeros separados por virgula, e retorna um array
# anonimo contendo 3 strings de dois numeros separados por virgula
sub kristin {

  my $str           = shift;
  my ($a1,$a2,$a3)  = split ',', $str;

  return  [
            "$a1,$a2",
            "$a2,$a3",
            "$a3,$a1"
          ];
} #/kristin

# Imprime resultado
sub natascha {

  my $n = keys %$vertices;
  my $m = keys %$triangulos;

  print "$n $m\n";

  # Mandinguinha p ordenar numericamente
  for (sort {$a <=> $b} keys %$vertices) {

    print sprintf "%.2f %.2f\n", @{${$vertices}{$_}};
  }

  # De novo a mandinguinha do sort
  for (sort {$a <=> $b} keys %$triangulos) {

    print "@{${$triangulos}{$_}{'vertices'}} ";
    print "@{${$triangulos}{$_}{'vizinhos'}}\n";
  }
} #/natascha

#########
## Lib ##
#########

# Cria os triangulos e monta a lista de arestas. Decidi abandonar a DCEL.  Vou
# usar os triangulos pq gastei mto tempo mexendo com a DCEL, e provavelmente
# gastaria mais se insistisse.
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

  # Agora criando o triangulo da linha $index:
  ${$triangulos}{$index}  = {
                              'vertices'  =>  [$v1, $v2, $v3],
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
                              'vizinhos'  =>  [$t1, $t2, $t3]
                            };
} # /ashley

# Funcao para subdividir um triangulo em outros 3. Percorre a lista global de
# triangulos, adicionando os novos triangulos ao final da lista.
sub milla {

  # Percorrer a lista de triangulos;
  for my $id (sort keys %$triangulos) {

    # obter o novo vertice do centro do triangulo;
    my $vNovoCoord    = julia($id);
    my $vNovoId       = (keys %$vertices)+1;

    # Atualizando o novo vertice. Respeitando o padrao, estou usando
    # referencias p array, e nao string, entao..
    ${$vertices}{$vNovoId} = $vNovoCoord;

    # Para cada aresta do triangulo existente, criar tres novos triangulos:
    my $ult           = (keys %$triangulos)+1;
    my @novos_triangs = map { $_ .= ",$vNovoId" } @{${$triangulos}{$id}{'arestas'}};

    ## Agora cria os 3 novos triangulos:
    ${$triangulos}{$ult}{'vertices'}  =  [split ',', $novos_triangs[0]];
    ${$triangulos}{$ult}{'arestas'}   =  kristin($novos_triangs[0]);
    ${$triangulos}{$ult}{'vizinhos'}  =  [$ult+1, $ult+2, $id];

    ${$triangulos}{$ult+1}{'vertices'}  =  [split ',', $novos_triangs[1]];
    ${$triangulos}{$ult+1}{'arestas'}   =  kristin($novos_triangs[1]);
    ${$triangulos}{$ult+1}{'vizinhos'}  =  [$ult+2, $ult, $id];

    ${$triangulos}{$ult+2}{'vertices'}  =  [split ',', $novos_triangs[2]];
    ${$triangulos}{$ult+2}{'arestas'}   =  kristin($novos_triangs[2]);
    ${$triangulos}{$ult+2}{'vizinhos'}  =  [$ult, $ult+1, $id];

  }
} #/milla

########################
## Programa principal ##
########################

jessica();
milla();
natascha();
