class monitoring::diode {
  include monitoring::params
  monitoring::check {"Net: check Diode":
    codename => "check_diode_status",
    command  => "check_diode.pl",
    base     => "${monitoring::params::customplugins}",
    interval => 1440,
    retry    => 720,
    type     => "passive",
    server   => $nagios_nsca_server,
    require  => File["${monitoring::params::customplugins}/check_diode.pl"],
    package  => $operatingsystem? {
      /Debian|Ubuntu/ => "libwww-perl",
      default => false,
    }
  }

  file {"${monitoring::params::customplugins}/check_diode.pl":
    ensure => present,
    mode   => 0755,
    group  => root,
    owner  => root,
    source => "puppet:///modules/monitoring/",
  }

}
