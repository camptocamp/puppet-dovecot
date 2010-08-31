class puppet::client {

  package {"facter":
    ensure  => $facter_version ? {
      ""      => latest,
      default => $facter_version,
    },
    require => [Exec["update pkg cache if necessary"], Package["lsb-release"]],
    tag     => "install-puppet",
  }

  package {"puppet":
    ensure  => $puppet_client_version ? {
      ""      => latest,
      default => $puppet_client_version,
    },
    require => [Package["facter"], Exec["update pkg cache if necessary"]],
    tag     => "install-puppet",
  }

  package {"lsb-release":
    name => $operatingsystem ? {
      Debian => "lsb-release",
      Ubuntu => "lsb-release",
      Redhat => "redhat-lsb",
      fedora => "redhat-lsb",
      CentOS => "redhat-lsb",
    },
    ensure => present,
  }

  service { "puppet":
    ensure    => stopped,
    enable    => false,
    hasstatus => false,
    tag       => "install-puppet",
    pattern   => $operatingsystem ? {
      Debian => "ruby /usr/sbin/puppetd -w 0",
      Ubuntu => "ruby /usr/sbin/puppetd -w 0",
      RedHat => "/usr/bin/ruby /usr/sbin/puppetd$",
      CentOS => "/usr/bin/ruby /usr/sbin/puppetd$",
    }
  }

  user { "puppet":
    ensure => present,
    require => Package["puppet"],
  }

  file {"/etc/puppet/puppetd.conf": ensure => absent }

  if ( ! $puppet_environment ) {
    $puppet_environment = "production"
  }

  file {"/etc/puppet/puppet.conf":
    ensure => present,
    content => template("puppet/puppet.conf.erb"),
    require => Package["puppet"],
    tag     => "install-puppet",
  }

  file {"/var/run/puppet/":
    ensure => directory,
    owner  => "puppet",
    group  => "puppet",
  }

  case $operatingsystem {

    Debian: {

      # remove legacy files
      file { ["/etc/network/if-up.d/puppetd", "/etc/network/if-down.d/puppetd"]:
        ensure => absent,
      }

      exec {"update pkg cache if necessary":
        command => "true",
        unless  => $puppet_client_version ? {
          ""      => "true",
          default => "apt-cache policy puppet | grep -q ${puppet_client_version}",
        },
        notify  => Exec["apt-get_update"],
      }

      exec {"update pkg cache if facter is not yet available":
        command => "true",
        unless  => $facter_version ? {
          ""      => "true",
          default => "apt-cache policy facter | grep -q ${facter_version}",
        },
        before  => Exec["update pkg cache if necessary"],
        notify  => Exec["apt-get_update"],
      }
    }

    default: {
      # fake command just to satisfy dependencies
      exec {"update pkg cache if necessary":
        command => "true",
        onlyif => "false",
      }
    }
  }


  file{"/usr/local/bin/launch-puppet":
    ensure => present,
    mode => 755,
    content => template("puppet/launch-puppet.erb"),
    tag     => "install-puppet",
  }

  # Run puppetd with cron instead of having it hanging around and eating so
  # much memory.
  cron { "puppetd":
    ensure  => present,
    command => "/usr/local/bin/launch-puppet",
    user    => 'root',
    environment => "MAILTO=root",
    minute  => $puppet_run_minutes ? {
      ""      => ip_to_cron(2),
      "*"     => undef,
      default => $puppet_run_minutes,
    },
    hour    => $puppet_run_hours ? {
      ""      => undef,
      "*"     => undef,
      default => $puppet_run_hours,
    },
    require => File["/usr/local/bin/launch-puppet"],
    tag     => "install-puppet",
  }         
}
