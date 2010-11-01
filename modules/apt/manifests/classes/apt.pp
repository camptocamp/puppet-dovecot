class apt {
  Package {
    require => Exec["apt-get_update"]
  }

  # apt support preferences.d since version >= 0.7.22
  case $lsbdistcodename { 
    /lucid|squeeze/ : {

      file {"/etc/apt/preferences":
        ensure => absent,
      }

      file {"/etc/apt/preferences.d":
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => 755,
        recurse => true,
        purge   => true,
        force   => true,
      }
    }
  }

  # ensure only files managed by puppet be present in this directory.
  file { "/etc/apt/sources.list.d":
    ensure  => directory,
    source  => "puppet:///apt/empty/",
    recurse => true,
    purge   => true,
    force   => true,
    ignore  => ".placeholder",
  }

  apt::conf {"10periodic":
    ensure => present,
    source => "puppet:///apt/10periodic",
  }

  exec { "apt-get_update":
    command => "apt-get update",
    refreshonly => true,
  }
}
