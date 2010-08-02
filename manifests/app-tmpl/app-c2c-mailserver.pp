class app-c2c-mailserver {
  
  # Mail archiving
  package {"mpop":
    ensure => installed,
  }

  file {"/srv/archive":
    ensure => directory,
  }

}
