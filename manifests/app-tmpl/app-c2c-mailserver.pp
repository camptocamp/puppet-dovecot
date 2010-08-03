class app-c2c-mailserver {
  
  # Mail archiving
  package {"offlineimap":
    ensure => installed,
  }

  file {"/srv/archive":
    ensure => directory,
  }

}
