#!/usr/bin/perl
# vim: ts=2:foldmethod=manual:et:tw=0:sw=1

use strict;
use warnings;


#############
## Globais ##
#############

my $BORDA = 999999999;  # Limite do espaco euclidiano
my $vertices;           # Hash indexada de vertices

# Estrutura que armazenara o fecho convexo, de inicio apenas o simplexo
# inicial, e ao final da execucao, o fecho convexo.
my $fecho;

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

# Normaliza um vetor passado como parametro e retorna o resultado:
sub sansa {

  my @vet         = @_;
  my ($x, $y, $z) = @vet;
  #my $hip         = ros(@_);
  my $hip         = podrick(\@vet, \@vet);
  my $sqrt        = sqrt $hip;

  ($x/$sqrt, $y/$sqrt, $z/$sqrt);

} #/sansa

# Retorna o produto vetorial de dois vetores passados como parametro:
sub shae {

  my $u = shift;
  my $v = shift;

  # _   _       |i  j  k |
  # u x v = det |ux uy uz|
  #             |vx vy vz|
  my $i = @{$u}[1] * @{$v}[2] - @{$u}[2] * @{$v}[1];
  my $j = @{$u}[2] * @{$v}[0] - @{$u}[0] * @{$v}[2];
  my $k = @{$u}[0] * @{$v}[1] - @{$u}[1] * @{$v}[0];

  ($i, $j, $k);

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

  # Agora um loop p buscar o vertice mais distante de A, diferente do vertice B
  # ja escolhido. Chamemos este vertice de $v, e seja ele diferente de B.
  my $maiorTam  = 0;
  for my $v  (keys %$vertices) {

    # Testando apenas nos vertices ainda nao selecionados:
    unless ($v ~~ @$simplexo) {

      my $candidato   = ${$vertices}{$v};

      # Calcula AV
      @av             = cersei($a,$candidato);

      # Calcula produto vetorial entre AB e AC:
      my @prod_ab_av  = shae(\@ab,\@av);

      # E por fim o comprimento do vetor
      #my $tam         = ros(@prod_ab_av);
      my $tam         = podrick(\@prod_ab_av, \@prod_ab_av);

      # Estou em busca do maior tamanho pq quero montar o maior paralelogramo
      # possivel entre os vetores AB e AV, o $v que me der o maior tamanho sera
      # eleito o ponto C.
      if ($tam > $maiorTam) {

        $maiorTam     = $tam;
        @$simplexo[2] = $v;
        @prod_ab_ac   = @prod_ab_av;
      }
    }
  } #/for my $v (%$vertices)

  # Normaliza para encontrar o 4o vertice:
  @prod_ab_ac   = sansa(@prod_ab_ac);

  # Agora partimos para a busca do ultimo vertice que fara parte do simplexo
  # inicial.
  my $maxDist   = 0;

  # Calculando o cosseno do angulo entre a normal
  # NOTA: $simplexo eh indexado a partir do 0 e $vertices a partir do 1
  # NOTA2: podrick calcula o produto escalar entre os dois vetores passados
  # como parametro
  my $ang_an_ac = podrick(\@prod_ab_ac,${$vertices}{@$simplexo[2]});

  # Novamente percorremos a lista de vertices:
  for my $v (keys %$vertices) {

    unless ($v ~~ @$simplexo) {

      # calcula o produto escalar do vertice corrente com @prod_ab_ac, e
      # subtrai de $dist
      my $candidato   = ${$vertices}{$v};
      my $distNova    = podrick(\@prod_ab_ac,$candidato) - $ang_an_ac;

      if ($distNova > $maxDist) {

        $maxDist      = $distNova;
        @$simplexo[3] = $v;
      }
    }
  } #/for my $v (keys %$vertices)

  $simplexo;
} #/tyrion

# Devolve um array de faces, onde cada face sera um array contendo os indices
# dos vertices envolvidos. Adiciona tambem o vertice oposto a cada face, que
# sera usado para calcular o sentido da reta normal ao plano da face. Ainda,
# cria-se aqui os vizinhos do simplexo inicial, que podem ser encontrados de
# forma relativamente simples nesta fase do processamento.
sub ros {

  my @rotulos = @{shift()};   # Rotulos dos vertices
  my $faces;                  # Conjunto de arestas
  my @viz     = 1..4;         # pq um simplexo possui 4 faces

  for (my $i=0; $i < @rotulos; $i++) {

    ${$faces}{$i+1} = {
                        'triangulo' =>  [
                                          $rotulos[$i%@rotulos],
                                          $rotulos[($i+1)%@rotulos],
                                          $rotulos[($i+2)%@rotulos],
                                        ],

                        'oposto'    =>  $rotulos[($i+3)%@rotulos],

                        # nos vizinhos do primeiro simplexo essa regra eh
                        # valida, mais adiante teremos que organizar conforme a
                        # adicao de novas faces. Parece hardcoded, mas se vc
                        # desenhar no papel vai ver q esta certo. Usei a
                        # relacao do trabalho anterior, onde o indice da face
                        # corresponde ao indice do vertice que nao participa da
                        # aresta que a face vizinha tem em comum com a face
                        # atual
                        'vizinhos'  =>  [
                                          $viz[($i+1)%@viz],
                                          $viz[($i+2)%@viz],
                                          $viz[($i+3)%@viz]
                                        ]
                      };
  }

  $faces;

} # /ros

