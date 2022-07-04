#!/usr/bin/env perl

use strict;
use warnings;
use Alien::OpenMP;

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

/*
 * lack of 'nowait' means there is an implicit
 * barrier at the end of each 'single' block,
 * meaning the Inline_Stack_Push happens sequentially ...
*/

  #pragma omp parallel
  {
    #pragma omp single
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_year)));
    #pragma omp single
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_mon)));
    #pragma omp single
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_mday)));
    #pragma omp single
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_hour)));
    #pragma omp single
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_min)));
    #pragma omp single
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_sec)));
    #pragma omp single
      Inline_Stack_Push(sv_2mortal(newSViv(ltime->tm_isdst)));
  }
  Inline_Stack_Done;
}
