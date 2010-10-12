class c2c::sysadmin-in-charge {

  ssh-old::account::allowed_user { "admin-keys on root":
    allowed_user => "admin-keys",
    system_user  => "root",
  }

  ssh-old::account::allowed_user { "mbornoz on root":
    allowed_user => "mbornoz",
    system_user  => "root",
  }

  ssh-old::account::allowed_user { "mremy on root":
    allowed_user => "mremy",
    system_user  => "root",
  }

  ssh-old::account::allowed_user { "marc on root":
    allowed_user => "marc",
    system_user  => "root",
  }

  ssh-old::account::allowed_user { "cjeanneret on root":
    allowed_user => "cjeanneret",
    system_user  => "root",
  }

  ssh-old::account::allowed_user { "ckaenzig on root":
    allowed_user => "ckaenzig",
    system_user  => "root",
  }

  ssh-old::account::allowed_user { "jbove on root":
    allowed_user => "jbove",
    system_user  => "root",
  }

  ssh-old::account::allowed_user { "francois on root":
    allowed_user => "francois",
    system_user  => "root",
    ensure => absent,
  }

  #
  # If an admin user is present on the system, let's install sysadmins there as well
  #

  if defined(User["admin"]) {
    ssh-old::account::allowed_user { "mbornoz on admin":
      allowed_user => "mbornoz",
      system_user  => "admin",
    }
  
    ssh-old::account::allowed_user { "mremy on admin":
      allowed_user => "mremy",
      system_user  => "admin",
    }
  
    ssh-old::account::allowed_user { "marc on admin":
      allowed_user => "marc",
      system_user  => "admin",
    }
  
    ssh-old::account::allowed_user { "cjeanneret on admin":
      allowed_user => "cjeanneret",
      system_user  => "admin",
    }
  
    ssh-old::account::allowed_user { "ckaenzig on admin":
      allowed_user => "ckaenzig",
      system_user  => "admin",
    }

    ssh-old::account::allowed_user { "francois on admin":
      allowed_user => "francois",
      system_user  => "admin",
      ensure => absent,
    }

    ssh-old::account::allowed_user { "jbove on admin":
      allowed_new  => "jbove",
      system_user  => "admin",
    }
  }
}
