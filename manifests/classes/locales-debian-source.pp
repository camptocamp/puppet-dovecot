/*


*/
class locales::debian::source inherits locales::debian {
  package {"locales-all":
    ensure => absent,
  }

  package {"locales":
    ensure => present,
    require => Package["locales-all"],
  }

  file {"//usr/share/locale/locale.alias":
    ensure => "/etc/locale.alias",
    force  => true,
    require => Package["locales"],
  }

  exec {"locale-gen":
    refreshonly => true,
    command => "locale-gen",
    timeout => 30,
    require => Package["locales"],
  }
}
