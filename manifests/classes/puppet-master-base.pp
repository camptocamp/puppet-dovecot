class puppet::master::base {
  include mysql::server

  package {
    "pwgen": ensure => present;
  }

  # Database
  mysql::database{"puppet":
    ensure => present,
  }

  mysql::rights{"Set rights for puppet database":
    ensure   => present,
    database => "puppet",
    user     => "puppet",
    password => "puppet"
  }
}
