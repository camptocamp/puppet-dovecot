#!/usr/bin/perl -wl
# Managed by puppet
# Include configuration per vhost
# usage: include-conf-enabled.pl <path-to-vhost>

use strict;
use File::Glob ':glob';

my $confdir = $ARGV[0];
my $enabled = "/*.conf";


chdir($confdir);
my @files = bsd_glob($enabled);

for my $file (@files) {
  print "include \"$file\"";
}
