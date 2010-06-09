class app-c2c-workstation {

  # default root account
  user {"root":
    ensure   => present,
    password => '$1$8a.Bg78Q$VP3nFU5O41o5ATGg10Weq.',
    shell    => "/bin/bash"
  }

}
