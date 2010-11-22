define trac::vhost-ssl($ensure, $group="www-data", $mode=2770, $aliases = []) {

  apache::vhost-ssl {$name:
    ensure  => $ensure,
    aliases => $aliases,
    group   => $group,
    mode    => $mode,
  }

  file {"/var/www/$name/conf/trac.conf":
    ensure  => present,
    content => template("trac/trac-vhost.erb"),
    notify  => Service["apache2"],
  }

}
