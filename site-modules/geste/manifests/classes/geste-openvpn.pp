class geste::openvpn {
  include openvpn::server

  file {[
    "/etc/openvpn/ca",
    "/etc/openvpn/ca/keys",
    "/etc/openvpn/ca/skel",
    "/etc/openvpn/ca/distrib",
    ]:
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 0755,
    require => Package["openvpn"],
  }

  file {
    "/etc/openvpn/ca/keys/server.crt":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0644,
      require => File["/etc/openvpn/ca/keys"],
      source  => "puppet:///modules/geste/openvpn/server.crt";
    "/etc/openvpn/ca/keys/server.key":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0600,
      require => File["/etc/openvpn/ca/keys"],
      source  => "puppet:///modules/geste/openvpn/server.key";
    "/etc/openvpn/ca/keys/ca.crt":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0644,
      require => File["/etc/openvpn/ca/keys"],
      source  => "puppet:///modules/geste/openvpn/ca.crt";
    "/etc/openvpn/ca/keys/dh1024.pem":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0644,
      require => File["/etc/openvpn/ca/keys"],
      source  => "puppet:///modules/geste/openvpn/dh1024.pem";
    "/etc/openvpn/ta.key":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0600,
      require => Package["openvpn"],
      source  => "puppet:///modules/geste/openvpn/ta.key";
  }

  file {"/etc/openvpn/ca/easy-rsa":
    ensure  => directory,
    source  => "file:///usr/share/doc/openvpn/examples/easy-rsa/1.0",
    recurse => true,
    replace => false,
    require => File["/etc/openvpn/ca"],
  }

  file {"/etc/openvpn/ca/easy-rsa/vars":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0755,
    require => File["/etc/openvpn/ca/easy-rsa"],
    source  => "puppet:///modules/geste/openvpn/easy-rsa.vars",
  }

  file {"/etc/openvpn/ca/openssl.cnf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0755,
    require => File["/etc/openvpn/ca"],
    source  => "puppet:///modules/geste/openvpn/openssl.cnf",
  }

  file {"/etc/openvpn/ca/skel/geste.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    source  => "puppet:///modules/geste/openvpn/skel/geste.conf",
    require => File["/etc/openvpn/ca/skel"],
  }

  file {"/etc/openvpn/ca/skel/ta.key":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    source  => "puppet:///modules/geste/openvpn/ta.key",
    require => File["/etc/openvpn/ca/skel"],
  }


  openvpn::server::config {"geste":
    ensure  => present,
    on_boot => true,
    source  => 'puppet:///modules/geste/openvpn/geste.conf',
  }
}
