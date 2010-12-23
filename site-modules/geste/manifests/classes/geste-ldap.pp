class geste::ldap {

  include openldap::server
  
  file {"/etc/ldap/slapd.conf.old":
    ensure  => present,
    mode    => 0644,
    owner   => root,
    group   => root,
    require => Class["openldap::server"],
    source  => "puppet:///modules/geste/ldap/slapd.conf.old",
  }

  file {"/etc/ldap/schema/samba.schema":
    ensure  => present,
    mode    => 0644,
    owner   => root,
    group   => root,
    require => Class["openldap::server"],
    source  => "puppet:///modules/geste/ldap/samba.schema",
  }

  augeas {"configure slapd defaults":
    context => "/files/etc/default/slapd/",
    notify  => Service["slapd"],
    require => Class["openldap::server"],
    changes => ["set SLAPD_SERVICES  'ldap:///'"],
  }

  augeas {"configure ldap client":
    context => "/files/etc/ldap/ldap.conf",
    require => Class["openldap::server"],
    changes => [
      "set BASE 'dc=ldap,dc=geste'",
      "set URI 'ldap://localhost'",
      "set LDAP_VERSION 3",
    ],
  }

  user {"openldap":
    ensure => present,
    home   => "/var/lib/ldap",
    shell  => "/bin/false",
    require => Package["slapd"],
  }

  user {"molteni":
    ensure => present,
    groups => "apache-admin",
    require => Service["slapd"],
  }

  if $geste_master {
    file {"/usr/local/sbin/ldap-sync":
      ensure => present,
      owner  => root,
      group  => root,
      mode   => 0700,
      source => "puppet:///modules/geste/ldap/ldap-sync.master",
    }
   
    cron {"sync ldap to slave":
      ensure => present,
      hour   => "3",
      minute => ip_to_cron(1),
      command => "/usr/local/sbin/ldap-sync",
      require => File["/usr/local/sbin/ldap-sync"],
    }
  } else { # slave
    file {"/usr/local/sbin/ldap-sync":
      ensure => present,
      owner  => root,
      group  => root,
      mode   => 0700,
      source => "puppet:///modules/geste/ldap/ldap-sync.slave",
    }
  }
}
