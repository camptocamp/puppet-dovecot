class os-openvz {

  include openvz

  service {"iptables":
    ensure => stopped,
    enable => false,
  }

  file {"/vz":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0755,
  }

  mount {"/srv":
    ensure => absent,
  }

  mount {"/vz":
    ensure => mounted,
    device => "/dev/mapper/vg0-srv",
    fstype => auto,
    options => "defaults",
    require => [File["/vz"], Mount["/srv"]],
    before  => Package["vzctl.x86_64"],
  }

  file {"/var/lib/vz":
    ensure  => '/vz',
    require => Mount['/vz'],
  }

  file {"/usr/local/sbin/addVE.py":
    ensure => present,
    source => "puppet:///modules/c2c/usr/local/sbin/addVE.py",
    mode   => 0755,
    owner  => root,
    group  => root,
  }

  file {"/usr/local/sbin/toggle-ve-status.py":
    ensure => present,
    source => "puppet:///modules/c2c/usr/local/sbin/toggle-ve-status.py",
    mode   => 0755,
    owner  => root,
    group  => root,
  }

  cron {"toggle ve status":
    minute => "*/5",
    command => "/usr/local/sbin/toggle-ve-status.py",
    require => File["/usr/local/sbin/toggle-ve-status.py"],
  }

  file {"/usr/local/sbin/vznetaddbridge":
    ensure => present,
    source => "puppet:///modules/c2c/usr/local/sbin/vznetaddbridge",
    mode   => 0755,
    owner  => root,
    group  => root,
  }

  file {"/etc/vz/vznet.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    require => [File["/usr/local/sbin/vznetaddbridge"], Class["openvz::server"]],
    content => '#!/bin/sh
# File managed by Puppet
EXTERNAL_SCRIPT="/usr/local/sbin/vznetaddbridge"
',
  }

  common::archive::download {"debian-5.0-amd64-c2c.tar.gz":
    url => "http://sa.camptocamp.com/files/debian-5.0-amd64-c2c.tar.gz",
    src_target => "/vz/template/cache",
    require    => Mount["/vz"],
  }

  common::archive::download {"debian-6.0-amd64-c2c.tar.gz":
    url => "http://sa.camptocamp.com/files/debian-6.0-amd64-c2c.tar.gz",
    src_target => "/vz/template/cache",
    require    => Mount["/vz"],
  }

  # Please see http://wiki.openvz.org/Quick_installation#sysctl
  # for more informations about those settings.
  sysctl::set_value {
    "net.ipv4.ip_forward": value => "1";
    "net.ipv4.conf.default.proxy_arp": value => "0";
    "net.ipv4.conf.all.rp_filter": value => "1";
    "kernel.sysrq": value => "1";
    "net.ipv4.conf.default.send_redirects": value => "1";
    "net.ipv4.conf.all.send_redirects": value => "0";
  }

}
