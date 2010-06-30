node "pnecrins-ressources-demo.dmz.lsn.camptocamp.com" {
  include tmpl-sig-dev-ms5-2
  include nfs::base
  c2c::nfsmount {"cartoweb":
    share       => "",
  }

}
