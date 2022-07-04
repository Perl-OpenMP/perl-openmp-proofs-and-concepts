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

my ($var1, $var2, $var3, $var4, $var5, $var6, $var7, $var8);
change($var1, $var2, $var3, $var4, $var5, $var6, $var7, $var8);
 
print "\$var1 = $var1\n";
print "\$var2 = $var2\n";
print "\$var3 = $var3\n";
print "\$var4 = $var4\n";
print "\$var5 = $var5\n";
print "\$var6 = $var6\n";
print "\$var7 = $var7\n";
print "\$var8 = $var8\n";
 
__DATA__
__C__
 
int change(SV* var1, SV* var2, SV* var3, SV* var4, SV* var5, SV* var6, SV* var7, SV* var8) {
  #pragma omp parallel
  {
    #pragma omp single nowait
    sv_setpvn(var1, "Perl Rocks!", 11);
    #pragma omp single nowait
    sv_setpvn(var2, "Inline Rules!", 13);
    #pragma omp single nowait
    sv_setpvn(var3, "Perl Rocks!", 11);
    #pragma omp single nowait
    sv_setpvn(var4, "Inline Rules!", 13);
    #pragma omp single nowait
    sv_setpvn(var5, "Perl Rocks!", 11);
    #pragma omp single nowait
    sv_setpvn(var6, "Inline Rules!", 13);
    #pragma omp single nowait
    sv_setpvn(var7, "Perl Rocks!", 11);
    #pragma omp single nowait
    sv_setpvn(var8, "Inline Rules!", 13);
  }
  return 1;
}
