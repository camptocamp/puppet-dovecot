class app-c2c-workstation-openerp {

  package {"openerp-client":
    ensure  => present,
  }

  apt::preferences {"openerp-client":
    ensure => present,
    pin => "Version 4.2.3+2~c2cbzr146",
    priority => 1100,
  }

  file {"/usr/share/applications/openerp-client.desktop":
    ensure  => present,
    mode   => 644,
    content => "# file managed by puppet
[Desktop Entry]
Encoding=UTF-8
Name=OpenERP
GenericName=OpenERP Client
Comment=OpenERP Client
Type=Application
Exec=/usr/bin/openerp-client
Icon=/opt/openerp-client/pixmaps/tinyerp-icon-64x64.png
StartupNotify=true
Terminal=false
Categories=Application;Office;ERP;GNOME;GTK; 
",
    require => Package["openerp-client"],  
  }

}
