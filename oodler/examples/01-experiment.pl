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

my @parts = get_localtime(time);

require Data::Dumper;
print Data::Dumper::Dumper(\@parts);
 
__DATA__
__C__
#include <time.h>
 
void get_localtime(SV * utc) {
  const time_t utc_ = (time_t)SvIV(utc);
  struct tm *ltime = localtime(&utc_);

  Inline_Stack_Vars;
  Inline_Stack_Reset;
  #pragma omp parallel
  {
    #pragma omp single nowait
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_year)));
    #pragma omp single nowait
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_mon)));
    #pragma omp single nowait
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_mday)));
    #pragma omp single nowait
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_hour)));
    #pragma omp single nowait
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_min)));
    #pragma omp single nowait
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_sec)));
    #pragma omp single nowait
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_isdst)));
  }
  Inline_Stack_Done;
}
