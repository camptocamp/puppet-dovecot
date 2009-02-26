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

  cron {"updates ssh keys from LDAP directory for c2cdev":
    command => "/usr/local/bin/ldap-ssh-pubkeys.py /var/lib/puppet/files/authorized_keys-autogen-c2cdev dev",
    user    => "root",
    hour    => "*",
    minute  => "0",
    require => File["/var/lib/puppet/files/authorized_keys-autogen-c2cdev"],
  }

  cron {"updates ssh keys from LDAP directory for everybody":
    command => "/usr/local/bin/ldap-ssh-pubkeys.py /var/lib/puppet/files/authorized_keys-autogen-everybody all",
    user    => "root",
    hour    => "*",
    minute  => "0",
    require => File["/var/lib/puppet/files/authorized_keys-autogen-everybody"],
  }
}
