node 'veloland-schweizaktiv-demo.dmz.lsn.camptocamp.com' {
  include tmpl-sig-dev-ms5-0
  include nfs::base
  c2c::nfsmount {"swisstopo":
    share      => "swisstopo",
  }
}
