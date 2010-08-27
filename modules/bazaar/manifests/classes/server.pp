class bazaar::server inherits bazaar::client {
  file {"/srv/bzr":
    ensure => directory,
  }
}
