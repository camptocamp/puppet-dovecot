/*

== Class: monitoring::dell::snmp
Check dell snmp gateway.

Requires:
Module Dell git://github.com/camptocamp/puppet-dell.git

*/
class monitoring::dell::snmp {
  monitoring::check { "Dell OMSA-snmp bridge":
    codename => "check_dell_snmp",
    command  => "check_snmp",
    options  => "-H localhost -R 'dell' -o SNMPv2-SMI::enterprises.674.10892.1.300.10.1.8.1",
    interval => "120", # every 2h
    retry    => "60",  # every 1h
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ? {
      /RedHat|CentOS/  => "nagios-plugins-snmp",
      default => "libnet-snmp-perl",
    },
  }
}

