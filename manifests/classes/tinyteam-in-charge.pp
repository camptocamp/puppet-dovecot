class c2c::tinyteam-in-charge {
  ssh::account::allowed_user { "jgrandguillaume on admin":
    allowed_user => "jgrandguillaume",
    system_user  => "admin",
  }

  ssh::account::allowed_user { "nbessi on admin":
    allowed_user => "nbessi",
    system_user  => "admin",
  }

  ssh::account::allowed_user { "lmaurer on admin":
    allowed_user => "lmaurer",
    system_user  => "admin",
  }

  ssh::account::allowed_user {"vrenaville on admin":
    allowed_user => "vrenaville",
    system_user => "admin",
  }

  ssh::account::allowed_user { "jbaubort on admin":
    allowed_user => "jbaubort",
    system_user  => "admin",
    ensure => "absent",
  }
}
