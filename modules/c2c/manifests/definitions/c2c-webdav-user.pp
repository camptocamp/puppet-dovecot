define c2c::webdav::user ($ensure=present, $password, $vhost) {
  apache::auth::htpasswd {"${name}:${password}":
    ensure => $ensure,
    vhost => $vhost,
    username => $name,
    cryptPassword => $password,
  }
}
