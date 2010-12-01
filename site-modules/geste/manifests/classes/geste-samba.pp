class geste::samba {

  include samba::server
  include smbldap

  exec {"set ldap admin password":
    command => "smbpasswd -w $ldap_admin_password && touch /etc/ldap/smbldap.done",
    unless  => "test -f /etc/ldap/smbldap.done",
  }


  package {["samba-tools"]:
    ensure => present,
  }

  common::concatfilepart {"000-smb.conf":
    ensure => present,
    file   => "/etc/samba/smb.conf",
    notify  => Service["samba"],
    content => template("geste/000-smb.conf.erb"),
  }
  
  samba::share {"homes":
    ensure => present,
    comment        => "repertoire de %U, %u",
    path           => "/srv/home/%U",
    read_only      => "no",
    create_mask    => 0644,
    directory_mask => 0755,
    browsable      => "no",
  }

  samba::share {"Administration":
    ensure         => present,
    path           => "/srv/Administration",
    read_only      => "no",
    create_mask    => 0770,
    directory_mask => 0770,
    browsable      => "yes",
    smb_options    => ["valid users = @'Domain Users'", "force group = 'Domain Users'"],
  }

  samba::share {"Engineering":
    ensure         => present,
    path           => "/srv/Engineering",
    read_only      => "no",
    create_mask    => 0770,
    directory_mask => 0770,
    browsable      => "yes",
    smb_options    => ["valid users = @'Domain Users'", "force group = 'Domain Users'"],
  }

  samba::share {"Computations":
    ensure         => present,
    path           => "/srv/Computations",
    read_only      => "no",
    create_mask    => 0770,
    directory_mask => 0770,
    browsable      => "yes",
    smb_options    => ["valid users = @'Domain Users'", "force group = 'Domain Users'"],
  }

  samba::share {"Tools":
    ensure         => present,
    path           => "/srv/Tools",
    read_only      => "no",
    create_mask    => 0770,
    directory_mask => 0770,
    browsable      => "yes",
    smb_options    => ["valid users = @'Domain Users'", "force group = 'Domain Users'"],
  }

  samba::share {"Public":
    ensure       => present,
    path         => "/srv/Public",
    read_only    => "no",
    create_mask  => 2664,
    browsable    => "yes",
    smb_options  => ["inherit permission = yes", "valid users = @'Domain Users'", "force group = 'Domain Users'"],
  }

}
