class app-c2c-workstation {

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

}
