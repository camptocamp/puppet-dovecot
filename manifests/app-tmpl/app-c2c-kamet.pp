class app-c2c-kamet {
  include nfs::client
  nfs::mount {"rw cartoweb":
    ensure => present,
    share  => "/srv/nfs/cartoweb/",
    mountpoint => "/mnt/cartoweb",
    server_options => "all_squash,anongid=1030,sync,no_subtree_check,rw",
    client_options => "rw,auto",
    server => "nfs.camptocamp.com"
  }
#  c2c::nfsmount {"cartoweb read write":
#    share               => "",
#    server_rights       => "rw",
#    mountpoint          => "/mnt/cartoweb",
#    server_options      => "all_squash,anongid=1030,sync,no_subtree_check",
#    client_options      => "rw,auto"
#  }

  group {"sigdev":
    gid => 1030,
    ensure => present,
  }

  package {"libstdc++5":
    ensure => present,
  }
}
