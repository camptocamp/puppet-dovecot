#!/usr/bin/env perl
use strict;

use lib "/usr/lib64/nagios/plugins";
use lib "/usr/lib/nagios/plugins";
use utils qw(%ERRORS);

my $updates = `aptitude -sy safe-upgrade` ;
my $status;
my $output;

# 0 packages upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
$updates =~ /([0-9]+) packages upgraded, ([0-9]+) newly installed, ([0-9]+) to remove and ([0-9])+ not upgraded/i ;

if (($1,$2,$3,$4) == 0) {
  $status = 'OK';
  $output = "OK: system is up to date\n";
} else {
  $status = 'WARNING';
  $output = "WARNING: need $1 upgrade, $2 new, $3 remove, $4 not upgraded\n";
}
print $output;
exit $ERRORS{$status};

