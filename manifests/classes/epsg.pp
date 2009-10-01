class mapserver::epsg {

  file { "/usr/share/proj/epsg":
    ensure  => present,
    require => Package["proj"],
  }
}

class mapserver::epsg::legacy inherits mapserver::epsg {

  File["/usr/share/proj/epsg"] {
    source  => "puppet:///mapserver/epsg.legacy",
  }
}

class mapserver::epsg::minimal inherits mapserver::epsg {

  File["/usr/share/proj/epsg"] {
    source  => "puppet:///mapserver/epsg.minimal",
  }
}
