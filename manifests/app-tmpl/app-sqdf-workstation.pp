class app-sqdf-workstation {

  include java::v6
  include apt::unattended-upgrade::automatic

  # default root account
  #user {"root":
  #  ensure   => present,
  #  password => '$1$8a.Bg78Q$VP3nFU5O41o5ATGg10Weq.',
  #  shell    => "/bin/bash"
  #}

  file {"/usr/share/desktop-directories/vnd.openxmlformats-officedocument.wordprocessingml.document.desktop":
    ensure => present,
    source => "puppet:///modules/c2c/sqdf/vnd.openxmlformats-officedocument.wordprocessingml.document.desktop",
  }

  # Sudoers
  common::concatfilepart {"sqdf sudoers":
    file  => "/etc/sudoers",
    ensure  => present,
    content => "# SQDF specific rules
User_Alias  ADMIN = subilia,camptocamp,sysadmin
ADMIN   ALL=(root) NOPASSWD:ALL",
  }

  # Hostname set by DHCP
  file {"/etc/dhcp3/dhclient-exit-hooks.d/hostname":
    ensure => present,
    source => "puppet:///modules/c2c/sqdf/dhclient-exit-hooks-hostname",
  }

  # NFS /home
  mount {"/home":
    ensure  => mounted,
    device  => "artemis:/home",
    fstype  => "nfs",
    options => "defaults,rw",
    require => Package["nfs-common"],
  }

  # Cups
  file {"/etc/cups/client.conf":
    ensure => present,
    content => "ServerName artemis.sqdf\n",
  }


  ## LDAP authentication

  file {"/var/cache/debconf/ldap-auth-config.preseed":
    source => "puppet:///modules/c2c/sqdf/ldap-auth-config.preseed",
  }

  package {"ldap-auth-config":
    ensure       => installed,
    responsefile => "/var/cache/debconf/ldap-auth-config.preseed",
    require      => File["/var/cache/debconf/ldap-auth-config.preseed"],
  }
  package {"libpam-ldap":
    ensure  => present,
    require => Package["ldap-auth-config"],
  }

  file {"/etc/nsswitch.conf":
    ensure => present,
    source => "puppet:///modules/c2c/sqdf/ldap-nsswitch.conf",
    notify => Exec["restart nscd"],
  }
  exec {"restart nscd":
    command     => "/etc/init.d/nscd restart",
    refreshonly => true,
  }


  # Additional sources.list

  apt::sources_list{"medibuntu":
    ensure => present,
    source => "puppet:///modules/c2c/sqdf/medibuntu.lucid.sources.list",
  }

  exec{"Add ppa kubuntu repository":
    command => "add-apt-repository ppa:kubuntu-ppa/ppa",
    creates => "/etc/apt/sources.list.d/kubuntu-ppa-ppa-lucid.list",
  }
  file{"/etc/apt/sources.list.d/kubuntu-ppa-ppa-lucid.list":
    ensure  => present,
    require => Exec["Add ppa kubuntu repository"],
  }

  if $subilia_bluetooth_kbd != "" {
    # bluetooth configuration
    file {"/root/bluetooth.tar.gz":
      source => "puppet:///modules/c2c/sqdf/bluetooth_subilia.tar.gz",
    }
    exec {"install bt config-files":
      command => "tar zxfp /root/bluetooth.tar.gz -C /",
      unless => "grep -r 'MX5000' /var/lib/bluetooth/*",
      require => File["/root/bluetooth.tar.gz"],
    }
  }

}
