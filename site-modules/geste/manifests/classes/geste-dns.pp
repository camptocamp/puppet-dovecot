class geste::dns {
  include bind

  file {"/etc/bind/named.conf.options":
    ensure => present,
    owner  => root,
    group  => bind,
    mode   => 0644,
    source => "puppet:///modules/geste/bind/named.conf.options",
    notify => Service["bind9"],
  }

  bind::zone {"geste":
    ensure => present,
    zone_contact => "contact.geste",
    zone_ns      => "gestepc4.geste",
    zone_serial  => "2010122602",
    zone_ttl     => "604800",
  }

  bind::a {"ns gestepc4":
    ensure => present,
    zone   => "geste",
    owner  => "gestepc4",
    host   => "192.168.12.5",
  }
  bind::a {"ns gestepc3":
    ensure => present,
    zone   => "geste",
    owner  => "gestepc3",
    host   => "192.168.12.11",
  }

  bind::a {
    "gateway":      zone => "geste", host => "192.168.12.1";
    "hephaistos":   zone => "geste", host => "192.168.12.2";
    "backup-geste": zone => "geste", host => "192.168.12.3";
    "old-server":   zone => "geste", host => "192.168.12.4";
    "gestorage2":   zone => "geste", host => "192.168.12.6";
    "gestorage3":   zone => "geste", host => "192.168.12.7";
    "gestorage4":   zone => "geste", host => "192.168.12.8";
    "openerp":      zone => "geste", host => "192.168.12.9";
    "zeus":         zone => "geste", host => "192.168.12.10";
    "poseidon1":    zone => "geste", host => "192.168.12.110";
    "gestepc11":    zone => "geste", host => "192.168.12.111";
    "gestepc12":    zone => "geste", host => "192.168.12.112";
    "gestepc13":    zone => "geste", host => "192.168.12.113";
    "gestepc14":    zone => "geste", host => "192.168.12.114";
    "gestorage":    zone => "geste", host => "192.168.12.200";
    "pc-zib":       zone => "geste", host => "192.168.12.201";
    "pc-gic":       zone => "geste", host => "192.168.12.202";
    "pc-jbd":       zone => "geste", host => "192.168.12.203";
    "pc-fev":       zone => "geste", host => "192.168.12.204";
    "pc-fap":       zone => "geste", host => "192.168.12.205";
    "pc-ges":       zone => "geste", host => "192.168.12.206";
    "pc-rho":       zone => "geste", host => "192.168.12.207";
    "pc-vhu":       zone => "geste", host => "192.168.12.208";
    "pc-pam":       zone => "geste", host => "192.168.12.209";
    "pc-mim":       zone => "geste", host => "192.168.12.210";
    "mac-mim":      zone => "geste", host => "192.168.12.211";
    "pc-rams":      zone => "geste", host => "192.168.12.212";
    "pc-dal":       zone => "geste", host => "192.168.12.213";
    "pc-djo":       zone => "geste", host => "192.168.12.214";
    "pc-cfa":       zone => "geste", host => "192.168.12.215";
    "pc-tka":       zone => "geste", host => "192.168.12.216";
  }

  bind::cname {
    "fileserver": zone => "geste", host => "hephaistos";
    "intranet":   zone => "geste", host => "hephaistos";
    "geste-openerp.geste.com": zone => "geste", host => "openerp";
    "openerp.geste.ch": zone => "geste", host => "openerp";
  }

}
