class app-c2c-sig-blonay-cartoriviera {
  
  apache::vhost {"blonay-cartoriviera":
    ensure  => present,
    group   => sigdev,
    mode    => 2775,
    aliases => [$fqdn, server_alias_from_domain($fqdn)],
  }

  tomcat::instance {"tomcat1":
    ensure => present,
    group  => sigdev,
  } 

  user {"admin":
    ensure     => present,
    managehome => true,
    home       => "/home/admin",
    shell      => "/bin/bash",
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

}
