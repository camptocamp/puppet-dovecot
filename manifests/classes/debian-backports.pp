class os::debian::backports {

  file {"/etc/apt/sources.list.d/backports.list":
    ensure  => present,
    content => $lsbdistcodename ? {
      "gutsy" => "deb http://archive.ubuntu.com/ubuntu gutsy-backports main universe multiverse restricted\n",
      "hardy" => "deb http://archive.ubuntu.com/ubuntu hardy-backports main universe multiverse restricted\n",
      "etch"  => "deb http://www.backports.org/debian etch-backports main contrib non-free\n",
      "lenny" => "deb http://www.backports.org/debian lenny-backports main contrib non-free\n",
    },
    before  => Exec["apt-get_update"],
    notify  => Exec["apt-get_update"],
  }

  common::concatfilepart {"${lsbdistcodename}-backports":
    ensure  => present,
    content => "Package: *\nPin: release a=${lsbdistcodename}-backports\nPin-Priority: 400\n\n",
    file    => "/etc/apt/preferences",
  }

  case $lsbdistid {
    "Debian" : {
      os::apt_key_add { "backports-key for $lsbdistid":
        source  => "http://backports.org/debian/archive.key",
        keyid   => "16BA136C",
        before  => Exec["apt-get_update"],
      }
    }
  } 

}
