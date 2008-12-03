class mysql::administration {

# TODO:
# - permissions to edit my.cnf once augeas bug is corrected (see
#   modules/cognac/manifests/classes/mysql-slave.pp)
# - .my.cnf for people in %mysql-admin

  group { "mysql-admin":
    ensure => present,
  }

  $distro_specific_mysql_sudo = $operatingsystem ? {
    Debian => "/etc/init.d/mysql",
    RedHat => "/etc/init.d/mysqld, /sbin/service mysqld"
  }

  common::concatfilepart { "sudoers.mysql":
    ensure => present,
    file => "/etc/sudoers",
    content => "
# This part comes from modules/mysql/manifests/classes/administration.pp
%mysql-admin ALL=(root) ${distro_specific_mysql_sudo}
%mysql-admin ALL=(root) /bin/su mysql, /bin/su - mysql
",
    require => Group["mysql-admin"],
  }

}
