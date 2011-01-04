class geste::iptables {
  exec {"save iptables rules":
    command => "iptables-save > /etc/network/iptables",
  }

  Iptables {
    before => Exec["save iptables rules"],
    notify => Exec["save iptables rules"],
  }


  file { "/etc/puppet/iptables":
    ensure => directory,
    mode => 0700,
  }

  file { "/etc/puppet/iptables/pre.iptables":
    ensure  => present,
    require => File["/etc/puppet/iptables"],
    mode    => 0600,
    tag     => "aws-iptables",
    content => "# file managed by puppet
-A INPUT -s 128.179.66.4/32 -j ACCEPT
",
  }
  file { "/etc/puppet/iptables/post.iptables":
    ensure  => present,
    require => File["/etc/puppet/iptables"],
    mode    => 0600,
    content => "# file managed by puppet
-A INPUT -j DROP
",
  }

  iptables {
    "001 allow localhost":
      iniface => "lo",
      jump    => "ACCEPT",
      require => File["/etc/puppet/iptables/pre.iptables"];
    "002 allow related":
      state => "RELATED",
      jump => "ACCEPT";
    "003 allow established":
      state => "ESTABLISHED",
      jump => "ACCEPT";
    "004 ICMP from everywhere":
      proto => "icmp",
      icmp  => 8,
      jump  => "ACCEPT";
    "005 all from eth0 (lan only)":
      iniface => "eth0",
      source  => "192.168.12.1/24",
      jump    => "ACCEPT";
    "006 http and https on eth1:gestepc1":
      iniface => "eth1",
      proto   => "tcp",
      destination  => "128.179.67.100",
      dport   => [80,443],
      jump    => "ACCEPT";
    "006 openvpn on eth1:gestepc1":
      iniface => "eth1",
      proto   => "udp",
      destination  => "128.179.67.100",
      dport   => 1194,
      jump    => "ACCEPT";
    "007 ssh from gestepc3":
      iniface => "eth1",
      proto   => "tcp",
      dport   => 22,
      jump    => "ACCEPT",
      source  => "128.179.67.70";
    "007 ssh from gestepc4":
      iniface => "eth1",
      proto   => "tcp",
      dport   => 22,
      jump    => "ACCEPT",
      source  => "128.179.67.132";
    "007 ssh from gestepc1":
      iniface => "eth1",
      proto   => "tcp",
      dport   => 22,
      jump    => "ACCEPT",
      source  => "128.179.67.100";
  }

}
