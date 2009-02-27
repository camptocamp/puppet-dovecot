class apt::unattended-upgrade::automatic inherits apt::unattended-upgrade {
  apt::conf{"99unattended-upgrade":
    ensure  => present,
    content => "APT::Periodic::Unattended-Upgrade \"1\";\n",
  }

  apt::conf{"50unattended-upgrades":
    ensure => present,
    source => "puppet:///apt/unattended-upgrades.${lsbdistcodename}",
  }
}
