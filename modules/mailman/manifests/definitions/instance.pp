define mailman::instance ($ensure=present, $vhost, $urlpath="/cgi-bin/mailman/") {
  mailman::vhost {"${vhost}":
    ensure => $ensure,
  }
  mailman::domain {"${name}":
    ensure => $ensure,
    vhost  => $vhost,
    urlpath => $urlpath,
  }

  postfix::config {"relay_domains":
    ensure => $ensure,
    value  => "${name}",
  }
 
}
