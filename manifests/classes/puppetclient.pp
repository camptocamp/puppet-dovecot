class puppet::client {
  package {["puppet", "facter", "lsb-release"]:
    ensure => latest, 
  }

  # Puppet client freeze after an upgrade... issue requiring investigation.
  exec { "puppetclient-restart":
    command     => 'kill -9 $(pidof ruby); /usr/sbin/puppetd', # Ugly...
    #subscribe   => Package["puppet"],
    refreshonly => true,
  }
  
  service { "puppet":
    ensure => running,
    #subscribe => File["/etc/puppet/puppet.conf"],
  }

  file {"/etc/puppet/puppetd.conf": ensure => absent }

  file {"/etc/puppet/puppet.conf":
    ensure => present,
    content => template("puppet/puppet.conf.erb"),
  }

  file {"/var/run/puppet/":
    ensure => directory,
    before => Package["puppet"],
    owner  => "puppet",
    group  => "puppet",
  }

  # Starts puppet client only when we have network 
  file {"/etc/network/if-up.d/puppetd":
    ensure => present,
    mode   => 655,
    source => "puppet:///puppet/puppetd.if-up",
  }
  
  # stop puppet client as soon as we cut networking
  file {"/etc/network/if-down.d/puppetd":
    ensure => absent,
  }

}
