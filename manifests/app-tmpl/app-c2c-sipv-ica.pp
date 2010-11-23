class app-c2c-sipv-ica {

  group {"sigdev": }

  tomcat::instance {"tomcat1":
    ensure => present,
    group  => "sigdev",
  }

  apache::vhost{"$fqdn":
    ensure => present,
    group  => "sigdev",
    mode   => 2775,
  }
  
  file {"/etc/apache2/conf.d/LimitRequestLine.conf":
    ensure => present,
    notify => Exec["apache-graceful"],
    owner  => root,
    group  => root,
    mode   => 0644,
    content => "LimitRequestLine 16380\n",
  }

  c2c::ssh_authorized_key {
    "ebelo on admin":        sadb_user => "ebelo",        user  => "admin";
    "fredj on admin":        sadb_user => "fredj",        user  => "admin";
    "fvanderbiest on admin": sadb_user => "fvanderbiest", user  => "admin";
  }

  user {"llingner":
    ensure => present,
    groups => ["sigdev","www-data"],
    shell  => "/bin/bash",
    managehome => true,
  }
  
  ssh_authorized_key {"lars@lingner.eu":
    ensure  => present,
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEA1ZPJoTr8ji5MhWxlAZkQfaL0CGxA7+iXU3wUlVXtBDsQRtAxreT6bP0Yg9YzSnQ5LvjKEd9ytnKeLI7nE+9rlq6zxr7nE1ftrauHn2XxbXB9LXJfzSXwMnXKrmnMkjICaKc99Vn208aKmccqip82GpVotqkpqJUx8JabIUqjIDwJLIioAQHqW1+HovB0XEeT1/gmnR9MUxq+jStkIOJzf6yD6+HuYgvqgiA+KNMZ4UuBTWgu4RYlNds2mpxZ5TKnJvfLqRmnYdzVnnS57LtyP6cs2ZrWa2qV5HfA5QFHblaSaWOY/HDafiFIUER2cSs7xxj6fIEZRNKRCup3odgJ3w==",
    type    => "ssh-rsa",
    user    => "llingner",
    require => User["llingner"],
  }
  
  common::concatfilepart {"001-llingner":
    ensure  => present,
    file    => "/etc/sudoers",
    require => User["llingner"],
    content => "
# file managed by puppet
llingner ALL=(root) NOPASSWD: /etc/init.d/apache2, /etc/init.d/postgresql*, /usr/sbin/apache2ctl, /bin/su - postgres, /bin/su - www-data
llingner ALL=(postgres) NOPASSWD: ALL
llingner ALL=(www-data) NOPASSWD: ALL
",
  }
}
