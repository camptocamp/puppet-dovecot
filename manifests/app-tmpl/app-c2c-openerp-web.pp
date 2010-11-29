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
    aliases => [
      "openerp.camptocamp.com",
      "openerpinstitute.com",
      "openerp-institute.com",
      "openerp-university.com",
      "openerpuniversity.com", 
      "openerpinstitute.ch",
      "openerp-institute.ch",
      "openerpuniversity.ch",
      "openerp-university.ch",
      "openerp-institute.org",
      "openerp-university.org",
      "openerpinstitute.org",
      "openerpuniversity.org",
      "openerp-institute.fr",
      "openerp-university.fr",
      "openerpuniversity.fr",
      "openerpinstitute.fr",
      "openerpuniversity.at",
      "openerp-institute.at",
      "openerp-university.at",
      "openerpinstitute.at",
      "www.openerpinstitute.com",
      "www.openerp-institute.com",
      "www.openerp-university.com",
      "www.openerpuniversity.com", 
      "www.openerpinstitute.ch",
      "www.openerp-institute.ch",
      "www.openerpuniversity.ch",
      "www.openerp-university.ch",
      "www.openerp-institute.org",
      "www.openerp-university.org",
      "www.openerpinstitute.org",
      "www.openerpuniversity.org",
      "www.openerp-institute.fr",
      "www.openerp-university.fr",
      "www.openerpuniversity.fr",
      "www.openerpinstitute.fr",
      "www.openerpuniversity.at",
      "www.openerp-institute.at",
      "www.openerp-university.at",
      "www.openerpinstitute.at",
    ],
    group   => admin,
    require => User["admin"],
  }

  apache::directive {"redirect":
    ensure    => present,
    directive => template("c2c/redirect-openerp.camptocamp.com.erb"),
    vhost     => "$fqdn",
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
