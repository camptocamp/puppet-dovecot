node 'ifremer-maintenancesextant-dev.int.lsn.camptocamp.com' {
  include os-base
  include os-sigdev
  include postgresql::v8-3::postgis
  include postgresql::backup
  include apache
  include apache::deflate
  include mapserver
  include tilecache::base
  include mapfish
  include cartoweb3::base
  include java::v6
  include msmtp

  postgresql::user{ "www-data":
    ensure   => present,
    password => "www-data",
  }
  
  apache::module {["proxy","proxy_http"]:
    ensure => present,
  }
  
  file {"/etc/php5/conf.d/msmtp.ini":
    ensure  => present,
    content => "sendmail_path = /usr/bin/msmtp --read-recipients\n",
    notify  => Service["apache2"],
    require => Package["php5-common"],
  }

  apache::vhost {$fqdn:
    ensure => present,
    group  => sigdev,
  }

  file {"/var/www/sextant":
    ensure => directory,
    owner  => root,
    group  => sigdev,
    mode   => 2775,
  }
  c2c::sshuser::sadb { [
    "pmauduit",
    "alex",
    "fredj",
    "ochriste",
    "bbinet",
    "ebelo",
    "fjacon",
    ]:
    ensure => present,
    groups => ["sigdev", "www-data"],
  }

  common::concatfilepart {"00-base":
    file    => "/etc/sudoers",
    content => "
root ALL=(ALL) NOPASSWD:ALL
",
  }
  common::concatfilepart {"00-sigdev":
    file    => "/etc/sudoers",
    content => "
%sigdev ALL=(ALL) NOPASSWD:ALL
",
  }
}
