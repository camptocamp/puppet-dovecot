/*

*/
class locales::debian::all inherits locales::debian {
  package {"locales":
    ensure => absent,
  }

  package {"locales-all":
    ensure => present,
    require => Package["locales"],
  }
}
