define c2c::moinmoininstance($ensure=present, $vhost, $urlmatch, $acl_before=false, $acl_enabled=false) {
  moinmoin::instance { "$name":
    vhost       => "$vhost",
    urlmatch    => "$urlmatch",
    replace     => true,
    acl_before  => $acl_before,
    acl_enabled => $acl_enabled,
    ensure      => $ensure,
  }
  apache::moinmoin::instance::auth { "$name":
    vhost  => "$vhost",
    ensure => $ensure,
  }

}
