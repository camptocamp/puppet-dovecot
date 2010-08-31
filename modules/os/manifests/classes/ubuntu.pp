class ubuntu {
  # fix 7376
  package { ["openssl", "openssh-server", "openssh-client", "openssh-blacklist", "ssl-cert" ]:
    ensure => latest,
    require => Exec["apt-get_update"]
  }

  # Default packages
  package {
    "cron": ensure => present;
    "nano": ensure => present;
    "pwgen": ensure => present;
    "vim": ensure => present;
    "curl": ensure => present;
    "nmap": ensure => present;
    "tshark": ensure => present;
    "iptraf": ensure => present;
    "mtr-tiny": ensure => present;
    "ipcalc": ensure => present;
    "ipython": ensure => present;
    "cvs": ensure => present;
    "smartmontools": ensure => present;
    "bzip2": ensure => present;
    "cadaver": ensure => present;
    "tofrodos": ensure => present;
    "lynx": ensure => present;
    "lsof": ensure => present;
    "locales": ensure => present;
  }
  
  file {"/etc/profile.d":
    ensure => directory
  }

  # Disable PC Speaker
  line {"disable pc speaker":
    line   => 'blacklist pcspkr',
    file   => '/etc/modprobe.d/blacklist.conf',
    ensure => present,
  }

  # Do not propose system upgrade
  line {
    "default release-upgrade prompt configuration removed":
      line   => 'prompt=normal',
      file   => '/etc/update-manager/release-upgrades',
      ensure => absent;
    "release-upgrade prompt configuration to none":
      line   => 'prompt=never',
      file   => '/etc/update-manager/release-upgrades',
      require=> File["/etc/update-manager/"],
      ensure => present;
  }

  file {"/etc/update-manager/":
      ensure => directory,
  }

  #Jaunty: group scanner is not needed anymore cf. bug #195782 in LP
  group {"scanner":
    ensure => present,
  }
  
  # Profile
  file {"/etc/profile":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 644,
    source => "puppet:///os/etc/profile-ubuntu",
  }

  # Sources list 
  apt::sources_list {"ubuntu.sources":
    content => template("os/ubuntu.list.erb"),
  }

  apt::sources_list {"c2c.sources":
    content => template("os/c2c.list.erb"),
  }

  apt::key {"5C662D02":
    source  => "http://dev.camptocamp.com/packages/pub.key",
 }

  # Timezone
  file { "/etc/localtime":
    ensure => present,
    source => "file:///usr/share/zoneinfo/Europe/Zurich",
  }
  file { "/etc/timezone":
    ensure  => present,
    content => "Europe/Zurich",
  }

  # Kernel
  file { "/etc/modules":
    ensure => present,
  }
}

