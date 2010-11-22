define trac::default ($vhost) {
  file {"/var/www/${vhost}/conf/trac-default-slash.conf":
    ensure  => present,
    content => "RedirectMatch ^/$ /trac/${name}\n",
    notify  => Service["apache2"],
  }
}
