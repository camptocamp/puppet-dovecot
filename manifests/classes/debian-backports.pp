class os::debian::backports {

  apt::sources_list{"backports":
    ensure  => present,
    content => $lsbdistcodename ? {
      "gutsy" => "deb http://archive.ubuntu.com/ubuntu gutsy-backports main universe multiverse restricted\n",
      "hardy" => "deb http://archive.ubuntu.com/ubuntu hardy-backports main universe multiverse restricted\n",
      "etch"  => "deb http://www.backports.org/debian etch-backports main contrib non-free\n",
      "lenny" => "deb http://www.backports.org/debian lenny-backports main contrib non-free\n",
    },
  }

  common::concatfilepart {"${lsbdistcodename}-backports":
    ensure  => present,
    content => "Package: *\nPin: release a=${lsbdistcodename}-backports\nPin-Priority: 400\n\n",
    file    => "/etc/apt/preferences",
  }

  case $lsbdistid {
    "Debian" : {
      apt::key {"16BA136C":
        ensure => present,
        source  => "http://backports.org/debian/archive.key",
      }
    }
  }
}
