#
# This class contains all packages necessary for developping Java applications
#

class java::dev {
  package {"maven2":
    ensure  => present,
    require => Package["sun-java6-jdk"],
  }

  package {"ant":
    ensure => present,
  }
}
