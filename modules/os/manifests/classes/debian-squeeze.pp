class os::debian-squeeze {
  file { "/etc/apt/sources.list":
    ensure => absent,
    before => Exec["apt-get_update"],
  }

  apt::sources_list{"$lsbdistcodename":
    content => "# File managed by puppet - ${name}
deb http://mirror.switch.ch/ftp/mirror/debian/ ${lsbdistcodename} main contrib non-free
deb http://mirror.switch.ch/ftp/mirror/debian-security/ ${lsbdistcodename}/updates main contrib non-free

deb-src http://mirror.switch.ch/ftp/mirror/debian/ ${lsbdistcodename} main contrib non-free
deb-src http://mirror.switch.ch/ftp/mirror/debian-security/ ${lsbdistcodename}/updates main contrib non-free
",
  }


  apt::sources_list{"c2c":
     content => "# File managed by puppet - ${name}
deb http://dev.camptocamp.com/packages ${lsbdistcodename} puppet sysadmin
deb-src http://dev.camptocamp.com/packages ${lsbdistcodename} puppet sysadmin
",
  }

  apt::key {"5C662D02":
    source  => "http://dev.camptocamp.com/packages/pub.key",
  }

  apt::preferences { "c2c-mirror":
    ensure => present,
    package => "*",
    pin => "release o=c2c",
    priority => "1001",
  }

  include locales::sources
  locales::locale {
    "de_DE.ISO-8859-1": charset => "ISO-8859-1";
    "de_DE.UTF-8":      charset => "UTF-8";
    "en_GB.ISO-8859-1": charset => "ISO-8859-1";
    "en_GB.UTF-8":      charset => "UTF-8";
    "en_US.ISO-8859-1": charset => "ISO-8859-1";
    "en_US.UTF-8":      charset => "UTF-8";
    "fr_CH.ISO-8859-1": charset => "ISO-8859-1";
    "fr_CH.UTF-8":      charset => "UTF-8";
    "fr_FR.ISO-8859-1": charset => "ISO-8859-1";
    "fr_FR.UTF-8":      charset => "UTF-8";
    "it_IT.ISO-8859-1": charset => "ISO-8859-1";
    "it_IT.UTF-8":      charset => "UTF-8";
  }

  locales::alias {
    "de": locale => "de_DE.ISO-8859-1";
    "en": locale => "en_US.ISO-8859-1";
    "fr": locale => "fr_FR.ISO-8859-1";
    "it": locale => "it_IT.ISO-8859-1";
  }

  # general config for emacs (without temporary files ~ )
  file { "/etc/emacs/site-start.d/50c2c.el":
    ensure  => present,
    mode    => 644,
    source  => "puppet:///os/etc/emacs/site-start.d/50c2c.el",
    require => Package["emacs23-nox"]
  }

  # Umask, etc.
  file { "/etc/profile":
    ensure => present,
    mode   => 644,
    source => "puppet:///os/etc/profile-lenny",
  }

  file {"/etc/environment":
    ensure => present,
    content => '# File managed by puppet
LANG="en_US.UTF-8"
LC_NUMERIC="fr_CH.UTF-8"
',
    mode    => 0644,
    owner   => root,
    group   => root,
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

  file {"/etc/adduser.conf":
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => template("os/etc/adduser.conf.erb"),
  }

  package {
    "bash-completion":  ensure => present;
    "iotop":            ensure => present;
    "lsof":             ensure => present;
    "tiobench":         ensure => present; # Useful for doing IO benchmarks
    "smartmontools":    ensure => present; # SMART monitoring
    "at" :              ensure => present; # usefull for reboots...
    "emacs23-nox" :     ensure => present; # for fredj (this comes from backports on Lenny)
    "unzip":            ensure => present;
    "zip":              ensure => present;
    "strace":           ensure => present;
    "iproute":          ensure => present;
    "mtr-tiny":         ensure => present;
    "tcpdump":          ensure => present;
    "tshark":           ensure => present;
    "curl":             ensure => present;
    "screen":           ensure => present;
    "vim":              ensure => present;
    "lynx":             ensure => present;
    "bzip2":            ensure => present;
    "patch":            ensure => present;
    "file":             ensure => present;
    "less":             ensure => present;
    "rsync":            ensure => present;
    "rdiff-backup":     ensure => present;
    "elinks":           ensure => present;
    "psmisc":           ensure => present;
    "nmap":             ensure => present;
    "cadaver":          ensure => present;
    "iptraf":           ensure => present;
    "tofrodos":         ensure => present;
    "bc":               ensure => present;
    "whois":            ensure => present;
    "ipcalc":           ensure => present;
    "cvs":              ensure => present;
    "gettext":          ensure => present;
    "ngrep":            ensure => present;
    "pwgen":            ensure => present;
    "xfsprogs":         ensure => present;

    "emacs21-common" :  ensure => absent;
    "locate":           ensure => absent;
    "cron-apt":         ensure => purged; # Keeps a fresh apt database
  }

}
