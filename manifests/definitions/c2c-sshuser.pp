define c2c::sshuser ($ensure=present, $uid, $comment, $email, $type, $key, $groups=false) {
  user {$name:
    ensure     => $ensure,
    comment    => $comment,
    managehome => true,
    uid        => $uid,
    shell      => "/bin/bash",
    groups     => $groups ? {false => undef, default => $groups},
    require    => Class["c2c::skel"],
  }

  ssh_authorized_key {"$email on $name":
    ensure  => $ensure,
    user    => $name,
    type    => $type,
    key     => $key,
    require => User[$name],
  }
}
