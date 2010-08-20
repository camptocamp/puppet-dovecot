define c2c::sshuser::sadb ($ensure=present, $groups = "", $target = false) {

  $firstname = url_get("${sadb}/user/${name}/firstname")
  $lastname  = url_get("${sadb}/user/${name}/lastname")
  $email     = url_get("${sadb}/user/${name}/email")

  user {$name:
    ensure     => $ensure,
    comment    => "${firstname} ${lastname}",
    uid        => url_get("${sadb}/user/${name}/uid_number"),
    managehome => true,
    shell      => "/bin/bash",
    groups     => $groups,
    require    => Class["c2c::skel"],
  }

  c2c::ssh_authorized_key {"$email on $name":
    ensure  => $ensure,
    target  => $target? {false => undef, default => $target },
    user    => $target? {false => $name, default => undef },
    sadb_user => $name,
    require => User[$name],
  }

}
