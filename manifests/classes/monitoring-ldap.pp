/*

*/
class monitoring::ldap {
  monitoring::check {"Process: slapd":
    ensure   => present,
    codename => "check_slapd_process",
    command  => "check_procs",
    options  => "-p 1 -w 1:1 -c 1:1 -C slapd",
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ?{
      /RedHat|CentOS/ => "nagios-plugins-procs",
      default => false
    }
  }

}
