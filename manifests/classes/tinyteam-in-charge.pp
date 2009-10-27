class c2c::tinyteam-in-charge {
  ssh-old::account::allowed_user { "jgrandguillaume on admin":
    allowed_user => "jgrandguillaume",
    system_user  => "admin",
  }

  ssh-old::account::allowed_user { "nbessi on admin":
    allowed_user => "nbessi",
    system_user  => "admin",
  }

  ssh-old::account::allowed_user { "lmaurer on admin":
    allowed_user => "lmaurer",
    system_user  => "admin",
  }

  ssh-old::account::allowed_user {"vrenaville on admin":
    allowed_user => "vrenaville",
    system_user => "admin",
  }
}
