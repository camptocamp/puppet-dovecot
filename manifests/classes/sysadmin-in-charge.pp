class c2c::sysadmin-in-charge {

  ssh::account::allowed_user { "admin-keys on root":
    allowed_user => "admin-keys",
    system_user  => "root",
  }

  ssh::account::allowed_user { "mbornoz on root":
    allowed_user => "mbornoz",
    system_user  => "root",
  }

  ssh::account::allowed_user { "francois on root":
    allowed_user => "francois",
    system_user  => "root",
  }

  ssh::account::allowed_user { "marc on root":
    allowed_user => "marc",
    system_user  => "root",
  }

  ssh::account::allowed_user { "cjeanneret on root":
    allowed_user => "cjeanneret",
    system_user  => "root",
  }

  ssh::account::allowed_user { "jbaubort on root":
    allowed_user => "jbaubort",
    system_user  => "root",
  }
}
