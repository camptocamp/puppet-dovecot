class geste::search {
  # packages for xapian
  package {[
    "python-xappy",
    "python-xapian",
    "xapian-tools",
    "xapian-omega",
    ]:
    ensure => present,
  }

  # packages for pylons
  package {[
    "python-pylons",
    "python-mako",
    "python-chardet",
    "python-dns",
    ]: ensure => present,
  }
}
