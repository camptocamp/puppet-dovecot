#!/usr/bin/perl

# Nagios plugin for IPMI sensors status checking.
#
# Especially useful on Dell Poweredge servers, and others that
# implement the Intelligent Platform Management Interface (IPMI)
# interface.
#
# (C) Chris Wilson <check_ipmi@qwirx.com>, 2005-06-04
# Released under the GNU General Public License (GPL)

use warnings;
use strict;

open IPMI, "ipmitool sdr 2>/dev/null |" or die "ipmitool: $!";

my %found;
my %bad;

sub trim ($) {
	my ($v) = @_;
	$v =~ s/^ +//;
	$v =~ s/ +$//;
	return $v;
}

while (my $line = <IPMI>)
{
	chomp $line;
	unless ($line =~ m'^(.*) \| (.*) \| (\w+)$')
	{
		die "Bad format in ipmitool output: $line";
	}

	my $name  = trim $1;
	my $value = trim $2;
	my $state = trim $3;
	$name =~ tr| |_|;

	my $counter = 1;
	my $uname = "$name";
	while ($found{$uname}) {
		$uname = $name . $counter++;
	}

	next if $state eq "ns";

	if ($state ne "ok") {
		$bad{$uname} = $state;
	}

	$found{$uname} = $value;
}

if (keys %bad) {
	print "IPMI critical: ";
	my @bad;
	foreach my $name (sort keys %bad) {
		push @bad, "$name is $bad{$name}";
	}
	print join(", ", @bad) . " ";
} else {
	print "IPMI ok ";
}

my @out;

foreach my $name (sort keys %found) {
	next unless $name =~ m|Fan| or $name =~ m|Temp|;
	push @out, "$name = $found{$name}";
}

print "(" . join(", ", @out) . ")\n";

if (%bad) { exit 2 } else { exit 0 }

