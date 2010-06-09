class os::debian::backports {

  apt::sources_list{"backports":
    ensure  => present,
    content => $lsbdistcodename ? {
      "hardy" => "deb http://archive.ubuntu.com/ubuntu hardy-backports main universe multiverse restricted\n",
      "intrepid" => "deb http://archive.ubuntu.com/ubuntu intrepid-backports main universe multiverse restricted\n",
      "jaunty" => "deb http://archive.ubuntu.com/ubuntu jaunty-backports main universe multiverse restricted\n",
      "lucid" => "deb http://archive.ubuntu.com/ubuntu lucid-backports main universe multiverse restricted\n",
      "etch"  => "deb http://www.backports.org/debian etch-backports main contrib non-free\n",
      "lenny" => "deb http://www.backports.org/debian lenny-backports main contrib non-free\n",
    },
  }

  apt::preferences {"${lsbdistcodename}-backports":
    ensure => present,
    package => "*",
    pin => "release a=${lsbdistcodename}-backports",
    priority => 400,
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
