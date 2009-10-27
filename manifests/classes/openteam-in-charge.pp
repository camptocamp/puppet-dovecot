class c2c::openteam-in-charge inherits openerp::base {

  c2c::ssh_authorized_key{"nicolas.bessi@camptocamp.com":
    sadb_user => "nbessi",
    user => "openerp",
    require => User["openerp"],
  }

  c2c::ssh_authorized_key{"joel.grandguillaume@camptocamp.com":
    sadb_user => "jgrandguillaume",
    user => "openerp",
    require => User["openerp"],
  }

  c2c::ssh_authorized_key{"luc.maurer@camptocamp.com":
    sadb_user => "lmaurer",
    user => "openerp",
    require => User["openerp"],
  }

  c2c::ssh_authorized_key { "arnaud.wuest@camptocamp.com":
    sadb_user => "awuest",
    user  => "openerp",
    require => User["openerp"],
    ensure => absent,
  }

  c2c::ssh_authorized_key { "jean-baptiste.aubort@camptocamp.com":
    sadb_user => "jbaubort",
    user  => "openerp",
    require => User["openerp"],
    ensure => absent,
    ensure => absent,
  }

  c2c::ssh_authorized_key { "vincent.renaville@camptocamp.com":
    sadb_user => "vrenaville",
    user  => "openerp",
    require => User["openerp"],
  }
}
