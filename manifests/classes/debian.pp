class os::debian {
  #
  # Default packages
  #
  package {
    "lsof": ensure => present;
    "cron-apt": ensure => purged; # Keeps a fresh apt database
    "tiobench": ensure => present; # Useful for doing IO benchmarks
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
    "patch": ensure => present;
    "file": ensure => present;
    "less": ensure => present;
    "rsync": ensure => present;
    "rdiff-backup": ensure => present;
    "subversion": ensure => present;
    "subversion-tools": ensure => present;
    "elinks": ensure => present;
    "psmisc": ensure => present;
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
    "ngrep": ensure => present;
    "ipython": ensure => present;
    "python-mode": ensure => present;
    "pwgen": ensure => present;
    "locate": ensure => absent;
    "iotop": ensure => present;
    "xfsprogs": ensure => present;
  }
  
  # Disable PC Speaker
  line {"disable pc speaker":
    line   => 'blacklist pcspkr',
    file   => '/etc/modprobe.d/blacklist',
    ensure => present,
  }

  #
  # Locales
  #

  package {"locales-all":
    ensure => absent,
  }

  package {"locales":
    ensure => present,
    require => File["/etc/locale.gen"],
    notify => Exec["locale-gen"],
  }

  file {"/etc/locale.gen":
    ensure  => present,
    source  => "puppet:///os/locale.gen",
    notify => Exec["locale-gen"],
  }
  exec {"locale-gen":
    refreshonly => true,
    command => "locale-gen",
    timeout => 20,
    require => [Package["locales"], File["/etc/locale.gen"]],
  }


  # BUG: Smells hacky ?
  file {"/usr/share/locale/locale.alias":
    ensure => present,
    source => "puppet:///os/locale.alias",
  }

  # $LANG
  file { "/etc/environment":
    ensure => present,
    mode   => 644,
    source => "puppet:///os/etc/environment",
  }

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

  # fix 7376
  package { ["openssl", "openssh-server", "openssh-client", "openssh-blacklist", "ssl-cert" ]:
    ensure => latest,
    require => Exec["apt-get_update"]
  }

  exec {"sysctl-reload":
    command     => "sysctl -p",
    refreshonly => true,
  }

  # remove a bad file create by apt::sources_list{"2c" !
  file {"/etc/apt/sources.list.d/2c.list":
    ensure => absent,
  }
<<<<<<< HEAD:manifests/classes/debian.pp
=======

  file {"/etc/adduser.conf":
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => template("os/etc/adduser.conf.erb"),
  }

}
>>>>>>> 65d2ac40a3fdc92a93e57e5812f3877aaec1789a:manifests/classes/debian.pp

  file {"/etc/adduser.conf":
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => template("os/etc/adduser.conf.erb"),
  }

  # fix 14573
  package {"debian-archive-keyring":
    ensure => latest,
  }

  # fixes rt#14979
  cron {"Keeps a fresh apt database":
    command  => "/usr/bin/apt-get update -q=2",
    ensure   => present,
    hour     => 4,
    minute   => ip_to_cron(1),
  }
}
