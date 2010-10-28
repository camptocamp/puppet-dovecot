class openldap::base {
  service {"slapd":
    ensure  => running,
    enable  => true,
    require => Package["slapd"],
  }
}
