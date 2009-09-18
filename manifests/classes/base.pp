class cartoweb3::base {

  file {"/usr/local/bin/cartoweb3-clean.sh":
    ensure => present,
    mode   => 755,
    source => "puppet:///cartoweb3/usr/local/bin/cartoweb3-clean.sh"
  }

  cron { "cartoweb3 clean images cache":
    command => "/usr/local/bin/cartoweb3-clean.sh",
    user    => "root",
    hour    => 4,
    minute  => 0,
    require => File["/usr/local/bin/cartoweb3-clean.sh"],
    ensure  => absent,
  }

  cron { "cw3 clean images cache":
    command => "/usr/local/bin/cartoweb3-clean.sh",
    user    => "www-data",
    hour    => 4,
    minute  => 0,
    require => [ File["/usr/local/bin/cartoweb3-clean.sh"], User["www-data"] ],
  }
}
