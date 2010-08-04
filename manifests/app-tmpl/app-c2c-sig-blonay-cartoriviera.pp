class app-c2c-sig-blonay-cartoriviera {

  group {"admin":
    ensure  => present,
    require => User["admin"],
  }
  
  apache::vhost {"map.cartoriviera.ch":
    ensure  => present,
    group   => admin,
    mode    => 2775,
  }

  apache::vhost {"preprod.cartoriviera.ch":
    ensure  => present,
    group   => admin,
    mode    => 2775,
  }

  apache::vhost {"www.cartoriviera.ch":
    ensure  => present,
    group   => admin,
    mode    => 2775,
  }

  apache::vhost {"blonay-cartoriviera":
    ensure => absent,
  }

  apache::auth::htpasswd {"cartoriviera in /var/www/preprod.cartoriviera.ch/private/htpasswd":
    ensure => present,
    vhost => "preprod.cartoriviera.ch",
    username => "cartoriviera",
    clearPassword => "cartoriviera",
  }

  apache::auth::basic::file::user {"user1-on-webdav2":
    vhost => "preprod.cartoriviera.ch",
    location => "/",
    users => "cartoriviera",
  }

  tomcat::instance {"print":
    ensure => present,
    group  => admin,
  } 

  user {"admin":
    ensure     => present,
    managehome => true,
    home       => "/home/admin",
    shell      => "/bin/bash",
    groups     => ["www-data", "sigdev"],
  }

  c2c::ssh_authorized_key{
    "alex on admin": sadb_user => "alex", user => "admin", require => User["admin"];
  }

  c2c::sshuser {"ygillieron": 
    ensure  => present, 
    groups  => "admin", 
    uid     => 2000, 
    comment => "y.gillieron@b-t-i.ch", 
    email   => "y.gillieron@b-t-i.ch",
    type    => "rsa", 
    key     => "AAAAB3NzaC1yc2EAAAABJQAAAIEAkc3duX7LBHnQndfFLgIVd8OCVkyNxBwz81MAO1TXkjVLi5TnkBngHe7w1oLOmygylVNd6Grag/iY9NX/6YilYTqRg4Q/RaYJBfG37o3ur4wnGYaHaAjyPTyT96RVvQ5DrVSaPlPWRCRgSxL6CUfrUx23mjP/JRCSAs55PxMwy+8=";
  }

  c2c::sshuser {"tcachin": 
    ensure  => present, 
    groups  => "admin", 
    uid     => 2005, 
    comment => "tcachin@blonay.ch", 
    email   => "tcachin@blonay.ch",
    type    => "rsa", 
    key     => "AAAAB3NzaC1yc2EAAAABJQAAAIEAwtEQHB2J6f9y4RERcIZ7QcqBtUWsSgeGHAAOFfrU8t4FV/sNJnt5CAwpWXbDreVQfA8gjmrkeCkdEe5G2IVuqyN6mxTs4IeeWwIATvJA1NBOGXb79FONkiOh1B7hDfrkLdAACn1tykFiwPk+psFnFrdFUWA9fzEmJIJMXUYLKl0=";
  }

  c2c::sshuser {"buchsl": 
    ensure  => present, 
    groups  => "admin", 
    uid     => 2006, 
    comment => "laurent.buchs@sige.ch", 
    email   => "laurent.buchs@sige.ch",
    type    => "rsa", 
    key     => "AAAAB3NzaC1yc2EAAAABJQAAAIEAzUykFAtryuOPkAwMc0aItNGQvfurykXngWqIhQLlDMwrV5w1a5EvfMRUiGqZOYMv/fugieXYDG391JsE9jtUI4S8JqqYI9XoL9b9z77Ml2lNYXLtpfpqsDmaYZj/npM5sR8Q0tt9X+ak8er/b2SZTuD+r4rMlT9L1b3WhqsVyyU=";
  }

}
