#
# Install N SSH public key available in SADB into $user account
#
define c2c::shared::ssh_authorized_key($ensure=present, $user) {
  ssh_authorized_key {"$name on $user":
    ensure => $ensure,
    user   => $user,
    type   => url_get("${sadb}/user/${name}/ssh_pub_key_type"),
    key    => url_get("${sadb}/user/${name}/ssh_pub_key"),
  }
}