# Testa se a normal aponta para fora do poligono, e inverte caso ela aponte
# para dentro.
sub joffrey {

  my $N     = shift;
  my $op    = shift;

  if (podrick($N,$op) < 0) { @$N; }
  else { (-$$N[0], -$$N[1], -$$N[2]); }

} #/joffrey

# Encontra a equacao do plano:
sub tywin {

  # Referencia da face:
  my $face_ref        = shift;

  # Extracao dos vertices:
  my ($v1, $v2, $v3)  = @{${$face_ref}{'triangulo'}};

  # Extracao das coordenadas dos vertices e consequente calculo de dois vetores
  # que definem o plano que os 3 vertices definem:
  my @ab              = cersei(${$vertices}{$v1}, ${$vertices}{$v2});
  my @ac              = cersei(${$vertices}{$v1}, ${$vertices}{$v3});

  my @N               = shae(\@ab, \@ac);

  # Aqui vamos aproveitar para calcular o sentido da normal, usando o vertice
  # oposto aa face
  my $oposto          = ${$face_ref}{'oposto'};   # Definido em ros()

  my @oposto          = cersei(${$vertices}{$v1}, ${$vertices}{$oposto});
  @N                  = joffrey(\@N, \@oposto);


  # Agora vamos encontrar a equacao do plano descrito pelos dois vetores acima.
  # Primeiro, achamos o valor de 'd':
  for my $i ($v1, $v2, $v3) {

    my ($u, $v, $w)   = @{${$vertices}{$i}};
    #print "i: $i|||UVW: $u,$v,$w  ABC:@N\n";

    # Evitando o vetor nulo:
    unless ($u == 0 && $v == 0 && $w ==0) {

      # Na eq do plano temos os indices da normal seguidos das coordenadas
      # x,y,z de algum ponto no plano:
      my $d               = -($N[0]*$u + $N[1]*$v + $N[2]*$w);
      #print "$N[0].$u + $N[1].$v + $N[2].$w + $d\n\n";

      # Equacao na forma: a.x + b.y + c.z + d
      ${$face_ref}{'eq'}  = {
                              'a' =>  $N[0],
                              'b' =>  $N[1],
                              'c' =>  $N[2],
                              'd' =>  $d
                            };
      last;

    } else { next; }

  } #/for (v1,v2,v3)

  # Nao eh necessario retornar valor algum, uma vez que a propria referencia
  # foi usada, e portanto, a variavel jah esta atualizada. Esse comentario esta
  # aqui por motivos historicos
  #$face_ref;

} #/tywin

# Cria o primeiro simplexo a partir dos vertices escolhidos por tyrion()
sub alerie {

  my $simplexo  = tyrion();   # tyrion retorna uma referencia p um array

  # Criando os triangulos do simplexo inicial:
  my $faces     = ros($simplexo);

  # Debug:
  #for my $k1 (sort keys %$faces) {
  # print "[alerie] k1: $k1\n";
  #  for my $k2 (sort keys ${$faces}{$k1}) {
  #    if (ref(${$faces}{$k1}{$k2})) {
  #      print "[alerie] C: $k2 -> V: @{${$faces}{$k1}{$k2}}\n";
  #    }else {
  #      print "[alerie] C: $k2 -> V: ${$faces}{$k1}{$k2}\n";
  #    }
  #  }
  #}


  # Cada uma das faces acima representa um triangulo, agora vamos percorrer
  # essa lista de faces e montar os planos, rotulos e o q mais possa ser
  # interessante para construir o simplexo inicial.
  for (sort keys %$faces) {

    # Calcula a equacao do plano. Note que basta passar a referencia, e tywin
    # atualiza a estrutura a partir do contexto aqui
    tywin(${$faces}{$_});

    # Feito isso, vamos encontrar o ponto mais distante de cada uma das faces
    # do simplexo, este sera o campo de busca da face.
    daario_naharis(${$faces}{$_});


  } #/for (@$faces)

} # /alerie
# Proximos passos:
#
# Fazer um calculo para saber em que direcao do plano ficam os vertices
# visiveis por tal plano.
# Percorrer as faces do simplexo, buscando o vertice 'visivel' mais distante e
# inseri-lo no fecho.
# Remover a face corrente, e criar outras tres, entre o vertice inserido e os 3
# vertices que compunham a face recem excluida.
# Fazer isso enquanto houverem vertices fora do poliedro.
# Achar um jeito de verificar se o poligono continua convexo depois de
# adicionar um vertice.


##########
## Main ##
##########
arya();
alerie();

# debug
#print "[main] C: $_ V: @{${$vertices}{$_}}\n" for (sort keys %$vertices);

