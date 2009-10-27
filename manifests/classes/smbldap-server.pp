class samba::smbldap-server inherits samba::server {
  file {"/etc/samba/smb.conf":
    content => template("samba/smb.conf.erb"),
    mode    => 0644, 
    owner   => root, 
    group   => root,
    require => [ Class["openldap::smbldap-server"], Package[samba] ],
    notify  => [ Service[samba], Exec["set ldap admin password"] ],
  }

  exec {"set ldap admin password":
    command => "smbpasswd -w $ldap_admin_password && touch /etc/ldap/smbldap.done",
    unless  => "test -f /etc/ldap/smbldap.done",
  }
}
