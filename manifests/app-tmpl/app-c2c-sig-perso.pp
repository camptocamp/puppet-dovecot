class app-c2c-sig-perso {

  package {["python-sphinx", "python-setuptools", "python-devel"]:
    ensure => present,
  }
  
  $project_name = $apache_vhost_name ? {
    "" => project_name_from_domain($fqdn),
    default => $fqdn,
  }

  apache::vhost {$project_name:
    ensure  => present,
    group   => sigdev,
    mode    => 2775,
    aliases => [$fqdn, server_alias_from_domain($fqdn)],
  }

  $tomcat_name = $tomcat_instance_name ? {
    ""      => "tomcat1",
    default => $tomcat_instance_name,
  }

  tomcat::instance {$tomcat_name:
    ensure => present,
    group  => sigdev,
  } 

  common::concatfilepart {"sigdev on root":
    ensure => present,
    file   => "/etc/sudoers",
    content => "%sigdev ALL=(ALL) NOPASSWD: /bin/su, /bin/su -\n",
  }
}
