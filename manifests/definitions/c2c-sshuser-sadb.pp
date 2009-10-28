define c2c::sshuser::sadb ($ensure=present, $groups = "", $target = false) {

  $firstname = url_get("${sadb}/user/${name}/firstname")
  $lastname  = url_get("${sadb}/user/${name}/lastname")

  user {$name:
    ensure     => $ensure,
    comment    => "${firstname} ${lastname}",
    uid        => url_get("${sadb}/user/${name}/uid_number"),
    managehome => true,
    shell      => "/bin/bash",
    groups     => $groups,
    require    => Class["c2c::skel"],
  }

  ssh_authorized_key {"$name on $name":
    ensure  => $ensure,
    target  => $target? {false => undef, default => $target },
    user    => $target? {false => $name, default => undef },
    type    => url_get("${sadb}/user/${name}/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/${name}/ssh_pub_key"),
    require => User[$name],
  }

}
