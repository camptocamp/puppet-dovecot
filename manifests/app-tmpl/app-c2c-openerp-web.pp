class app-c2c-openerp-web {

  package {[
    "irb",
    "ri",
    "libapache2-mod-passenger",
    "sqlite3",
    "libsqlite3-dev",
    "ruby1.8-dev",
    "build-essential",
    "rake",
    ]:
    ensure => present,
  }

  apt::preferences {
    "rubygems":    pin => "release a=lenny-backports", priority => "1000";
    "rubygems1.8": pin => "release a=lenny-backports", priority => "1000";
    "bzr":         pin => "release a=lenny-backports", priority => 1000;
  }

  package {["rubygems","rubygems1.8"]: 
    ensure => latest,
  }

 file {"/etc/profile.d/gem_home.sh":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0755,
    content => "#!/bin/sh
export GEM_HOME=\${HOME}/lib/ruby/gems/1.8
export PATH=\${PATH}:\${HOME}/lib/ruby/gems/1.8
",
  }

  user {"admin":
    ensure     => present,
    managehome => true,
    shell      => "/bin/bash",
  }

  mysql::database {"oerpc2c":
    ensure => present,
  }

  mysql::rights {"oerpc2c on oerpc2c":
    ensure   => present,
    user     => "oerpc2c",
    database => "oerpc2c",
    password => "Eechiek8iehoowe",
    require  => Mysql::Database["oerpc2c"],
  }

  apache::vhost {"$fqdn":
    ensure  => present,
    aliases => "openerp.camptocamp.com",
    group   => admin,
    require => User["admin"],
  }

  apache::module {"passenger":
    ensure => present,
  }

  c2c::ssh_authorized_key {
    "jgrandguillaume on admin": require => User["admin"], user => "admin", sadb_user => "jgrandguillaume";
    "nbessi on admin"         : require => User["admin"], user => "admin", sadb_user => "nbessi";
    "vrenaville on admin"     : require => User["admin"], user => "admin", sadb_user => "vrenaville";
    "jbove on admin"          : require => User["admin"], user => "admin", sadb_user => "jbove";
  }
}