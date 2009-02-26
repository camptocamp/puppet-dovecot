#! /usr/bin/perl -w

#####################################################################
# What's this ?
#####################################################################
# Checks the health of RAID disks
# Requires aacraid driver and afacli program
# More infos on http://www.ibnads.com/afacli-nagios/
# Script designed for Nagios/NRPE
#
# Usage :
# You can set warning level and cirtical level with -w and -c
# This level corresponds to the number of disks in failure
# Option -h displays a small usage message
#
# Copyright (C) 2004 Clement OUDOT <clement.oudot -=- linagora dot com>
#                    Craig Kelley <ckelley -=- ibnads dot com>
#                    Jonathan Delgado
# Copyright (C) 2001 Kent Zeibell and Matt Domsch
# Copyright (C) 2005 Marc Fournier (battry and log fixes)
#                    Jason Short (added history_size for afacli)
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
use File::Temp qw / tempfile /;

#####################################################################
# Configuration / Options
#####################################################################

my $TEMP = "/var/tmp";
my $AFACLI = "/usr/sbin/afacli";
my $USAGE = "
$0 [-v] [-a container] [-l path to syslog] <-w num drives> <-c num drives>

     -a containter (default=afa0)
     -b ignore battery state (for systems with no battery backup)
     -c # of drives at or below triggers a critical failure
     -l path to syslog where AAC errors would be reported (default=/var/log/messages)
     -v verbose output -- for running manually only, not from Nagios/nrpe
     -w # of drives at or below triggers a warning

";
my %ERRORS = ( 'OK' => 0,
	       'WARNING' => 1,
	       'CRITICAL' => 2,
	       'UNKNOWN' => 3 );

my %opts;
unless (getopts('a:bc:l:vw:', \%opts)) {
   print $USAGE;
   critical();
}

# create a temporary file to store AFA commands
unless (-d $TEMP) {
   print "Temporary directory $TEMP does not exist\n";
   critical();
}
unless ((defined $opts{c}) &&
	(defined $opts{w})) {
   print $USAGE;
   critical();
}

my $container = (defined $opts{a}) ? $opts{a} : "afa0";
my $syslog =  (defined $opts{l}) ? $opts{l} : "/var/log/messages";

#####################################################################
# Setup
#####################################################################

my ($outfh, $outfilename) = tempfile("afacmd_XXXXXXXX", SUFFIX => '.dat', UNLINK => 0, DIR => $TEMP);
$ENV{PATH} = "/bin:/usr/bin:/sbin:/usr/sbin";
$ENV{TERM} = "dumb";
my $status_description = "";
my %healthy_drives;		# will be populated with the good drives in the array
my $battery = "Unknown";	# will contain battery status

#####################################################################
# Query AFACLI
#####################################################################

