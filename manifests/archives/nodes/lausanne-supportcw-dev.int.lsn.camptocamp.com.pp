node 'lausanne-supportcw-dev.int.lsn.camptocamp.com' {
  include tmpl-sig-dev-ms5-0

  include nfs::base
  c2c::nfsmount {"cartoweb":
    share       => "",
  }

}