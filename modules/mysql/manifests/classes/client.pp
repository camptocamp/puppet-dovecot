#
# Class mysql::client
#
# Installs mysql client utilities such as mysqldump, mysqladmin, the "mysql"
# interactive shell, etc.
#
class mysql::client {

  package { "mysql-client":
    ensure => present,
    name   => $operatingsystem ? {
      Debian => "mysql-client",
      RedHat => "mysql",
    },
  }
}
