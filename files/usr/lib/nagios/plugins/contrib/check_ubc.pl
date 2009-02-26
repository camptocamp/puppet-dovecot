#!/usr/bin/perl
use strict;
use Data::Dumper;
use lib "/usr/lib/nagios/plugins";
use utils qw(%ERRORS);

my $file = '/tmp/check_ubc';
my $status = 'OK' ;
my $vid ;
my $resource ;
my $held ;
my $maxheld ;
my $barrier ;
my $limit ;
my $failcnt ;
my %beancounters ;
my %beancounters_old ;
my $out = 'Userbeacounter has NO failcount. All green';

if (-e $file) {
  open (FILE, '< /proc/user_beancounters') || die("Cannot open user_beancounter : $!\n");
  while(<FILE>) {
    my %vmachine;
    if ( /\D*(\d+):.*/ ){ 
      $vid=$1; $beancounters{$vid}=\%vmachine ; 
    }
    if ( /^[\W\d]+([a-z]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+).*/ ) {
      $resource=$1 ;
      $held=$2 ;
      $maxheld=$3 ;
      $barrier=$4 ;
      $limit=$5 ;
      $failcnt=$6 ;
      ${beancounters{$vid}}{$resource}=[$held , $maxheld , $barrier , $limit ,$failcnt ];
      if ( ($held  > $barrier) && ($barrier != 0) ) {
        $out = "Limits on $vid: $resource  held->$held , barrier->$barrier ( limit->$limit ) " ;
        $status = 'WARNING';
      }
    }
  }
  close FILE;
 # read and parse old data
  open(MYINPUTFILE, "< $file") || die("Cannot open $file : $!\n");
  while(<MYINPUTFILE>){
    my %vmachine;
    if ( /\D*(\d+):.*/ ){ $vid=$1; $beancounters_old{$vid}=\%vmachine ; }
    if ( /^[\W\d]+([a-z]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+).*/ ) {
      $resource=$1 ;
      $held=$2 ;
      $maxheld=$3 ;
      $barrier=$4 ;
      $limit=$5 ;
      $failcnt=$6 ;
      ${beancounters_old{$vid}}{$resource}=[$held , $maxheld , $barrier , $limit ,$failcnt ];
    }
  }
  close MYINPUTFILE;

  foreach my $vmachine_id (keys %beancounters) {
    foreach my $resource (keys %{$beancounters{$vmachine_id}} ) {
      if ( defined($beancounters{$vmachine_id}{$resource}[4]) && defined($beancounters_old{$vmachine_id}{$resource}[4]) ){
        my $failcnt=$beancounters{$vmachine_id}{$resource}[4];
        my $failcnt_old=$beancounters_old{$vmachine_id}{$resource}[4];
        my $held=$beancounters{$vmachine_id}{$resource}[0];
        my $maxheld=$beancounters{$vmachine_id}{$resource}[1];
        my $barrier=$beancounters{$vmachine_id}{$resource}[2];
        my $limit=$beancounters{$vmachine_id}{$resource}[3];
        if ( $failcnt_old < $failcnt ){
          $out = "Incrased failcnt  $vmachine_id: $resource from $failcnt_old to $failcnt (held->$held , maxheld->$maxheld , barrier->$barrier , limit->$limit ) " ;
          $status = 'CRITICAL';
        }
      }
    }

  }
} else {
  `cp /proc/user_beancounters $file`;
}
print STDOUT "$status: $out\n";
exit $ERRORS{$status};
