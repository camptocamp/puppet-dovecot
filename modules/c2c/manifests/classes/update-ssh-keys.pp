class c2c::update-ssh-keys {

  file { "/var/lib/puppet/files/authorized_keys-autogen-c2cdev":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 755,
  }

  file { "/var/lib/puppet/files/authorized_keys-autogen-everybody":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 755,
  }

  file { "/var/lib/puppet/files/authorized_keys-autogen":
    ensure => absent,
  }

  file { "/usr/local/bin/ldap-sadb-ssh-pubkeys.py":
    ensure => present,
    source => "puppet:///c2c/usr/local/bin/ldap-sadb-ssh-pubkeys.py",
    mode   => 0755,
  }

  cron {"updates ssh keys from LDAP directory and SADB for c2cdev":
    command => "/usr/local/bin/ldap-sadb-ssh-pubkeys.py /var/lib/puppet/files/authorized_keys-autogen-c2cdev dev",
    user    => "root",
    hour    => "*",
    minute  => "0",
    require => File["/usr/local/bin/ldap-sadb-ssh-pubkeys.py"],
    require => File["/var/lib/puppet/files/authorized_keys-autogen-c2cdev"],
  }

  cron {"updates ssh keys from LDAP directory and SADB for everybody":
    command => "/usr/local/bin/ldap-sadb-ssh-pubkeys.py /var/lib/puppet/files/authorized_keys-autogen-everybody all",
    user    => "root",
    hour    => "*",
    minute  => "0",
    require => File["/usr/local/bin/ldap-sadb-ssh-pubkeys.py"],
    require => File["/var/lib/puppet/files/authorized_keys-autogen-everybody"],
  }
}
