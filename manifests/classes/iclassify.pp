class puppet::iclassify {
  package {"libsqlite3-ruby":
    ensure => installed,
  }

  package {"uuidtools":
    provider => gem,
    ensure   => installed,
    require  => Package["rubygems"],
  }

  package {"builder":
    provider => gem,
    ensure   => installed,
    require  => Package["rubygems"],
  }

  package {"rails":
    provider => gem,
    ensure   => installed,
    require  => Package["rubygems"],
  }

  package {"ruby-net-ldap":
    provider => gem,
    ensure   => installed,
    require  => Package["rubygems"],
  }

  package {"highline":
    provider => gem,
    ensure   => installed,
    require  => Package["rubygems"],
  }
}
