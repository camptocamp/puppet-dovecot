# Class for specifics for srv-c2c-puppetmaster
#
# Requires: 
# Provides: 
# Conflicts: 
#

class app-c2c-puppetmaster {

  include puppet::master::passenger
  include mysql::server

  package{"git-email":
    ensure => present;
  }

  c2c::sshuser::sadb {["ckaenzig", "marc", "mbornoz", "cjeanneret", "jbaubort", "mremy"]:
    groups  => "sysadmin",
  }

  common::concatfilepart {"sudoers.sysadmin":
    ensure => present,
    file => "/etc/sudoers",
    content => "## This part is managed by puppet
%sysadmin ALL=(ALL) ALL
##\n",
  }

}
