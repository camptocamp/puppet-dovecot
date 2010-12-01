class smbldap::debian {
  package {"smbldap-tools":
    ensure => present,
  }

  file {"/etc/smbldap-tools/smbldap_bind.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0600,
    require => Package["smbldap-tools"],
    content => template("smbldap/smbldap_bind.conf.erb"),
  }

  case $localsid {
    '': {
        err("$fqdn: no \$localsid, not installing samba-common")
    }
    
    default: {
      file {"/etc/smbldap-tools/smbldap.conf":
        content => template("smbldap/smbldap.conf.erb"),
        mode    => 0644,
        owner   => root,
        group   => root,
        require => Package[smbldap-tools];
      }
    }
  }

  common::concatfilepart {"001-smb.conf":
    ensure => present,
    file   => "/etc/samba/smb.conf",
    content => template("smbldap/part.smb.conf.erb"),
  }


}
