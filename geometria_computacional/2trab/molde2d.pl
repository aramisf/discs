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

  # Usando referencias:
  my $uref = shift;
  my $vref = shift;

  # Para calcular o produto interno: u.x * v.x + u.y * v.y
  my $produto_interno = @$uref[0] * @$vref[0] + @$uref[1] * @$vref[1];

  my $norma_de_u = sqrt (@$uref[0]*@$uref[0] + @$uref[1]*@$uref[1]);
  my $norma_de_v = sqrt (@$vref[0]*@$vref[0] + @$vref[1]*@$vref[1]);

  return $produto_interno / ($norma_de_u * $norma_de_v);
}

sub calcula_vetores { # e seus respectivos vetores normais

  for (my $i=0; $i < @$pontos-1; $i++) {

    # Dados os pontos A e B, o vetor AB eh calculado como B - A. Eh isso que
    # esta sendo feito aqui, e cada AB BC CD eh empilhado em @vetores

    # Coordenadas do vetor AB:
    my $x = $$pontos[$i+1][0] - $$pontos[$i][0];
    my $y = $$pontos[$i+1][1] - $$pontos[$i][1];

    push @$vetores, [$x, $y];

    # Conforme a matriz de rotacao, ao rotacionar um vetor com as coordenadas
    # (x,y), temos as coordenadas (-y,x) ou (y,-x), no caso, os pontos foram
    # lidos no sentido antihorario, entao (y,-x) aponta para o centro do
    # poligono, pois queremos rotacionar os vetores no sentido antihorario
    # (-90o) http://pt.wikipedia.org/wiki/Matriz_de_rota%C3%A7%C3%A3o
    push @$normais, [-$y, $x];
  }

  # Esse aqui eh o ultimo, por exemplo, se fossem pontos A, B, C e D, este aqui
  # seria o vetor DA (que eh A - D)
  my $x = $$pontos[0][0] - $$pontos[-1][0];
  my $y = $$pontos[0][1] - $$pontos[-1][1];

  push @$vetores, [$x, $y];
  push @$normais, [-$y, $x]

} # /calcula_vetores


sub percorre_faces {

  for (my $i=0; $i < @$normais; $i++) {

    # Vetor normal u agora aponta para fora do poligono (u = u * -1):
    my @u = (
              -$$normais[$i][0],
              -$$normais[$i][1]
            );

    my $deu_boa = 1;  # assumo que vai dar boa

    # Testa se ele tem no maximo 90 graus de angulo com as outras faces:
    for (my $j = 0; $j < @$normais; $j++) {

      # Evita testar um lado consigo mesmo:
      next if $i == $j;

      # cos(teta) = u.v/|u|.|v|
      my @v = @{$$normais[$j]};
      my $cos = cosseno_de_teta(\@u, \@v);

      # Se o angulo for menor q 90, testa 'os outros 90 graus'. Aqui eu podia
      # rotacionar tanto a normal quanto o vetor corrente, entao optei por
      # rotacionar o vetor corrente 90 graus no sentido horario.
      if ($cos < 0) {

        # Rotacionando v 90 no sentido horario:
        my @v_rot = ($v[1],-$v[0]);

        # Calcula mais uma vez o cosseno:
        my $cos2  = cosseno_de_teta(\@u, \@v_rot);

        # Agora sim, se os dois testes falharem entao devo sair do laco
        if ($cos2 <= 0) {
          $deu_boa  = 0;
          last;
        }
      }
    }

    if ($deu_boa && $i != @$normais-1) {

      return $i+1;  # +1 pq a numeracao das faces comeca com 1
    }
  }

  return 0;
} # /percorre_faces

#########################
## Programa principal: ##
#########################

chomp ($n = <STDIN>);                     # Numero de pontos
push @$pontos, [split ' ', <>] for 1..$n; # Pontos com duas coordenadas

calcula_vetores();
print percorre_faces(),"\n";
exit 0;
