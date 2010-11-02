class app-nimag-sqdf2 {

  include mysql::server
  include openldap::server::ssl
  include monitoring::ldap
  include rdiff-backup::client

  include postfix
  postfix::virtual {"@sqdf2.vserver.nimag.net":
    ensure => present,
    destination => "sqdf.sysadmin@camptocamp.com",
  }

  postfix::hash { "/etc/postfix/virtual":
    ensure => present,
  }

  file {"/etc/ldap/config.ldif":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    source  => "puppet:///modules/avocatsch/ldap/config.ldif",
    require => Class["openldap::server::ssl"],
  }

  file {"/etc/ldap/slapd.conf.old":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    source  => "puppet:///modules/avocatsch/ldap/slapd.conf.old",
    require => Class["openldap::server::ssl"],
  }

  file {"/etc/ldap/schema/authldap.schema":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    source  => "puppet:///modules/avocatsch/ldap/authldap.schema",
    require => Class["openldap::server::ssl"],
  }
  
  file {"/etc/ldap/ssl/ldap.crt":
    ensure  => present,
    mode    => 0644,
    owner   => openldap,
    group   => openldap,
    source  => "puppet:///modules/avocatsch/ldap/ssl/ldap.crt",
    require => Class["openldap::server::ssl"],
    notify  => Service["slapd"],
  }
  
  file {"/etc/ldap/ssl/ldap.key":
    ensure  => present,
    mode    => 0600,
    owner   => openldap,
    group   => openldap,
    source  => "puppet:///modules/avocatsch/ldap/ssl/ldap.key",
    require => Class["openldap::server::ssl"],
    notify  => Service["slapd"],
  }
  
  file {"/etc/ldap/DB_CONFIG":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    source  => "puppet:///modules/avocatsch/ldap/DB_CONFIG",
    require => Class["openldap::server::ssl"],
  }

  file {"/usr/local/sbin/ldap-sync.sh":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0755,
    source => "puppet:///modules/avocatsch/ldap/ldap-sync.sh",
  }

  ssh_authorized_key {"rdiff-backup on backup-sqdf":
    ensure  => present,
    user    => root,
    type    => 'ssh-rsa',
    options => ['command="/usr/bin/rdiff-backup --server"','no-pty','no-port-forwarding','no-X11-forwarding'],
    key     => "AAAAB3NzaC1yc2EAAAABIwAAAIEAz2Pd5Sn8AzrHV16hIGgdaCtjUt/ql9ob1rMSqvN9pP5dvs89wGWx8IxygqCpONYyn8QxDNYp7M8Daj9R+Y3o2dbWOxOHV0HZKYq+SJ8qGtO6If0b++J5FGBrOaorL+i5XdWlfurjQ//w9l9CZnkX6qqel6Pezrv/GMQ8xPOTMz8=",
  }

  ssh_authorized_key {"root on artemis - ldap-sync":
    ensure  => present,
    user    => root,
    type    => 'ssh-dss',
    options => ['no-port-forwarding','no-X11-forwarding'],
    key     => "AAAAB3NzaC1kc3MAAACBANqJszXYn3lufHhJRL+8iIndQxX9Eb+o+ODQTyu7nD2gxQvHfQxoXZnBUa8sbR/Hg56o+gbf6xMZKj5fPyVB3SavDKhB78rkMcjxQk4BCQINtsPTb9QLPNPrLfCgHtqOxqm/D3LcueohbtgMhtg1lyKXLASurDjG36TCqcXf3CjXAAAAFQDC94U4f9YZPx/JFbptEYt5gM3bZwAAAIAp5PrWkbWBSZ/3ScCQIYLok+21dX+maU4Lfzo6TvdUnoGnGQsnhjs+/zjFGxByfz72dUjSCTfCJpxWdThgQKXEPpQJ4AZnQcN107oYsWxPdhDmJbinNXe1FHjNiCrm6ATZob3RJBVDOjdzraOngymfXBvXZ0fQV4NSAC0Wjv/WbQAAAIEAmVbauTtktcJk6k1iOI/OhaIThdLcw86NNNcoLLpSGrhY+SyJtQY4gFnxCHQuBV5dZmMmT+39ZexUXwAH7d2m0fVT8XB9XLdZeqUujaVRk2vDAIxYAmL/nGFPj4Z0df/RoRW5oDGHwC0qwwUezBhJYldIoC1pGceEPUf7Wb3j0+Q=",
  }
  
  augeas {"configure slapd defaults":
    context => "/files/etc/default/slapd/",
    notify  => Service["slapd"],
    changes => ["set SLAPD_SERVICES  'ldap://127.0.0.1:389/'"],
    require => Class["openldap::server::ssl"],
  }
  
  augeas {"configure ldap client":
    context => "/files/etc/ldap/ldap.conf",
    changes => [
      "set BASE 'dc=${slapd_domain}'",
      "set URI 'ldap://localhost'"
    ],
  }

  group {"etude":
    ensure => present,
    gid    => 507,
  }

  group {"subilia":
    ensure => present,
    gid    => 500,
  }

  user {"subilia":
    ensure  => present,
    shell   => "/bin/bash",
    home    => "/home/subilia",
    groups  => ["www-data", "etude"],
    uid     => 500,
    gid     => 500,
    require => Group['etude', 'subilia'],
    managehome => true,
  }

  file {"/home/subilia/.my.cnf":
    ensure  => present,
    owner   => subilia,
    group   => subilia,
    mode    => 0600,
    source  => "file:///root/.my.cnf",
    require => User["subilia"],
  }

  ssh_authorized_key {"olivier.subilia@avocats-ch.ch":
    ensure => present,
    user   => "subilia",
    type   => "ssh-rsa",
    key    => "AAAAB3NzaC1yc2EAAAABIwAAAQEA0ceIdQBMkyvmrqYHY9OA4hOcsQekIr6aMh3jxpaGGHatZgcPN7Pe3vXC5ivLidlKVuDcfY3eDEywEMQpo+H+gdjsMvrs/k+vOziXQegtQ1OCo5mhmP1nByeG9joRQErHYGrEZfxdh9wz52j44OubEWsD/6Sw01GSDnU2G34/Q0Zdx/4knll/qpoEKqHFP1CfgZqsWmquZALP02s97cNPg8Yzya+unk7X149Pr0aiP4LNIWvwej8wFi+P/i6DwGNAtx/jOsBFkdBHhn6M77+I3NSY95V2c1gyocsXR3T1scBu34IYRGT3q7Whv1uMJwpquPgTitTVV01moFI4rviX7Q==",
  }

  common::concatfilepart {"sudoers.subilia":
    ensure => present,
    file   => "/etc/sudoers",
    content => "subilia ALL=(ALL) /usr/sbin/a2ensite, /usr/sbin/a2enmod, /usr/sbin/a2dismod, /usr/sbin/a2dissite, /bin/su -, /bin/su\n",
  }

  file {"/etc/apache2/sites-available":
    ensure => directory,
    owner  => subilia,
    group  => subilia,
    mode   => 0755,
  }

  file {"/var/www/vhosts":
    ensure => directory,
    owner  => subilia,
    group  => www-data,
    mode   => 0755,
  }

}
