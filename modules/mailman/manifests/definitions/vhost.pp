define mailman::vhost ($ensure) {
  file {"/var/www/$name/conf/mailman.conf":
    ensure  => $ensure,
    content => template("mailman/mailman-vhost.erb"),
    notify  => Service["apache2"],
  }
}
