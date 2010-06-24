class app-c2c-sig {

  group {"sigdev":
    ensure => present,
  }

  file {"/var/sig":
    ensure  => directory,
    owner   => root,
    group   => sigdev,
    mode    => 2775,
    require => Group["sigdev"]
  }

  package {"deploy":
    ensure => present,
  }

  user {"deploy":
    ensure      => present,
    groups      => ["www-data", "sigdev"],
    managehome  => true,
    require     => Package["deploy"],
  }
  
  postgresql::user {"deploy":
    ensure => present,
    superuser => "true",
  }

  file {"/var/cache/deploy":
    ensure => directory,
    owner  => "deploy",
    group  => "sigdev",
    mode   => 0755,
    require => [Package["deploy"], User["deploy"]],
  }

  apache::vhost {"$project_name":
    ensure  => present,
    group   => sigdev,
    mode    => 2775,
    aliases => [$fqdn],
  }

  tomcat::instance {"tomcat1":
    ensure => present,
    group  => sigdev,
  } 

}
