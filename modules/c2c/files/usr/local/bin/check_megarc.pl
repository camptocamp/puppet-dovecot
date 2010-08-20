#!/usr/bin/perl -w

use strict;
use Getopt::Std;

my $STATE_OK = 0;
my $STATE_WARNING = 1;
my $STATE_CRITICAL = 2;
my $STATE_UNKNOWN = 3;

my $MEGARC_DIR="/opt/megarc/";          # change this to point to where you installed MegaRC
$ENV{PATH}='/bin:/usr/bin';
$ENV{TERM}='dumb';

#
# Nagios LSI Megaraid monitor for 2.6 kernels -- requires
# megarc from LSI's website, at the time of writing, it can
# be found here:
#
#  http://www.lsilogic.com/downloads/license.do?id=2000&did=8165&pid=2420
#
# and the version # is 1.11(12-07-2004)
#

my $USAGE = "
$0 [-m path to megarc dir] <-w num drives> <-c num drives>

     -m megarc directory (default=/opt/megarc/)
     -c # of drives at or below triggers a critical failure
     -w # of drives at or below triggers a warning
";

my %opts;
unless (getopts('m:c:w:', \%opts)) {
   print $USAGE;
   exit 1;
}

unless ((defined $opts{'c'}) && (defined $opts{'w'})) {
   print $USAGE;
   exit 1;
}

if (defined $opts{'m'}) {
   $MEGARC_DIR = $opts{'m'};
}

# Run MegaRC

chdir $MEGARC_DIR;
my $output = `./megarc -dispCfg -a0  2>&1`;
my @lines = split(/\n/, $output);

# Find out how many active drives we have
my $active_drives = 0;
foreach my $line (@lines) {
    if ($line =~ /\d+\s+\d+\s+[\dabcdefx]+\s+[\dabcdefx]+\s+ONLINE/) {
	$active_drives++;
    }
}

# Find out how many failed drives and degraded arrays we have
my $failed_drives = 0;
my $degraded_arrays = 0;
foreach my $line (@lines) {
    if ($line =~ /FAILED/) {
	$failed_drives++;
    }
    if ($line =~ /DEGRADED/) {
	$degraded_arrays++;
    }
}

if (($active_drives == 0) &&
    ($failed_drives == 0) &&
    ($degraded_arrays == 0)) {
    # running megarc probably failed
    print @lines;
    exit $STATE_CRITICAL;
}

# Compare output with what is expected
if (($failed_drives == 0) &&
    ($degraded_arrays == 0)) {
   if ($active_drives < $opts{'c'}) {
      print "CRITICAL - $active_drives active drives (expecting $opts{'c'})\n";
      exit $STATE_CRITICAL;
   }
   if ($active_drives < $opts{'w'}) {
      print "WARNING - $active_drives active drives (expecting $opts{'w'})\n";
      exit $STATE_WARNING;
   }
   print "OK - $active_drives active drives\n";
   exit $STATE_OK;
} else {
   print "CRITICAL - failed_drives=$failed_drives degraded_arrays=$degraded_arrays\n";
   exit $STATE_CRITICAL;
}

# done
