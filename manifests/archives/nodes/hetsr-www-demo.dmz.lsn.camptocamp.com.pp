node 'hetsr-www-demo.dmz.lsn.camptocamp.com' {
  include os-c2c-dev
  include apache::base
  include mysql::server

  apache::vhost{"hetsr-www-demo.dmz.lsn.camptocamp.com":
    ensure => present,
  }

  mysql::database{"hetsr":
    ensure => present,
  }

  mysql::rights{"hetsr on hetsr":
    ensure   => present,
    database => "hetsr",
    user     => "hetsr",
    password => "hetsr",
  }

  user {
    "jbaubort":
      ensure      => present,
      managehome  => true,
      shell       => "/bin/bash",
      comment     => "Jean-Baptiste Aubort";
  }

    ssh-old::account::allowed_user {
    "jbaubort on jbaubort":
      allowed_user => "jbaubort",
      system_user  => "jbaubort";
  }

}
