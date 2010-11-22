define c2c::trac-instance (
    $ensure,
    $cc,
    $description,
    $url,
    $slash=false
) {

  trac::instance {$name:
    ensure  => $ensure,
    basedir => "/srv/trac/projects",
    cc      => $cc,
    description => $description,
    url     => $url,
    replyto => "devnull@camptocamp.com",
    from    => "trac@camptocamp.com",
    logo    => "/tracdocs/trac_banner.png",
    smtpserver => "mail.camptocamp.com",
    slash   => $slash,
  }

  $tracdir = "/srv/trac/projects/$name"

  # Default admin account
  file { "$tracdir/conf/htpasswd":
    content => "admin:z2mfz4qlSygZI\n", # Default password: ree2tahG
    replace => false,
    owner   => "www-data",
    group   => "www-data",
    require => File["$tracdir"],
  }
}

