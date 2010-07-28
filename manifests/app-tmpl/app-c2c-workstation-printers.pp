class app-c2c-workstation-printers {

  package {"cups":
    ensure => present,
  }

  service {"cups":
    ensure  => running,
    pattern => "cupsd",
    enable  => true,
    require => Package["cups"],
  }

  line {"Browsing Off":
    line    => "Browsing Off",
    ensure  => absent,
    file    => "/etc/cups/cupsd.conf",
    require => Package["cups"],
    notify  => Service["cups"],
  }

  line {"activates browsing in cups":
    line => "BrowseOrder allow,deny",
    ensure  => present,
    file    => "/etc/cups/cupsd.conf",
    require => Line["Browsing Off"],
    notify  => Service["cups"],
  }

  line {"activate browsing in cups 2":
    line => "BrowseAllow all",
    ensure  => present,
    file    => "/etc/cups/cupsd.conf",
    require => Line["Browsing Off"],
    notify  => Service["cups"],
  }

  line {"activate browsing in cups 3":
    line => "BrowseAddress @LOCAL",
    ensure  => present,
    file    => "/etc/cups/cupsd.conf",
    require => Line["Browsing Off"],
    notify  => Service["cups"],
  }

}
