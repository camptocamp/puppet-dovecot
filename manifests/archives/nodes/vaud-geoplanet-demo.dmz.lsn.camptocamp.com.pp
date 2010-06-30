node 'vaud-geoplanet-demo.dmz.lsn.camptocamp.com' {
  include os-c2c-dev
  include nfs::base
  c2c::nfsmount {"cartoweb":
    share      => "",
  }
}
