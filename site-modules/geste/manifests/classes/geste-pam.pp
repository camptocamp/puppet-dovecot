class geste::pam {

  file {"/var/cache/debconf/libpam-ldap.preseed.erb":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0660,
    content => template("geste/libpam-ldap.preseed.erb"),
  }

  package {"libpam-ldap":
    ensure => present,
    require => File["/var/cache/debconf/libpam-ldap.preseed.erb"],
    responsefile => "/var/cache/debconf/libpam-ldap.preseed.erb",
  }

  file {"/var/cache/debconf/libnss-ldapd.preseed.erb":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0660,
    content => "# File managed by puppet
libnss-ldapd    libnss-ldapd/nsswitch   multiselect     group, passwd, shadow\n",
  }

  package {"libnss-ldapd":
    ensure  => present,
    require => [File["/var/cache/debconf/libnss-ldapd.preseed.erb"], Package["libpam-ldap"]],
    responsefile => "/var/cache/debconf/libnss-ldapd.preseed.erb",
  }

}
