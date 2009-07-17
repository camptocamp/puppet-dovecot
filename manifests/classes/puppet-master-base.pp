class puppet::master::base {
  include mysql::server

  package { [
    "pwgen", # used in mysql class
    "python-docutils", # used by puppetdoc -m pdf
    ]: ensure => present,
  }

  package { "rdoc":
    ensure => present,
    name   => $operatingsystem ? {
      RedHat => "ruby-rdoc",
    },
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
