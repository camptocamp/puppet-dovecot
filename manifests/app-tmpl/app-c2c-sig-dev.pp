class app-c2c-sig-dev {
  
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

  tomcat::instance {"tomcat1":
    ensure => present,
    group  => sigdev,
  } 
}
