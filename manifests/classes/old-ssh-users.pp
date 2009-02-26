class c2c::old-ssh-users {
  file {"/etc/ssh/authorized_keys/vtrottmann":
    ensure  => absent,
    force   => true,
  }
  file {"/etc/ssh/authorized_keys/ltreyvaud":
    ensure  => absent,
    force   => true,
  }
  file {"/etc/ssh/authorized_keys/mleserre":
    ensure  => absent,
    force   => true,
  }
  file {"/etc/ssh/authorized_keys/jdgiguere":
    ensure  => absent,
    force   => true,
  }
  file {"/etc/ssh/authorized_keys/bphilippot":
    ensure  => absent,
    force   => true,
  }
  file {"/etc/ssh/authorized_keys/ikiener":
    ensure  => absent,
    force   => true,
  }
  file {"/etc/ssh/authorized_keys/sypasche":
    ensure  => absent,
    force   => true,
  }
  file {"/etc/ssh/authorized_keys/mbaroudi":
    ensure  => absent,
    force   => true,
  }
  file {"/etc/ssh/authorized_keys/gnguessan":
    ensure  => absent,
    force   => true,
  }
  file {"/etc/ssh/authorized_keys/ojohner":
    ensure  => absent,
    force   => true,
  }
  file {"/etc/ssh/authorized_keys/awuest":
    ensure  => absent,
    force   => true,
  }
}