if (open (AFACLI, "| $AFACLI >/dev/null")) {

   # write our script out to afacli
   print AFACLI "history_size 999\n";
   print AFACLI "logfile start \"" . $outfilename . "\"\n";
   print AFACLI "open /readonly=true \\$container\n";
   print AFACLI "disk list\n";
   print AFACLI "enclosure show temperature\n";
   print AFACLI "disk show space\n";
   print AFACLI "controller details\n";
   print AFACLI "close\n";              # `controler details` eats a char sometimes... afacli is
   print AFACLI "close\n";		# a very strange "utility"
   print AFACLI "logfile end\n";
   print AFACLI "exit\n";
   AFACLI->close();

   # read output of afacli via the logfile that it wrote
   unless (open LOGFILE, $outfilename) {
      print "Unable to read logfile '$outfilename' : $!";
      critical();
   }      
   my $parse_mode = "";
   while (my $line = <LOGFILE>) {

      if ($parse_mode eq "disk") {
	 if ($line =~ /\S/) {
	    # 0:00:0   Disk            71132959  512         Initialized      NO     160
	    my ($scsi_id, $device_type, $blocks, $bytes, $status, $shared, $rate) = 
	       split (/\s+/, $line);
	    if ($status =~ /Initialized/) {
	       $status_description .= "disk$scsi_id OK ";
	    }
	    else {
	       print "disk ($scsi_id) CRITICAL\n";
	       critical();
	    }
	 }
	 else {
	    # no more disks to read about
	    $parse_mode = "";
	 }
	 next;
      }
      elsif ($parse_mode eq "temp") {
	 if ($line =~ /\S/) {
	    $line =~ s/^\s+//;
	    #  0  0:06:0   0       73 F         120    NORMAL
	    my ($id, $enclosure, $sensor, $temp, $units, $threshold, $status) = 
	       split (/\s+/, $line);
	    if ($status =~ /NORMAL/) {
	       $status_description .= "temp$sensor ($temp) OK ";
	    }
	    else {
	       print "temp$sensor ($temp:$status) CRITICAL\n";
	       critical();
	    }
	 }
	 else {
	    # no more temperatures to read about
	    $parse_mode = "";
	 }
	 next;
      }
      elsif ($parse_mode eq "space") {
	 if ($line =~ /\S/) {
	    $line =~ s/^\s+//;
	    #    0:00:0     Container 64.0KB:33.8GB
	    my ($id, $usage, $size) = split (/\s+/, $line);
	    if ($usage =~ /Initialized|Free|Container/i) {
	       $healthy_drives{$id} = 1;
	    }
	    else {
	       print "size$id ($usage) CRITICAL\n";
	       critical();
	    }
	 }
	 else {
	    # no more space entries to read about
	    $parse_mode = "";
	 }
	 next;
      }
      elsif ($line =~ /\s+Battery State: (\w+)/ ) {
	 $battery = $1;
      }
      elsif ($line =~ /Device Type\s*Blocks\s*Bytes\/Block Usage\s*Shared\s*Rate/) {
	 # disk informatin will follow this header
	 my $junk = <LOGFILE>;	# skip the "---- ---" separators
	 $parse_mode = "disk";
	 next;
      }
      elsif ($line =~ /Sensor\s*Temperature\s*Threshold\s*Status/) {
	 # temperature
	 my $junk = <LOGFILE>;	# skip the "---- ---" separators
	 $parse_mode = "temp";
	 next;
      }
      elsif ($line =~ /Scsi\s*B:ID:L\s*Usage\s*Size/) {
	 # disk space follows this header
	 my $junk = <LOGFILE>;	# skip the "---- ---" separators
	 $parse_mode = "space";
	 next;
      }
   }
   close LOGFILE;
}
else {
   print "Unable to exec $AFACLI : $!\n";
   unknown();
}

# make sure drive count is accurate
{
   my $drive_count = scalar (keys %healthy_drives);
   if ($drive_count < $opts{c}) {
      print "$drive_count healthy drives CRITICAL\n";
      critical();
   }
   if ($drive_count < $opts{w}) {
      print "$drive_count healthy drives WARNING\n";
      warning();
   }
}

# check system logs for AAC errors
{
   #  The next check is just looking for AAC: messages in /var/log/messages
   #
   #  Raid error messages look something like the following:
   #
   #  AAC:ID(0:02:0); Selection Timeout [command:0x28]
   #  AAC:Drive 0:2:0 returning error
   #  AAC:ID(0:02:0) - drive failure (retries exhausted)
   #  AAC:RAID5 Container 0 Drive 0:2:0 Failure
   #  AAC:ID(0:02:0) [DC_Ioctl] DiskSpinControl: Drive spindown failure
   #  AAC:RAID5 Failover Container 0 No Failover Assigned
   #  AAC:Drive 0:2:0 offline on container 0:
   #  AAC:RAID5 Failover Container 0 No Failover Assigned

   my $err_count = `egrep "(AAC|aacraid):" $syslog | egrep -vi 'batter|falsely claims to have parameter commit' | wc -l`;
   $err_count =~ s/\D//g;
   if ($err_count > 0) {
      print "detected $err_count aacraid errors in $syslog\n";
      critical();
   }
   else {
      $status_description .= "log OK ";
   }

}

# make sure battery is in 'OK' state
unless (defined $opts{b}) {
   if ($battery =~ /ok/i) {
      $status_description .= "bat OK ";
   }
   else {
      if (($battery =~ /Reconditioning/i ) ||
	  ($battery =~ /Low/i ) ||
	  ($battery =~ m/Charging/i )) {
	 print "Battery state '$battery'";
	 warning();
      }
      else {
	 print "Battery state '$battery'";
	 critical();
      }
   }
}

# if we get here, everything seems dandy

cleanup();
print $status_description . "\n";
exit $ERRORS{OK};

#####################################################################
# Subs
#####################################################################

sub cleanup {

   if ((defined $outfilename) && (-e $outfilename)) {
      if (defined $opts{v}) {
	 system("/bin/cat", $outfilename);
      }
      unlink $outfilename;
   }

}

sub critical {

   cleanup();
   exit $ERRORS{CRITICAL};

}

sub unknown {

   cleanup();
   exit $ERRORS{UNKNOWN};

}

sub warning {

   cleanup();
   exit $ERRORS{WARNING};

}
