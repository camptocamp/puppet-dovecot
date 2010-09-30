class app-c2c-workstation-formation-sig {

  # WARN: puppet modules mapserver/tilecache/mapfish/cartoweb3 need to be 
  # re-design. Until then, only the ubuntu-upstream-packages included 
  # in these modules are installed and apache modules enabled

  apache::module{[
    "proxy",
    "proxy_http",
    "proxy_ajp",
    "expires",
    "headers"]
    : ensure => present,}

  apache::module {"python":
    ensure  => present,
    require => Package["libapache2-mod-python"],
  }

  # puppet-mapserver packages
  # !!! missing: libecw
  package{[
    "cgi-mapserver",
    "perl-mapscript",
    "mapserver-bin",
    "php5-mapscript",
    "python-mapscript",
    "mapserver-doc",
    "python-gdal",
    "proj",
    "libapache2-mod-fcgid"]
    : ensure => present}

    # puppet-tilecache packages
    package{[
      "tilecache", # perhaps it's better to use c2c version ?
      "python-imaging",
      "libapache2-mod-python",
      "jpegoptim",
      "jpeginfo",
      "optipng",
      "pngcheck",
      "pngnq"]
      : ensure => present}

    # puppet-mapfish packages
    package {[
      "libapache2-mod-wsgi",
      "python-virtualenv",
      "naturaldocs"]
    : ensure => present}

    # puppet-cartoweb3 packages
    package {[
    "php5-common",
    "php5-cli",
    "php5-gd",
    "libapache2-mod-php5",
    "php5-pgsql",
    "php5-curl",
    "php5-sqlite",
    "php5-mysql",
    "make"]
    : ensure => present}

}
