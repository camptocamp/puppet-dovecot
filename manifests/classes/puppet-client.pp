class c2c::puppet-client inherits puppet::client {
  $c2c_puppet_client_version = "0.24.7-1.1"
  $c2c_facter_version = "1.5.1-0.2"

  include monit

  exec {"update apt cache if necessary":
    command => "true",
    unless  => "apt-cache policy puppet | grep -q ${c2c_puppet_client_version}",
    notify  => Exec["apt-get_update"],
  }

  Package["puppet"] {
    ensure => $lsbdistcodename ? {
      lenny => present,
      default => $c2c_puppet_client_version
    },
    require => [Exec["apt-get_update"], Exec["update apt cache if necessary"], Package["facter"]],
  }

  Package["facter"] {
    ensure => $c2c_facter_version,
    require => [Exec["apt-get_update"], Exec["update apt cache if necessary 2"]],
  }

  exec {"update apt cache if necessary 2":
    command => "true",
    unless  => "apt-cache policy facter | grep -q ${c2c_facter_version}",
    notify  => Exec["apt-get_update"],
  }


  File["/etc/puppet/puppet.conf"] {
    content => template("c2c/puppet.conf.erb"),
    require => Package["puppet"],
  }

  file {"/usr/local/sbin/puppet-ssl-fix.sh":
    ensure => absent,
    source => "puppet:///c2c/puppet-ssl-fix.sh",
    mode   => "755",
  }

  # Run puppetd with cron instead of having it hanging around and eating so
  # much memory.
  Service["puppet"] {
    ensure => stopped,
    enable => false,
    pattern => "ruby /usr/sbin/puppetd -w 0",
  }

  monit::config{"puppet":
    ensure => absent,
  }

  file{"/usr/local/bin/launch-puppet":
    ensure => present,
    mode => 755,
    source => "puppet:///c2c/usr/local/bin/launch-puppet"
  }

  cron { "puppetd":
    ensure  => present,
    command => "/usr/local/bin/launch-puppet",
    user    => 'root',
    minute  => ip_to_cron(2),
    require => File["/usr/local/bin/launch-puppet"],
  }

  # Augeas support
  package {"libaugeas-ruby1.8":
    ensure => installed,
  }

  package {"augeas-tools":
    ensure => installed,
  }
}
