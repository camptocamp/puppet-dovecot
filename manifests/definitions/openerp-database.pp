define c2c::openerp::database ($ensure=present,$owner) {
  postgresql::database {$name:
    ensure  => $ensure,
    owner   => $owner,
    require => Class["c2c::openerp-ro"],
    notify  => Exec["set rights on $name for openerp_ro"],
  }
  exec {"set rights on $name for openerp_ro":
    command     => "su -c '/usr/local/sbin/openerp-ro-rights $name' postgres",
    refreshonly => true,
  }
}
