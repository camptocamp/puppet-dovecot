class app-c2c-sig-dev {
  $pr_id = url_get("${sadb}/vserver/${fqdn}/project_id")
  $pr_name = url_get("${sadb}/project/${pr_id}/name")

  apache::vhost {"$pr_name":
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
