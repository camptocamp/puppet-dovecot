class trac {
  package {
    "trac": ensure => present;
    "sqlite3": ensure => present;
    "sqlite": ensure => present;
    "enscript": ensure => present;
  }


  file {"/srv/trac":
    ensure => directory,
  }

  file {"/srv/trac/projects":
    ensure  => directory,
    require => File["/srv/trac"],
  }
}
