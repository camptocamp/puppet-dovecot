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

  # packages for omega filters
  package {[
      "antiword",
      "xpdf-utils",
      "catdoc",
    ]: ensure => latest,
  }

  file {[
    "/srv/xapian/administration",
    "/srv/xapian/engineering",
    "/srv/xapian/public",
    ]:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0755,
    require => Mount["/srv/xapian"],
  }

}
