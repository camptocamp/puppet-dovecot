class buildenv::rpm {

  package { "rpm-build":
    ensure => present,
  }

}
