class buildenv::c {

  package {
    ["make", "gcc", "cpp", "autoconf",
     "automake", "m4", "bison", "libtool"]:
    ensure => present,
  }

  package { "libc-dev":
    ensure => present,
    name   => $operatingsystem ? {
      /Debian|Ubuntu/ => "libc6-dev",
      /RedHat|CentOS/ => "glibc-devel",
    },
  }

}
