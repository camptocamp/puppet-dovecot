#! /usr/bin/perl -w

#####################################################################
# What's this ?
#####################################################################
# Checks the health of RAID disks
# Requires megaraid2 driver
#
# Option -h displays a small usage message
#
# Copyright (C) 2004 Craig Kelley <ckelley@ibnads.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# GPL Licence : http://www.gnu.org/licenses/gpl.txt

#####################################################################
# Modules
#####################################################################

use strict;
use Getopt::Std;
use IO::Handle;

#####################################################################
# Configuration / Options
#####################################################################

my $USAGE = "
$0 [-v] [-a controller] [-c container]

     -a controller (default=hba0)
     -c container (default = 0)
     -v verbose output -- for running manually only, not from Nagios/nrpe

";
my %ERRORS = ( 'OK' => 0,
	       'WARNING' => 1,
	       'CRITICAL' => 2,
	       'UNKNOWN' => 3 );

my %opts;
unless (getopts('a:c:v', \%opts)) {
   print $USAGE;
   critical();
}

my $controller = (defined $opts{a}) ? $opts{a} : "hba0";
my $container = (defined $opts{c}) ? $opts{c} : "0";

#####################################################################
# Setup
#####################################################################

$ENV{PATH} = "/bin:/usr/bin:/sbin:/usr/sbin";
$ENV{TERM} = "dumb";
my $status_description = "Unknown";
my $battery = "Unknown";	# will contain battery status

#####################################################################
# Query Container
#####################################################################

{
   my $container_file = undef;

   # megaraid2 driver puts status in different file names, depending
   # on the container number (don't ask me why...)

   if (($container >=0) &&
       ($container <=9)) {
      $container_file = "raiddrives-0-9";
   }
   elsif (($container >=10) &&
	  ($container <=19)) {
      $container_file = "raiddrives-10-19";
   }
   elsif (($container >=20) &&
	  ($container <=29)) {
      $container_file = "raiddrives-20-29";
   }
   elsif (($container >=30) &&
	  ($container <=39)) {
      $container_file = "raiddrives-30-39";
   }
   else {
      print "container `$container' out of range CRITICAL";
      critical();
   }
   my $data_file = "/proc/megaraid/$controller/$container_file";
   my @data = `/bin/cat $data_file 2>&1`;
   
   # Logical drive: 0:, state: optimal
   my $found = 0;
   foreach my $line (@data) {
      if ($line =~ /^Logical\s+drive:\s+$container:[^,]*,\s+state:\s+([\w\s]+)/i) {
	 $found = 1;
	 my $state = $1;
	 $state =~ s/\s+$//;
	 if ($state =~ /optimal/i) {
	    $status_description = "Logical Drive $container [optimal]";
	 }
	 else {
	    print "Logical Drive $container [$state]\n";
	    critical();
	 }
      }
   }
   if ($found == 0) {
      print "Logical Drive $container NOT FOUND [$data_file]\n";
      critical();
   }
}

# make sure battery is fine
#
#define MEGA_BATT_CHARGE_DONE           0x00 " Charge Done"
#define MEGA_BATT_MODULE_MISSING        0x01 " Module Missing"
#define MEGA_BATT_LOW_VOLTAGE           0x02 " Low Voltage"
#define MEGA_BATT_TEMP_HIGH             0x04 " Temperature High"
#define MEGA_BATT_PACK_MISSING          0x08 " Pack Missing"
#define MEGA_BATT_CHARGE_INPROG         0x10 " Charge In-progress"
#define MEGA_BATT_CHARGE_FAIL           0x20 " Charge Fail"
#define MEGA_BATT_CYCLES_EXCEEDED       0x40 " Cycles Exceeded"

{

   my $bat_state = `cat /proc/megaraid/$controller/battery-status`;
   if ($bat_state =~ /Battery\s+Status:\[(\d+)\]\s+([\w\s]+)/i) {
      my $state_int = $1;
      my $state_str = $2;
      $state_str =~ s/\s+$//;
      if ($state_int == 0x00) {
	 $status_description .= ", Battery [$state_str]";
      }
      elsif ($state_int == 0x01) {
	 print "Battery: $state_str\n";
	 critical();
      }
      elsif ($state_int == 0x02) {
	 print "Battery: $state_str\n";
	 critical();
      }
      elsif ($state_int == 0x04) {
	 print "Battery: $state_str\n";
	 critical();
      }
      elsif ($state_int == 0x08) {
	 print "Battery: $state_str\n";
	 critical();
      }
      elsif ($state_int == 0x10) {
	 print "Battery: $state_str\n";
	 warning();
      }
      elsif ($state_int == 0x20) {
	 print "Battery: $state_str\n";
	 critical();
      }
      elsif ($state_int == 0x40) {
	 print "Battery: $state_str\n";
	 warning();
      }
      else {
	 print "Battery: UNKNOWN STATE '$state_int : $state_str'\n";
	 critical();
      }
   }
   else {
      print "Battery: UNKNOWN STATE: $bat_state\n";
      critical();
   }
}

# if we get here, everything seems dandy

print $status_description . "\n";
exit $ERRORS{OK};

#####################################################################
# Subs
#####################################################################

sub critical {

   exit $ERRORS{CRITICAL};

}

sub unknown {

   exit $ERRORS{UNKNOWN};

}

sub warning {

   exit $ERRORS{WARNING};

}
