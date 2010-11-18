class app-c2c-pnv-refonte {
  package {["php-pear", "build-essential", "php5-dev", "apache2-prefork-dev", "phpmyadmin"]:
    ensure => present,
  }

  include mysql::server

  mysql::rights {"admin on pnv_refonte":
    ensure => present,
    database => "pnv_refonte",
    user => "admin",
    password => "ailaNg0T",
  }
  
  apache::vhost { $fqdn:
    ensure => present,
    group => "sigdev",
    mode => "2775",
    aliases => ["vanoise.camptocamp.net", "extranet.camptocamp.net", "observatoire.camptocamp.net"],
  }

  c2c::checkexternalurl::export {["vanoise.camptocamp.net", "extranet.camptocamp.net", "observatoire.camptocamp.net",$fqdn]:
    path => "/media/system/js/caption.js",
  }

  c2c::ssh_authorized_key {
    "pierre on admin":  sadb_user => "pierre", user => "admin";
    "aabt on admin":    sadb_user => "aabt", user => "admin";
    "fvanderbiest on admin":  sadb_user => "fvanderbiest", user => "admin";
    "bbinet on admin":  sadb_user => "bbinet", user => "admin";
    "tbonfort on admin":  sadb_user => "tbonfort", user => "admin", ensure => absent;
    "fredj on admin":  sadb_user => "fredj", user => "admin";
  }


# external users
  user {"ftissot":
    ensure => present,
    managehome => true,
    groups => ["admin","sigdev","www-data"],
    shell => "/bin/bash",
  }

  ssh_authorized_key {"thefrog81@wanadoo.fr":
    ensure  => present,
    require => User["ftissot"],
    user    => "ftissot",
    type    => "ssh-rsa",
    key     => "AAAAB3NzaC1yc2EAAAABJQAAAIB0bsEcz/NRSMzKLjLK0FJTzfdfEWZZcaMdzJcXBP8/nnSGBr3VcV3TWH709zRKfIGEku2L/UNUsJrl0r0PMeAs9qNZVXVucJ15WjbJfWsyveVeJLoJqNmFIDVhoN3JvrG/+37wxuKsz/Wm7bIg8TANu52CkrwbXlMf3XFTYaGkbQ==",
  }

}
