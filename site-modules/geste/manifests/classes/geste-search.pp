class geste::search {
  package {[
    "python-xappy",
    "python-xapian",
    "xapian-tools",
    "xapian-omega",
    ]:
    ensure => present,
  }
}
