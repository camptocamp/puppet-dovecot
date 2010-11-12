class monitoring::openvz {
  include monitoring::params
  vcsrepo {"/opt/nagios-plugins/check_beancounter":
    ensure => present,
    provider => git,
    source   => "git://github.com/peletiah/openvz.git",
    revision => "474a9193f4f1723e9e422ef9c511c249115ed54a",
  }

  file {"/opt/nagios-plugins/check_beancounter/check_beancounter.py":
    ensure  => present,
    mode    => 0755,
    owner   => root,
    group   => root,
    require => Vcsrepo["/opt/nagios-plugins/check_beancounter"],
  }

  file {"/opt/nagios-plugins/check_beancounter.py":
    ensure => "/opt/nagios-plugins/check_beancounter/check_beancounter.py",
    require => Vcsrepo["/opt/nagios-plugins/check_beancounter"],
  }

  monitoring::check {"System: Userbeancounter":
    ensure   => present,
    base     => "/usr/bin/",
    codename => "check_beancounter",
    command  => "sudo",
    options  => "${monitoring::params::customplugins}check_beancounter.py -c",
    type     => "passive",
    server   => $nagios_nsca_server,
    require  => File["/opt/nagios-plugins/check_beancounter.py"],
  }

  common::concatfilepart {"monitoring.check_beancounter":
    ensure  => present,
    file    => "/etc/sudoers",
    content => "nagios ALL=(ALL) ${monitoring::params::customplugins}check_beancounter.py\n",
  }
}
