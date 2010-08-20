#
# Install the SSH public key available in SADB for username $sadb_user into $user
# account
#
define c2c::ssh_authorized_key($ensure = present, $sadb_user, $user = false, $target = false) {
  $type = url_get("${sadb}/user/${sadb_user}/ssh_pub_key_type")
  $key = url_get("${sadb}/user/${sadb_user}/ssh_pub_key")

  if ($user == false) and ($target == false) {
    fail("Must pass either user or target c2c::ss_authorized_key")
  }

  case $type {
    "none": {
      ssh_authorized_key{$name:
        ensure => absent,
        target => $target? {false => undef, default => $target },
        user   => $target? {false => $user, default => undef },
      }
    }
    default: {
      ssh_authorized_key{$name:
        ensure => $ensure,
        target => $target? {false => undef, default => $target },
        user   => $target? {false => $user, default => undef },
        type   => $type,
        key    => $key,
      }
    }
  }

}
