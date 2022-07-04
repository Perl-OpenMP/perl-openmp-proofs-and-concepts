#!/usr/bin/env perl

use strict;
use warnings;
use Alien::OpenMP;
use OpenMP::Environment ();
use Getopt::Long qw/GetOptionsFromArray/;
use Util::H2O qw/h2o/;

# build and load subroutines
use Inline ( 
  C    => 'DATA',
  with => qw/Alien::OpenMP/,
);

greet(qw(Sarathy Jan Sparky Murray Mike));
 
__DATA__
__C__
void greet(SV* name1, ...) {
  Inline_Stack_Vars;
  int i;
  #pragma omp parallel for ordered
  for (i = 0; i < Inline_Stack_Items; i++) {

      #pragma omp ordered
      printf("Hello %s!\n", SvPV(Inline_Stack_Item(i), PL_na));
  }
  Inline_Stack_Void;
}
