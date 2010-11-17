class app-geoportail-dev-demo {
  package {[
    "slapd",
    "libldap2-dev",
    "libsasl2-dev",
    "build-essential",
    ]:
    ensure => present,
  }
}
