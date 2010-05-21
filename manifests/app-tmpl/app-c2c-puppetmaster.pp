# Class for specifics for srv-c2c-puppetmaster
#
# Requires: 
# Provides: 
# Conflicts: 
#

class app-c2c-puppetmaster {

  include puppet::master::passenger
  include mysql::server


  user {
    "mbornoz":
      ensure      => present,
      managehome  => true,
      shell       => "/bin/bash",
      comment     => "Mathieu Bornoz";
    "marc":
      ensure      => present,
      managehome  => true,
      shell       => "/bin/bash",
      comment     => "Marc Fournier";
    "cjeanneret":
      ensure      => present,
      managehome  => true,
      shell       => "/bin/bash",
      comment     => "Cedric Jeanneret";
    "jbaubort":
      ensure      => present,
      managehome  => true,
      shell       => "/bin/bash",
      comment     => "Jean-Baptiste Aubort";
    "ckaenzig":
      ensure      => present,
      managehome  => true,
      shell       => "/bin/bash",
      comment     => "Christian Kaenzig";
    "mremy":
      ensure      => present,
      managehome  => true,
      shell       => "/bin/bash",
      comment     => "Marc Remy";
  }

  
  
}
