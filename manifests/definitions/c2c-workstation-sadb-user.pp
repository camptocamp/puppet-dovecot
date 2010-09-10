define c2c::workstation::sadb::user ($ensure=present, $shell="/bin/bash") {

  $firstname  = url_get("${sadb}/user/${name}/firstname")
  $lastname   = url_get("${sadb}/user/${name}/lastname")
  $comment    = "${firstname} ${lastname}"
  $uid        = url_get("${sadb}/user/${name}/uid_number")
  $gid        = $uid

  notice "comment: ${comment}, uid: ${uid}, gid: ${gid}"

  if (! defined(Mount["/home"])) {
    mount {"/home":
      ensure    => mounted,
      device    => "/dev/sda6",
      atboot    => true,
      fstype    => "auto",
      options   => "defaults",
    }
  }

  user {$name:
    ensure     => $ensure,
    require    => [ Group[$name], Mount["/home"] ],
    comment    => $comment,
    managehome => true,
    uid        => $uid,
    gid        => $gid,
    shell      => $shell,
    groups => [
          "adm",
          "dialout",
          "cdrom",
          "floppy",
          "sudo",
          "audio",
          "dip",
          "video",
          "plugdev",
          "scanner",
          "lpadmin",
          "netdev",
          "admin",
          "fuse",
    ],
  }

  group {$name:
    ensure => $ensure,
    gid    => $gid 
  }

  c2c::ssh_authorized_key{"$name on $name":
    user      => $name,
    sadb_user => $name,
  }

  exec {"default-user-password for ${name}":
    command => "usermod -p fhb8GJD/DWeDw ${name}",
    onlyif  => "egrep -q '^${name}:!:' /etc/shadow",
    require => User[$name],
  }

  file {"/home/${name}":
    ensure => directory,
    mode   => 755,
    owner  => $name,
    group  => $name,
  }

  file {"/home/${name}/nobackup":
    ensure  => directory,
    mode    => 755,
    owner   => $name,
    group   => $name,
    require => File["/home/${name}"],
  }

  file {"/home/${name}/nobackup/README.txt":
    ensure  => present,
    content => "This directory is not backed up\n",
    owner   => $name,
    group   => $name,
    require => File["/home/${name}/nobackup"],
  }

  # Change default password
  file {"/home/${name}/.changepwd.desktop":
    require => [File["/home/${name}"],File["/usr/local/sbin/changepwd.sh"]],
    mode    => 700,
    owner   => $name,
    group   => $name,
    content => "# # file managed by puppet
[Desktop Entry]
Type=Application
Name=Changer pwd
Exec=sh /usr/local/sbin/changepwd.sh
Icon=system-run
Comment=
    ",
  }

  file {"/home/${name}/.config":
    ensure  => directory,
    owner   => $name,
    group   => $name,
  }

  file {"/home/${name}/.config/autostart":
    ensure  => directory,
    owner   => $name,
    group   => $name,
    require => File["/home/${name}/.config"],
  }

  if !defined (File["/usr/local/sbin/changepwd.sh"]) {
    file {"/usr/local/sbin/changepwd.sh":
      ensure  => present,
      mode    => 755,
      source  => "puppet:///c2c/usr/local/sbin/changepwd.sh",
    }
  }

  exec {"notify user ${name} to change passwd":
    command => "ln -s /home/${name}/.changepwd.desktop /home/${name}/.config/autostart/changepwd.desktop",
    onlyif  => "test $(grep ${name} /etc/shadow | cut -d ':' -f2) = 'fhb8GJD/DWeDw'",
    unless => "test -L /home/${name}/.config/autostart/changepwd.desktop",
    require => File["/home/${name}/.config/autostart"],
  }

  # Bookmarks for nautilus
  file { "/home/${name}/.gtk-bookmarks":
    ensure => present,
    owner  => $name,
    group  => $name,
  }

  line { "add fileserver bookmarks - commun for ${name}":
    line    => "smb://fileserver.camptocamp.com/commun/ Fileserver commun",
    ensure  => present,
    file    => "/home/${name}/.gtk-bookmarks",
    require => File["/home/${name}/.gtk-bookmarks"],
  }

  line { "add fileserver bookmarks - cdo for ${name}":
    line    => "smb://fileserver.camptocamp.com/cdo/ Fileserver cdo",
    ensure  => present,
    file    => "/home/${name}/.gtk-bookmarks",
    require => File["/home/${name}/.gtk-bookmarks"],
  }

  line { "add fileserver bookmarks - board for ${name}":
    line    => "smb://fileserver.camptocamp.com/board/ Fileserver board",
    ensure  => present,
    file    => "/home/${name}/.gtk-bookmarks",
    require => File["/home/${name}/.gtk-bookmarks"],
  }

  ### VMWARE FINE-TUNNING ###
  file {"/home/${name}/.vmware":
    ensure  => directory,
    owner   => $name,
    group   => $name,
    require => [User[$name]],
  }

  file {"/home/${name}/.vmware/license.ws.6.0.200610":
    ensure  => absent,
  }

  file {"/home/${name}/.vmware/license-ws-70-e1-200904":
    ensure => present,
    source  => "puppet:///c2c/license-ws-70-e1-200904",
    owner   => $name,
    group   => $name,
    require => File["/home/${name}/.vmware"],
  }

  # Gconf variables
  $gc_path='/system/networking/connections/'
  $gc_wifi=1
  $gc_vpn=2

  # Gconf fine-tuning 
  c2c::gconf{
    "WIFI 802-11 mode for ${name}":
      keyname => "${gc_path}${gc_wifi}/802-11-wireless/mode",
      type => 'string', value => 'infrastructure', user => $name;

    "WIFI 802-11 name for ${name}":
      keyname => "${gc_path}${gc_wifi}/802-11-wireless/name",
      type  => 'string', value => '802-11-wireless', user => $name;

    "WIFI 802-11 security for ${name}":
      keyname => "${gc_path}${gc_wifi}/802-11-wireless/security",
      type => 'string', value => '802-11-wireless-security', user => $name;

    "WIFI 802-11 seen-bssids for ${name}":
      keyname => "${gc_path}${gc_wifi}/802-11-wireless/seen-bssids",
      type => 'list', list_type => 'string', value => '[00:16:b6:d9:32:79]', user => $name;

    "WIFI 802-11 . for ${name}":
      keyname => "${gc_path}${gc_wifi}/802-11-wireless/ssid",type => 'list',
      list_type => 'int',value => '[99,97,109,112,116,111,99,97,109,112]', user => $name;

    "WIFI 802-11 key-mgmt for ${name}":
      keyname => "${gc_path}${gc_wifi}/802-11-wireless-security/key-mgmt",
      type => 'string', value => 'wpa-eap', user => $name;

    "WIFI 802-11 name1 for ${name}":
      keyname => "${gc_path}${gc_wifi}/802-11-wireless-security/name",
      type => 'string', value => '802-11-wireless-security', user => $name;

    "WIFI eap for ${name}":
      keyname => "${gc_path}${gc_wifi}/802-1x/eap",
      type => 'list',list_type => 'string',value   => '[ttls]', user => $name;

    "WIFI identity for ${name}":
      keyname => "${gc_path}${gc_wifi}/802-1x/identity",
      type => 'string', value => $name, user => $name;

    "WIFI name2 for ${name}":
      keyname => "${gc_path}${gc_wifi}/802-1x/name",
      type => 'string', value => '802-1x', user => $name;

    "WIFI nma-ca-cert-ignore for ${name}":
      keyname => "${gc_path}${gc_wifi}/802-1x/nma-ca-cert-ignore",
      type => 'bool',value => 'true', user => $name;

    "WIFI phase2-auth for ${name}":
      keyname => "${gc_path}${gc_wifi}/802-1x/phase2-auth",
      type => 'string', value => 'mschapv2', user => $name;

    "WIFI autoconnect for ${name}":
      keyname => "${gc_path}${gc_wifi}/connection/autoconnect",
      type => 'bool',value => 'true', user => $name;

    "WIFI id for ${name}":
      keyname => "${gc_path}${gc_wifi}/connection/id",
      type => 'string', value => 'Camptocamp SA', user => $name;

    "WIFI name3 for ${name}":
      keyname => "${gc_path}${gc_wifi}/connection/name",
      type => 'string', value => 'connection', user => $name;

    "WIFI type2 for ${name}":
      keyname => "${gc_path}${gc_wifi}/connection/type",
      type => 'string', value => '802-11-wireless', user => $name;

    "VPN id for ${name}":
      keyname => "${gc_path}${gc_vpn}/connection/id",
      type => 'string', value => 'Camptocamp SA', user => $name;
  
    "VPN name for ${name}":
      keyname => "${gc_path}${gc_vpn}/connection/name",
      type => 'string',value => 'connection', user => $name;

    "VPN type for ${name}":
      keyname => "${gc_path}${gc_vpn}/connection/type",
      type => 'string',value => 'vpn', user => $name;

    "VPN ca for ${name}":
      keyname => "${gc_path}${gc_vpn}/vpn/ca",
      type => 'string', value => '/etc/openvpn/camptocamp/ca.crt', user => $name;
    
    "VPN comp-lzo for ${name}":
      keyname => "${gc_path}${gc_vpn}/vpn/comp-lzo",
      type => 'string',value => 'yes', user => $name;
      
    "VPN connection-type for ${name}":
      keyname => "${gc_path}${gc_vpn}/vpn/connection-type",
      type => 'string', value => 'password', user => $name;
    
    "VPN remote for ${name}":
      keyname => "${gc_path}${gc_vpn}/vpn/remote",
      type => 'string', value => 'c2cpc3.camptocamp.com', user => $name;
    
    "VPN service-type for ${name}":
      keyname => "${gc_path}${gc_vpn}/vpn/service-type",
      type => 'string', value => 'org.freedesktop.NetworkManager.openvpn', user => $name;
  
    "VPN ta for ${name}":
      keyname => "${gc_path}${gc_vpn}/vpn/ta",
      type => 'string', value => '/etc/openvpn/camptocamp/ta.key', user => $name;
  
    "VPN ta-dir for ${name}":
      keyname => "${gc_path}${gc_vpn}/vpn/ta-dir",
      type => 'string', value => '1', user => $name;

    "VPN username for ${name}":
      keyname => "${gc_path}${gc_vpn}/vpn/username",
      type => 'string', value => $name, user => $name;

    "VPN addresses for ${name}":
      keyname   => "${gc_path}${gc_vpn}/ipv4/addresses",
      type => 'list', list_type => 'int', value => '[]', user => $name;
  
    "VPN dns for ${name}":
      keyname => "${gc_path}${gc_vpn}/ipv4/dns",
      type => 'list', list_type => 'int', value => '[]', user => $name;
  
    "VPN method for ${name}":
      keyname => "${gc_path}${gc_vpn}/ipv4/method",
      type => 'string', value => 'auto', user => $name;

    "VPN name2 for ${name}":
      keyname => "${gc_path}${gc_vpn}/ipv4/name",
      type => 'string', value => 'ipv4', user => $name;
  
    "VPN routes for ${name}":
      keyname => "${gc_path}${gc_vpn}/ipv4/routes",
      type => 'list', list_type => 'int', value => '[]', user => $name;
  }
}
