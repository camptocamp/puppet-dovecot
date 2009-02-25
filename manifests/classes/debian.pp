class debian inherits os {
  #
  # Default packages
  #
  package {
    "lsof": ensure => present;
    "cron-apt": ensure => present; # Keeps a fresh apt database
    "tiobench": ensure => present; # Useful for doing IO benchmarks
    "rubygems": ensure => present; # Ruby packaging tool
    "smartmontools": ensure => present; # SMART monitoring
    "at" : ensure => present; # usefull for reboots...
    "emacs21-nox" : ensure => present; # for fredj and sypasche
    "unzip": ensure => present;
    "zip": ensure => present;
    "strace": ensure => present;
    "iproute": ensure => present;
    "mtr-tiny": ensure => present;
    "tcpdump": ensure => present;
    "tshark": ensure => present;
    "curl": ensure => present;
    "screen": ensure => present;
    "vim": ensure => present;
    "lynx": ensure => present;
    "bzip2": ensure => present;
    "make": ensure => present;
    "patch": ensure => present;
    "file": ensure => present;
    "less": ensure => present;
    "rsync": ensure => present;
    "rdiff-backup": ensure => present;
    "subversion": ensure => present;
    "subversion-tools": ensure => present;
    "elinks": ensure => present;
    "psmisc": ensure => present;
    "gcc": ensure => present;
    "libc6-dev": ensure => present;
    "nmap": ensure => present;
    "cadaver": ensure => present;
    "iptraf": ensure => present;
    "tofrodos": ensure => present;
    "bc": ensure => present;
    "whois": ensure => present;
    "ipcalc": ensure => present;
    "cvs": ensure => present;
    "gettext": ensure => present;
    "python-dev": ensure => present;
  }


  #
  # Locales
  #

  package {"locales-all":
    ensure => present,
  }

#  file {"/etc/locale.gen":
#    ensure  => present,
#    source  => "puppet:///os/locale.gen",
#    notify  => Exec["locale-gen"],
#    require => Package["locales"],
#  }

  # BUG: Smells hacky ?
  file {"/usr/share/locale/locale.alias":
    ensure => present,
    source => "puppet:///os/locale.alias",
  }

#  exec {"locale-gen":
#    refreshonly => true,
#    timeout     => 20,
#    require     => [ File["/usr/share/locale/locale.alias"], Package["locales"] ],
#  }

  file {"/etc/profile.d":
    ensure => directory
  }

  # Python environment
  package {
    "python": ensure => present;
    "python-setuptools": ensure => present;
  }

  # SSL Configuration
  package {
    "ca-certificates": ensure => present;
  }

  exec { "apt-get_update":
    command => "apt-get update",
    refreshonly => true,
  }

  # fix 7376
  package { ["openssl", "openssh-server", "openssh-client", "openssh-blacklist", "ssl-cert" ]:
    ensure => latest,
    require => Exec["apt-get_update"]
  }

  exec {"sysctl-reload":
    command     => "sysctl -p",
    refreshonly => true,
  }
}

