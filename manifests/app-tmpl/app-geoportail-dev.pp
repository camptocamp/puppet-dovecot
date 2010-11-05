class app-geoportail-dev {
  package {[
    "slapd",
    "libldap2-dev",
    "libsasl2-dev",
    "build-essential",
    ]:
    ensure => present,
  }
}
