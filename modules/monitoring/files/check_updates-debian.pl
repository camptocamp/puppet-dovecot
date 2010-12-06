#!/usr/bin/env perl
use strict;

use lib "/usr/lib64/nagios/plugins";
use lib "/usr/lib/nagios/plugins";
use utils qw(%ERRORS);

my $updates = `aptitude -sy safe-upgrade` ;
my $status;
my $output;

if ( $updates =~ /No packages will be installed, upgraded, or removed./i ) {
  $output = 'OK: System is up-to-date';
  $status = "OK";
} else {
  $output = 'Warning: System needs updates';
  $status = "WARNING";
}

print $output."\n";
exit $ERRORS{$status};
