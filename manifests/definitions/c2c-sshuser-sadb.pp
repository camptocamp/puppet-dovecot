define c2c::sshuser::sadb ($ensure=present, $groups=false) {

  $firstname = url_get("${sadb}/user/${name}/firstname")
  $lastname  = url_get("${sadb}/user/${name}/lastname")

  user {$name:
    ensure     => $ensure,
    comment    => "${firstname} ${lastname}",
    uid        => url_get("${sadb}/user/${name}/uid_number"),
    managehome => true,
    shell      => "/bin/bash",
    require    => Class["c2c::skel"],
  }

  if $groups != false {
    User[$name] {
      groups => $groups,
    }
  }

  ssh_authorized_key {"$name on $name":
    ensure  => $ensure,
    user    => $name,
    type    => url_get("${sadb}/user/${name}/ssh_pub_key_type"),
    key     => url_get("${sadb}/user/${name}/ssh_pub_key"),
    require => User[$name],
  }

}
