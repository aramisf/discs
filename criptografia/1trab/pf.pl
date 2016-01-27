#!/usr/bin/perl

use strict;
use warnings;

require "lib/Playfair.pm";

# FileHandles:
my $texto_cifrado;                    # Sera lido da entrada, 1o parametro
my $dicionario;                       # Idem ^, 2o parametro

# String gigante contendo o texto inteiro cifrado
my $texto_cifrado_str;


if (@ARGV < 2) {  # Se for maior nao da nada, vo ignorar do 3o parametro em
                  # diante

  print "Uso:\n\t";
  print "$0 <arquivo com o texto cifrado> <arquivo com a lista de chaves>\n\n";
  exit 1;
}

else {

  if (-f $ARGV[0]) {    # Diferente do C, $ARGV[0] contem o 1o parametro
                        # passado para o programa

    open ($texto_cifrado, "<", $ARGV[0]) or
      die "Erro ao abrir $ARGV[0]: $!\n";

    open ($dicionario, "<", $ARGV[1]) or
      die "Erro ao abrir $ARGV[1]: $!\n";
  }
}

# Lendo o texto cifrado e armazenando ele em uma string soh, potencialmente
# gigante.
while (<$texto_cifrado>) {

  s/\s+//g;
  $texto_cifrado_str .= $_;
}

# Somente caracteres minusculos
$texto_cifrado_str  = lc $texto_cifrado_str;

# Caso nao exista um diretorio para conter os resultados:
mkdir "resultados" unless -d "resultados";

# Agora percorre a lista de chaves
while (my $chave  = <$dicionario>) {

  # Removendo espacos em branco
  $chave  =~ s/\s+//g;

  Playfair::decrypt($chave,$texto_cifrado_str,0);
}

# Neste ponto do programa teremos uma lista com as 5 chaves mais provaveis
# (sendo o primeiro eh o mais provavel)
Playfair::resultados($texto_cifrado_str);

exit 0;
