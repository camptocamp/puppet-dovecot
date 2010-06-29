node 'crara-websol-demo.dmz.lsn.camptocamp.com' {
  include tmpl-sig-dev-ms5-0
  include tmpl-dev-tomcat-6

  apache::vhost{"test.$fqdn":
    ensure => present,
    group => "c2cdev",
    mode => 2775,
  }  
}
