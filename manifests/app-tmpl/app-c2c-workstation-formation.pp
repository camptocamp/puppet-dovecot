class app-c2c-workstation-formation {

  # default root account
  user {"root":
    ensure   => present,
    password => '$1$8a.Bg78Q$VP3nFU5O41o5ATGg10Weq.',
    shell    => "/bin/bash"
  }

  # customized default ubuntu wallpaper
  if $lsbdistcodename == "lucid" {
    file {"/usr/share/backgrounds/warty-final-ubuntu.png":
      ensure   => present,
      source   => "puppet:///c2c/usr/share/backgrounds/warty-final-ubuntu-lucid.png",
    }
  }

  group {"admin":
    ensure => present,
  }

  # account with grant privileges (sudo su) 
  user {"c2c":
    ensure => present,
    managehome => true,
    shell => "/bin/bash",
    password => '$1$bK8g/LEX$Z.dKsTLgqXRI95a7GVuiR0',
    require => Group["admin"],
    groups => [
      "adm",
      "admin",
      "dialout",
      "cdrom",
      "floppy",
      "sudo",
      "audio",
      "dip",
      "video",
      "plugdev",
      "scanner",
      "lpadmin",
      "netdev",
    ],
  }

  # account for guest without root privileges
  user {"guest":
    ensure => present,
    managehome => true,
    shell => "/bin/bash",
    password => '$1$59VjXJtG$O.RcAlT5qaIOUq01Bqd5R.',
    groups => [
      "adm",
      "dialout",
      "cdrom",
      "floppy",
      "sudo",
      "audio",
      "dip",
      "video",
      "plugdev",
      "scanner",
      "lpadmin",
      "netdev"
    ],
  }
 
  apache::vhost {"localhost":
    ensure => present,
    group  => "admin",
    mode   => "2775",
  } 
 
  tomcat::instance {"tomcat1":
    ensure => present,
    group  => "admin",
    sample => true,
  }

  common::concatfilepart { "000-sudoers.init":
    ensure => present,
    file => "/etc/sudoers",
    content => "
## This part is managed by puppet
Defaults    env_keep=SSH_AUTH_SOCK
Defaults    !authenticate
Defaults    env_reset
Defaults    always_set_home
root  ALL=(ALL) ALL
%sudo ALL=(ALL) ALL
##

",
  }

}
