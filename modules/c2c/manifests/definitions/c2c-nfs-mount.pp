define c2c::nfsmount($ensure=present,
                  $share,
                  $mountpoint="/var/local/cartoweb",
                  $server_options='all_squash,anongid=65534,sync,no_subtree_check',
                  $server_rights='ro',
                  $client_options='auto',
                  $server='nfs.camptocamp.com') {
  if ($share == '') {
    $mount = "$mountpoint"
  } else {
    $mount = "${mountpoint}/${share}"
  }
  nfs::mount {"mount $name":
    ensure             => $ensure,
    share              => "/srv/nfs/cartoweb/$share",
    mountpoint         => "$mount",
    server_options     => $server_options,
    server_rights      => $server_rights,
    client_options     => $client_options,
    server             => $server,
  }
}
