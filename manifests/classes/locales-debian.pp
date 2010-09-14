/*

==Class: locales::debian
Debian specialities. Inherits from locales::base.


*/
class locales::debian inherits locales::base{
  package {"locales-all":
    ensure => absent,
  }

  package {"locales":
    ensure => present,
    require => Package["locales-all"],
  }

  Exec["locale-gen"] {
    require => Package["locales"],
  }

}
