#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

# Na documentacao diz que eh interessante colocar esses blocos BEGIN aqui, mas
# mesmo com eles comentados os testes estao passando, entao vou deixar aqui
# apenas como lembrete para o futuro.
#BEGIN {
  require_ok("Playfair");   # Testa se o modulo "Playfair" eh carregado com
                        # sucesso.
#}

#BEGIN {
  # Se fosse classe:
  #my $obj = Playfair->novo();  # Instancia um novo objeto
  #isa_ok $obj, "Playfair";     # Testa se instanciou corretamente

  #is $obj->decrypt, "Dae\n", "Decrypt funciona";  # Testa retorno da funcao
  is Playfair::decrypt(), "Dae\n", "Decrypt funciona";  # Testa retorno da funcao

  # Testando a geracao das chaves, passando um tamanho maximo de chaves:
  my $MAXLEN  = 6;
  #my @meta_chaves = $obj->gera_meta_chaves($MAXLEN);
  my @meta_chaves = Playfair::gera_meta_chaves($MAXLEN);
  is @meta_chaves, $MAXLEN, "Meta-chave com tamanho correto";

  # Testando a separacao das strings.
  #is $obj->split("asdf"), "as df",  "asdf separado corretamente";
  #is $obj->split("aasd"), "ax as dx", "'aasd' separado corretamente";

#}



done_testing();
