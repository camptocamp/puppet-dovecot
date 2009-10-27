#
# Install the SSH public key available in SADB for username $sadb_user into $user
# account
#
define c2c::ssh_authorized_key_legacy($ensure = present, $sadb_user, $user) {

  if defined (Exec["creating base key directory for ${user}"]) {
    notice "creating base key directory for ${user}  already defined"
  } else {
    exec { "creating base key directory for ${user}":
      command => "mkdir -p /etc/ssh/authorized_keys/${user}",
      unless  => "test -d /etc/ssh/authorized_keys/${user}",
    }
  }

  ssh_authorized_key {$name:
    ensure => $ensure,
    type   => url_get("${sadb}/user/${sadb_user}/ssh_pub_key_type"),
    key    => url_get("${sadb}/user/${sadb_user}/ssh_pub_key"),
    target => "/etc/ssh/authorized_keys/${user}/keys",
    require => Exec["creating base key directory for ${user}"],
  }
}
