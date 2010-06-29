node 'sitn-profile-demo.dmz.lsn.camptocamp.com' {
  include tmpl-sig-dev-ms5-0
  include nfs::base
  c2c::nfsmount {"cartoweb":
    share       => "",
  }

  apache::vhost {"sitn-proto-mapfish-demo.dmz.lsn.camptocamp.com":
    ensure => present,
    group  => sigdev,
    mode   => 2775,
  }
}
