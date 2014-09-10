#!/usr/bin/env perl

use strict;
use warnings;

sub puzzle {

  my $n = shift;

  if ($n == 1)  {

    print "$n ";
    $n;
  }

  elsif ($n%2 == 0) {

    print "$n ";
    puzzle($n/2);
  }
  else {

    print "$n ";
    puzzle(3*$n+1);
  }

}

exit 1 if not $ARGV[0];

for (1..$ARGV[0]) {

  print "Passo $_:\n";
  puzzle($_);
  print "\n";
}
