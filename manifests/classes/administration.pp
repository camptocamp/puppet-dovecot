#
# == Class: postgresql::administration
#
# This class will create a "postgresql-admin" group and add a couple of rules
# to /etc/sudoers allowing members of this group to administer postgresql
# databases.
#
# Requires:
# - common::concatfilepart
#
class postgresql::administration {

  group { "postgresql-admin":
    ensure => present,
  }

  common::concatfilepart { "sudoers.postgresql":
    ensure => present,
    file => "/etc/sudoers",
    content => template("postgresql/sudoers.postgresql.erb"),
    require => Group["postgresql-admin"],
  }

}
