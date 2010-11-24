#!/usr/bin/env perl
use strict;
use lib "/usr/lib/nagios/plugins";
use utils qw(%ERRORS);
use LWP::Simple;

my @hosts = (2..254);
my @errors;

for my $host (@hosts) {

  my $page = get 'http://network.epfl.ch/cgi-bin/annumach/annu.pl?adrip=128.179.66.'.$host.'&etape=affiche_mach' ;
  if ($page =~ /n'existe pas/) {
    if (@errors) {
      print "CRITICAL: ".join(', ', @errors)." are closed\n";
      exit $ERRORS{'CRITICAL'};
    }
    print "OK: Diode is opened\n";
    exit(0);
  }

  if ($page !~ /Ouvert Diode.+tous/i) {
    push(@errors, "128.179.66.$host");
  }
}
