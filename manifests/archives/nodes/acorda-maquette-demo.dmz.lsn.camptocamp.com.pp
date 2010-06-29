node 'acorda-maquette-demo.dmz.lsn.camptocamp.com' {
  include tmpl-sig-dev-ms5-0
  include nfs::base
  c2c::nfsmount {"swisstopo":
    share          => "swisstopo",
    client_options => "ro,vers=3,rsize=32768,wsize=32768,hard,intr,proto=tcp,timeo=10,retrans=2,sec=sys",
  }
}
