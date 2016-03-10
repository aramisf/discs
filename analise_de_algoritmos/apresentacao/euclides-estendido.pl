#!/usr/bin/env perl

use strict;
use warnings;
use integer;
use POSIX qw(floor);

sub ee {

  my ($a, $b) = @_;
  #print "\$a = $a  \$b = $b\n";
  #print "retornando (1,0,$a) pois \$b == 0\n" if $b == 0;
  return (1,0,$a) if $b == 0;

  print "-->my (\$x, \$y, \$d) = ee($b, $a % $b) IDA\n";
  my ($x, $y, $d) = ee($b, $a % $b);
  print "<--my ($x, $y, $d) = ee($b, $a % $b)VOLTA\n";
  #print "retornando ($y, $x - floor($a/$b)*$y, $d)\n";
  ($y, $x - floor($a/$b)*$y, $d);
}

exit 1 if not @ARGV == 2;

my ($a,$b)    = ($ARGV[0],$ARGV[1]);
my ($x,$y,$d) = ee($a,$b);

print "Resultado: a*x + b*y = d => $a*$x + $b*$y = $d\n";
