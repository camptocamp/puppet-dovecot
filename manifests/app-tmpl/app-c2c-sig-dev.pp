class app-c2c-sig-dev {

  include python::dev

  package {["python-sphinx"]:
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
  common::concatfilepart { "sudoers.deploy":
    ensure => present,
    file => "/etc/sudoers",
    content => "## This part is managed by puppet
Defaults:%sigdev !umask
%sigdev ALL=(deploy) /usr/bin/deploy
",
    require => Group["sigdev"],
  }

}
