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

  # public ssh-key used by backuppc
  ssh_authorized_key {"backuppc pubkey":
    ensure  => present,
    type    => "ssh-rsa",
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEAx312hsQ0ODFQlreB0WqdPF88XK6EOiDlqk92Emy/DGMcGqGsUxef9WW3CQOxx4qaPuf8da31IEJOEGvNT9fQhzABp5w579Ujzden3U+0dF4hGopioRwG0y2OgfE0QeOJAnrdQCeT0Ek/lkc7PcKdShmCxvAcVqGBTVixto26vJXdGmTPlZEfy09Lozpx874hDLg8zIYn8vjhrNrhjkxqyeVCFHfYxag+o3dgC1cphFDIbeb0D83OCnQYfz2mVAgmynypGd/o+T1B63NZGTaDrFMptWCrPEm3XO8H715Yr2mZbl5gxjIYrAGav0S6fY7SHClFzKagfY45RIDh+usZOw==",
    user    => root,
    options => [
      "from=\"10.27.20.51,10.26.21.8,10.28.21.3\"",
      "no-pty",
      "no-port-forwarding",
      "no-X11-forwarding",
    ],
  }
  
}
