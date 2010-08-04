class app-c2c-mailserver {
  
  # Mail archiving

  package {"offlineimap":
    ensure => installed,
  }

  user {"archive":
    ensure => present,
    managehome => true,
  }
  c2c::ssh_authorized_key {"ckaenzig on archive":   ensure => present, sadb_user => ckaenzig, user => archive, }
  c2c::ssh_authorized_key {"mbornoz on archive":    ensure => present, sadb_user => mbornoz, user => archive, }
  c2c::ssh_authorized_key {"cjeanneret on archive": ensure => present, sadb_user => cjeanneret, user => archive, }
  c2c::ssh_authorized_key {"marc on archive":       ensure => present, sadb_user => marc, user => archive, }
  c2c::ssh_authorized_key {"mremy on archive":      ensure => present, sadb_user => mremy, user => archive, }
    
  file {"/srv/archive":
    ensure => directory,
    owner  => "archive",
  }

}
