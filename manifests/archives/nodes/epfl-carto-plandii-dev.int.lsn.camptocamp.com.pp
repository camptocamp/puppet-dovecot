node "epfl-carto-plandii-dev.int.lsn.camptocamp.com"{
  include tmpl-sig-dev
  include nfs::base
  c2c::nfsmount {"cartoweb":
    mountpoint => "/var/lib/cartoweb",
    share      => "",
  }
  user {"deploy":
    ensure      => present,
    groups      => ["www-data", "sigdev"],
    managehome  => true,
  }
  postgresql::user {"deploy":
    ensure => present,
    superuser => "true",
  }
  line {"deploy on postgresql":
    ensure  => present,
    line    => "local   all   deploy                      ident sameuser",
    file    => "/etc/postgresql/8.3/main/pg_hba.conf",
    notify  => Service["postgresql"],
  }
}
