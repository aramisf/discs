#!/usr/bin/perl
# vim: ts=2:foldmethod=manual:et:tw=0:sw=1

use strict;
use warnings;

#############
## Globais ##
#############

my $BORDA = 999999999;  # Limite do espaco euclidiano
my $vertices;           # Hash indexada de vertices

# Valores mais distantes nos eixos. Estes serao os vertices candidatos para
# montar o primeiro simplexo. A variavel abaixo armazena a lista dos rotulos de
# tais vertices.
my $extremos;


###########
## Funcs ##
###########

# Le os dados da entrada padrao e monta a lista indexada de vertices. As chaves
# sao inteiros q indexam a lista, e cada chave possui um array anonimo como
# valor, contento as 3 coordenadas do vetor indexado pelo numero da linha sendo
# lida.
sub arya {

  ${$vertices}{$.} = [split] while <>;
}

# Retorna o menor entre 3 valores quaisquer:
sub theon {

  my ($a, $b, $c) = @_;

  if ($b >= $c) {

    if ($a >= $b) { 0;} else { 1;}

  } else {

    if ($a >= $c) { 0;} else { 2;}
  }

} #/theon

# Seleciona vetores candidatos a extremos para o simplexo inicial. Retorna uma
# lista com 6 (identificadores de) vertices: menor x, maior x, menor y, maior
# y, menor z e maior z, nesta ordem.
sub petyr {

  # Indice 0 -> rotulo do vertice;
  # Indice 1 -> valor da coordenada; (local, apenas para comparacao)
  my @max_x = (0,-$BORDA);
  my @max_y = (0,-$BORDA);
  my @max_z = (0,-$BORDA);

  my @min_x = (0,$BORDA);
  my @min_y = (0,$BORDA);
  my @min_z = (0,$BORDA);

  # Ordenando as chaves numericamente pq quero q a busca seja conforme os dados
  # informados na entrada. Os primeiros valores serao os definidos, se houver
  # empate, o primeiro ponto encontrado sera o ponto q fica.
  for (sort {$a <=> $b} keys %$vertices) {

    # Busca maior e menor coordenadas em x:
    if (${$vertices}{$_}->[0] > $max_x[1]) {

      $max_x[0] = $_;
      $max_x[1] = ${$vertices}{$_}->[0]

    } elsif (${$vertices}{$_}->[0] < $min_x[1]) {

      $min_x[0] = $_;
      $min_x[1] = ${$vertices}{$_}->[0]
    }

    # Busca maior e menor coordenadas em y:
    if (${$vertices}{$_}->[1] > $max_y[1]) {

      $max_y[0] = $_;
      $max_y[1] = ${$vertices}{$_}->[1]

    } elsif (${$vertices}{$_}->[1] < $min_y[1]) {

      $min_y[0] = $_;
      $min_y[1] = ${$vertices}{$_}->[1]
    }

    # Busca maior e menor coordenadas em z:
    if (${$vertices}{$_}->[2] > $max_z[1]) {

      $max_z[0] = $_;
      $max_z[1] = ${$vertices}{$_}->[2]

    } elsif (${$vertices}{$_}->[2] < $min_z[1]) {

      $min_z[0] = $_;
      $min_z[1] = ${$vertices}{$_}->[2]
    }
  } #/for (keys %$vertices)

  # Retornando os indices dos extremos encontrados, na sequencia:
  # menor x, maior x,
  # menor y, maior y,
  # menor z, maior z.
  [
    $min_x[0],$max_x[0],
    $min_y[0],$max_y[0],
    $min_z[0],$max_z[0],
  ];

} #/petyr

# Calcula a hipotenusa.
sub ros {

  my ($x, $y, $z) = @_;

  $x*$x + $y*$y + $z*$z;

} #/ros

# Normaliza um vetor passado como parametro e retorna o resultado:
sub sansa {

  my ($x, $y, $z) = @_;
  my $hip   = ros(@_);
  my $sqrt  = sqrt $hip;

  ($x/$sqrt, $y/$sqrt, $z/$sqrt);

} #/sansa

# Retorna o produto vetorial de dois vetores passados como parametro:
sub shae {

  my $u = shift;
  my $v = shift;

  (
    @{$v}[0] * @{$u}[0],
    @{$v}[1] * @{$u}[1],
    @{$v}[2] * @{$u}[2]
  );

} #/shae

# Retorna o produto escalar de dois vetores passados como parametro:
sub podrick {

  my $u = shift;
  my $v = shift;

  @{$v}[0] * @{$u}[0] +
  @{$v}[1] * @{$u}[1] +
  @{$v}[2] * @{$u}[2];

} #/podrick

# Retorna o vetor resultante da subtracao entre dois vertices:
sub cersei {

  my $u = shift;
  my $v = shift;

  (
    @{$v}[0] - @{$u}[0],
    @{$v}[1] - @{$u}[1],
    @{$v}[2] - @{$u}[2],
  );
} #/cersei

