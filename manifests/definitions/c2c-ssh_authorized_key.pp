#
# Install the SSH public key available in SADB for username $sadb_user into $user
# account
#
define c2c::ssh_authorized_key($ensure = present, $sadb_user, $user) {
  $type = url_get("${sadb}/user/${sadb_user}/ssh_pub_key_type")
  $key = url_get("${sadb}/user/${sadb_user}/ssh_pub_key")

  case $type {
    "none": {
      ssh_authorized_key{$name:
        ensure => absent,
        user   => $user,
      }
    }
    default: {
      ssh_authorized_key{$name:
        ensure => $ensure,
        user   => $user,
        type   => $type,
        key    => $key,
      }
    }
  }

}
