node 'edi-www-demo.dmz.lsn.camptocamp.com' {
  include tmpl-sig-dev-ms5-0

  apache::vhost {"edi-www-demo2.dmz.lsn.camptocamp.com":
    ensure  => present,
    aliases => ["edi-www-demo2.dmz.lsn"],
  }

  include nfs::base
  c2c::nfsmount {"cartoweb":
    share      => "",
  }
}
