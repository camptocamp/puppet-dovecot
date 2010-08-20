class c2c::nfs::sig {
  package {["nfs-common","portmap"]:
    ensure  => present,
  }

  file {"/etc/default/portmap":
    ensure  => present,
    source  => "puppet:///c2c/etc/default/portmap",
    require => Package["portmap"],
  }

  exec {"mkdir /var/local/cartoweb":
    unless => "test -d /var/local/cartoweb",
  }

  line { "add cartoweb in fstab":
    line     => "nfs.camptocamp.com:/srv/nfs/cartoweb/  /var/local/cartoweb    nfs timeo=14,intr,ro  0   0",
    ensure   => present,
    file     => "/etc/fstab",
    require  => [ Exec["mkdir /var/local/cartoweb"], Package["nfs-common"], Package["portmap"] ],
    notify   => Exec["mount /var/local/cartoweb"],
  }

  line { "remove old cartoweb in fstab":
    line     => "nfs.camptocamp.com:/mnt/cartoweb/  /var/local/cartoweb    nfs timeo=14,intr,ro  0   0",
    ensure   => absent,
    file     => "/etc/fstab",
    require  => [ Exec["mkdir /var/local/cartoweb"], Package["nfs-common"], Package["portmap"] ],
    notify   => Exec["mount /var/local/cartoweb"],
  }

  exec { "mount /var/local/cartoweb":
    unless => "grep -q cartoweb /proc/mounts",
  }
}
