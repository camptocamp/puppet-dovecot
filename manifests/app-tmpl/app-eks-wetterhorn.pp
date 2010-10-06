class app-eks-wetterhorn {
  include monitoring::raid::mdadm

  host {
    "eiger.eks":          ip => "192.168.99.2";
    "eiger":              ip => "192.168.99.2";
    "wetterhorn.eks.com": ip => "192.168.99.4";
    "wetterhorn":         ip => "192.168.99.4";
    "scheidegg":          ip => "10.10.10.2";
    "rp":                 ip => "10.10.10.5";
    "svn":                ip => "10.10.10.121";
    "mail":               ip => "10.10.10.123";
    "pe2500":             ip => "10.10.10.3";
    "app":                ip => "10.10.10.100";
    "appstage":           ip => "10.10.10.101";
    "home":               ip => "10.10.10.102";
    "id":                 ip => "10.10.10.103";
    "jungfrau":           ip => "62.2.237.75";
    "ecm":                ip => "192.168.99.6";
    "prod":               ip => "209.59.209.5";
  }

  user {"admin":
    ensure => present,
    shell  => "/bin/bash",
    home   => "/home/admin",
    groups => "adm",
    managehome => true,
  }

  ssh_authorized_key {"laurent.piguet@eks.com":
    ensure  => present,
    user    => admin,
    require => User["admin"],
    type    => "ssh-rsa",
    key     => "AAAAB3NzaC1yc2EAAAABJQAAAQB1bJTKd6lSkhqLJUOdBzYUMKJ/2Wv8C+roZ00bqHkkY8BXjywwc1fQeMBgcsDQjjOdA7IaThtVPVpqY5pyUX2Frpn8SoXpLElzwLHN1gSEZAx8Hhhe1gz/oW5KVuf89mSwCyStf7wdutddIEcfIUD19Q5QKubYIj8X0yqRQpCMaDm7DNKb6eJSUXmoyID87EwR27Sygjz4Kwp/kZdJ+AcxBodh+2LfrBPF0fpikrVV8TlvwKG6FTRCyhzLb6x0uExqVTckD0ccpbm0rRxLkU+CwreY1GMnUR6mNPsaR96Sc/eLQxYJOdK3jKxNQxGbaVqXeYoLHiAX+prYnr+9GhKJ",
  }

  common::concatfilepart {"sudo.admin":
    file => "/etc/sudoers",
    content => "# Managed by app-eks-wetterhorn
admin ALL=(ALL) NOPASSWD: /usr/local/bin/check-rdiff, /usr/local/sbin/sync-to-usb",
  }
}
