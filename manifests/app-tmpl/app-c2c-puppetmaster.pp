# Class for specifics for srv-c2c-puppetmaster
#
# Requires: 
# Provides: 
# Conflicts: 
#

class app-c2c-puppetmaster {

  include puppet::master::passenger
  include mysql::server

  c2c::sshuser::sadb {["ckaenzig", "marc", "mbornoz", "cjeanneret", "jbaubort", "mremy"]:
    groups  => "sysadmin",
  }

}
