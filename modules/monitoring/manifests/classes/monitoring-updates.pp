class monitoring::updates {
  include monitoring::params
  case $operatingsystem {
    Debian,Ubuntu: {
      file {"${monitoring::params::customplugins}check_system_update.pl":
        ensure => present,
        source => "puppet:///modules/monitoring/check_updates-debian.pl",
        mode   => 0755,
        owner  => root,
        group  => root,
      }

      monitoring::check {"OS: system update":
        ensure => present,
        require => File["${monitoring::params::customplugins}check_system_update.pl"],
        codename => "check_system_update",
        base     => "${monitoring::params::customplugins}",
        sudo     => "root",
        command  => "check_system_update.pl",
        type     => "passive",
        server   => $nagios_nsca_server,
        interval => "1440", # once a day
        retry    => "1440", # once a day
      }

    }
    default: { err "$operatingsystem not supported for $class" }
  }
}
