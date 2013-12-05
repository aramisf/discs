#!/usr/bin/perl
# vim: tw=0:ts=2:et:foldmethod=manual

use strict;
use warnings;


########################
## Variaveis globais: ##
########################

my $n;          # num de pontos a serem lidos
my $pontos;     # lista de pontos lidos
my $vetores;    # vetores das retas (B-A)
my $normais;    # as retas normais de cada vetor


###################
## Ferramentas : ##
###################

sub cosseno_de_teta {

  # Lembra que cos(teta) = (u.v) / (|u|.|v|)

  my $uref = shift;
  my $vref = shift;

  my $produto_interno = @$uref[0] * @$vref[0] + @$uref[1] * @$vref[1];  # u.x * v.x + u.y * v.y

  my $norma_de_u = sqrt (@$uref[0]*@$uref[0] + @$uref[1]*@$uref[1]);

  my $norma_de_v = sqrt (@$vref[0]*@$vref[0] + @$vref[1]*@$vref[1]);

  return $produto_interno / ($norma_de_u * $norma_de_v);
}

sub calcula_vetores { # e seus respectivos vetores normais

  for (my $i=0; $i < @$pontos-1; $i++) {

    # Dados os pontos A e B, o vetor AB eh calculado como B - A. Eh isso que
    # esta sendo feito aqui, e cada AB BC CD eh empilhado em @vetores
    push @$vetores, [
                      $$pontos[$i+1][0] - $$pontos[$i][0],
                      $$pontos[$i+1][1] - $$pontos[$i][1]
                    ];

    # Conforme a matriz de rotacao, ao rotacionar um vetor com as coordenadas
    # (x,y), temos as coordenadas (-y,x) ou (y,-x), no caso, os pontos foram
    # lidos no sentido antihorario, entao (y,-x) aponta para o centro do
    # poligono, pois queremos rotacionar os vetores no sentido antihorario
    # (-90o) http://pt.wikipedia.org/wiki/Matriz_de_rota%C3%A7%C3%A3o
    push @$normais, [
                      $$pontos[$i][1] - $$pontos[$i+1][1],
                      -($$pontos[$i][0] - $$pontos[$i+1][0])
                    ];

  }

  # Esse aqui eh o ultimo, por exemplo, se fossem pontos A, B, C e D, este aqui
  # seria o vetor DA
  push @$vetores, [
                    $$pontos[0][0] - $$pontos[@$pontos-1][0],
                    $$pontos[0][1] - $$pontos[@$pontos-1][1]
                  ];
  push @$normais, [
                    $$pontos[0][1] - -$$pontos[@$pontos-1][1],
                    -($$pontos[0][0] - -$$pontos[@$pontos-1][0])
                  ];

} # /calcula_vetores


sub percorre_faces {

  for (my $i=0; $i < @$normais; $i++) {

    # Vetor normal u agora aponta para fora do poligono (u = u * -1):
    my @u = (
              -$$normais[$i][0],
              -$$normais[$i][1]
            );

    my $deu_boa = 1;  # assumo que vai dar boa

    #print "Lendo face: @u\n";
    # Testa se ele tem no maximo 90 graus de angulo com as outras faces:
    for (my $j = $i+1; $j < @$normais; $j++) {

      # cos(teta) = u.v/|u|.|v|
      my @v = @{$$normais[$j]};
      print "cosseno_de_teta(@u, @v)\n";
      my $cos = cosseno_de_teta(\@u, \@v);
      #print "$cos\n";
      $deu_boa = 0 and last if ($cos < 0);
    }

    if ($deu_boa) {
      return $i+1;  # +1 pq a numeracao das faces comeca com 1
    }
  }

  return 0;
} # /percorre_faces

#########################
## Programa principal: ##
#########################

chomp ($n = <STDIN>);             # Numero de pontos

for (my $i = 0; $i < $n; $i++) {  # Pontos com duas coordenadas

  chomp($_ = <STDIN>);
  push @$pontos, [split];
}

calcula_vetores();

print "Vetores:\n";
for (@$vetores) {

  print "@$_\n";
}

print "Normais:\n";
for (@$normais) {

  print "@$_\n";
}

print percorre_faces();
exit 0;
