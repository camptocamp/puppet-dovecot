class ssh-ng {
  package { "ssh":
    ensure => installed
  }

  service { "ssh":
    ensure => running,
    hasrestart => true,
    pattern => "/usr/sbin/sshd",
  }
  
  # SSH known_hosts generation using puppet black magic (known as exported ressources)
  #@@sshkey { $fqdn:
  #  type => dsa,
  #  key => $sshdsakey
  #}
#
#  Sshkey <<| |>>
#
#  Sshkey {
#    require => Package["ssh"]
#  }
}
