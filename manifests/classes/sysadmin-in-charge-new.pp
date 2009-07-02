class c2c::sysadmin-in-charge-new {
  c2c::ssh_authorized_key{"mathieu.bornoz@camptocamp.com on root":
    sadb_user => "mbornoz",
    user      => "root",
  }

  c2c::ssh_authorized_key{"marc.fournier@camptocamp.com on root":
    sadb_user => "marc",
    user      => "root",
  }

  c2c::ssh_authorized_key{"francois.deppierraz@camptocamp.com on root":
    sadb_user => "francois",
    user      => "root",
  }

  c2c::ssh_authorized_key{"cedric.jeanneret@camptocamp.com on root":
    sadb_user => "cjeanneret",
    user      => "root",
  }

  c2c::ssh_authorized_key{"jean-baptiste.aubort@camptocamp.com on root":
    sadb_user => "jbaubort",
    user      => "root",
  }

  c2c::ssh_authorized_key{"christian.kaenzig@camptocamp.com on root":
    sadb_user => "ckaenzig",
    user      => "root",
  }

  file {"/root/.bash_logout":
    ensure => present,
    mode   => 600,
    source => "puppet:///c2c/etc/skel/.bash_logout",
  } 
  
  file {"/root/.bash_profile":
    ensure => present,
    mode   => 600,
    source => "puppet:///c2c/etc/skel/.bash_profile",
  }

  file {"/root/.bashrc":
    ensure => present,
    mode   => 600,
    source => "puppet:///c2c/etc/skel/.bashrc",
  }
  
  file {"/root/.screenrc":
    ensure => present,
    mode   => 600,
    source => "puppet:///c2c/etc/skel/.screenrc",
  }
}