# Encontra os vertices que farao parte do primeiro simplexo.
sub tyrion {

  my $simplexo;           # Simplexo inicial
  my $extremos = petyr(); # Pontos extremos nos eixos -> candidatos iniciais

  # Vetores para compor o simplexo (que contera os vertices A, B, C e D):
  my @ab;
  my @ac;
  my @av;                 # iterador no loop

  # Produtos escalares de alguns vetores q vamos usar:
  my $prod_ab_ac;
  my $prod_ac_av;

  # Produtos vetoriais:
  my @prod_ab_ac;     # normal entre os vetores AB e AC
  my @prod_ab_av;     # auxiliar para percorrer lista de pontos


  # Extraindo coordenadas:
  my $min_x = ${$vertices}{@{$extremos}[0]}[0];
  my $max_x = ${$vertices}{@{$extremos}[1]}[0];

  my $min_y = ${$vertices}{@{$extremos}[2]}[1];
  my $max_y = ${$vertices}{@{$extremos}[3]}[1];

  my $min_z = ${$vertices}{@{$extremos}[4]}[2];
  my $max_z = ${$vertices}{@{$extremos}[5]}[2];


  # Qual o eixo cujos extremos possuem maior distancia entre si?
  my $xDist = $max_x - $min_x;
  my $yDist = $max_y - $min_y;
  my $zDist = $max_z - $min_z;


  # Theon retorna o maior entre 3 valores, que aqui me servirao para saber qual
  # dos eixos eh o escolhido
  my $xyz   = theon($xDist,$yDist,$zDist);

  if    ($xyz == 0) {

    push @$simplexo, (@{$extremos}[0], @{$extremos}[1]);
  }
  elsif ($xyz == 1) {

    push @$simplexo, (@{$extremos}[2], @{$extremos}[3]);
  }
  elsif ($xyz == 2) {

    push @$simplexo, (@{$extremos}[4], @{$extremos}[5]);
  }

  # Ateh aqui temos os 2 1os vertices

  # $a e $b sao referencias para os vetores.
  my $a = ${$vertices}{@$simplexo[1]};
  my $b = ${$vertices}{@$simplexo[0]};

  # Calculando vetor AB:
  @ab   = cersei($a,$b);

  # Normalizando, para nao afetar o tamanho dos outros vetores que serao
  # testados no loop q segue
  @ab   = sansa(@ab);

  # TODO: Refatorar colocando em uma funcao?
  # Agora um loop p buscar o vertice mais distante de A, diferente do vertice B
  # ja escolhido. Chamemos este vertice de $v, e seja ele diferente de B.
  my $maiorTam  = 0;
  for my $v (keys %$vertices) {

    # Testando apenas nos vertices ainda nao selecionados:
    unless ($v ~~ @$simplexo) {

      my $candidato   = ${$vertices}{$v};

      # Calcula AV
      @av             = cersei($a,$candidato);

      # Calcula produto vetorial entre AB e AC:
      my @prod_ab_av  = shae(\@ab,\@av);

      # E por fim a distancia (hipotenusa**2)
      my $tam         = ros(@prod_ab_av);

      # Se for maior, atualiza e elege o candidato (aqui referenciado apenas
      # com o indice)
      if ($tam > $maiorTam) {

        $maiorTam     = $tam;
        @$simplexo[2] = $v;
        @prod_ab_ac   = @prod_ab_av;
      }
    }
  } #/for my $v (%$vertices)

  # Normaliza para encontrar o 4o vertice:
  @prod_ab_ac = sansa(@prod_ab_ac);

  # Agora partimos para a busca do ultimo vertice que fara parte do simplexo
  # inicial.
  my $maxDist = 0;
  my $dist    = podrick(\@prod_ab_ac,${$vertices}{@$simplexo[2]});

  # Novamente percorremos a lista de vertices:
  for my $v (keys %$vertices) {

    unless ($v ~~ @$simplexo) {

      # calcula o produto escalar do vertice corrente com @prod_ab_ac, e
      # subtrai de $dist
      my $candidato   = ${$vertices}{$v};
      my $distNova    = podrick(\@prod_ab_ac,$candidato) - $dist;

      if ($distNova > $maxDist) {

        $maxDist      = $distNova;
        @$simplexo[3] = $v;
      }
    }
  } #/for my $v (keys %$vertices)

  print "Eleitos ateh o momento: @$simplexo\n";

  # TODO: Criar as faces

} #/tyrion

# Proximos passos:
#
# Percorrer as faces do simplexo, buscando vertices 'visiveis' pela face.
# Remover a face corrente, e criar outras tres, entre o vertice inserido e os 3
# vertices que compunham a face recem excluida.
# Fazer isso enquanto houverem vertices fora do poliedro.


##########
## Main ##
##########
arya();
tyrion();
