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
        base     => "/usr/bin",
        command  => "sudo",
        options  => "${monitoring::params::customplugins}check_system_update.pl",
        type     => "passive",
        server   => $nagios_nsca_server,
      }

      common::concatfilepart {"monitoring.check_system_update":
        ensure => present,
        file   => "/etc/sudoers",
        content => "nagios ALL=(ALL) ${monitoring::params::customplugins}check_system_update.pl\n",
      }

    }
    default: { err "$operatingsystem not supported for $class" }
  }
}
