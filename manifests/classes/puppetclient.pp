class puppet::client {
  package {"facter":
    ensure => $facter_version,
    require => Exec["update apt cache if necessary"],
  }

  package {"puppet":
    ensure => $puppet_client_version,
    require => [Package["facter"], Exec["update apt cache if necessary"]],
  }

  package {"lsb-release":
    ensure => present,
  }

    # Augeas support
  package {"libaugeas-ruby1.8":
    ensure => present,
  }
  
  package {"augeas-tools":
    ensure => present,
  }            

  # Puppet client freeze after an upgrade... issue requiring investigation.
  exec { "puppetclient-restart":
    command     => 'kill -9 $(pidof ruby); /usr/sbin/puppetd', # Ugly...
    #subscribe   => Package["puppet"],
    refreshonly => true,
  }
  
  service { "puppet":
    ensure => stopped,
    enable => false,
    pattern => "ruby /usr/sbin/puppetd -w 0",
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

  exec {"update apt cache if necessary":
    command => "true",
    unless  => "apt-cache policy puppet | grep -q ${puppet_client_version} && apt-cache policy facter | grep -q ${facter_version}",
    notify  => Exec["apt-get_update"],
  }

  file{"/usr/local/bin/launch-puppet":
    ensure => present,
    mode => 755,
    content => template("puppet/launch-puppet.erb"),
  }

  # Run puppetd with cron instead of having it hanging around and eating so
  # much memory.
  cron { "puppetd":
    ensure  => present,
    command => "/usr/local/bin/launch-puppet",
    user    => 'root',
    minute  => ip_to_cron(2),
    require => File["/usr/local/bin/launch-puppet"],
  }         
}
