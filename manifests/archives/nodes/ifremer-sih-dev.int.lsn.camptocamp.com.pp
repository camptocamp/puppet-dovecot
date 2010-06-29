node 'ifremer-sih-dev.int.lsn.camptocamp.com' {
  # The os module is unrolled here to modify only the File ["/usr/share/locale/locale.alias"] rule 
  # If you ever want to upgrade this host to debian lenny, you'll have to change the includes
  # and replace the copy-pasted class os::debian-etch below !

  #include os-c2c-dev

  $sync_authorized_keys_src = true
  #include os-c2c-extended
  include openldap::client
  include sudo::dev-managed
  include pam::ldap::public
  include nss::ldap

  #include os-c2c
  include postfix  # FIXME: spécifique camptocamp -> c2c::postfix
  include c2c::syslog::client
  include c2c::sysadmin-scripts

  #include os-base
  include c2c::puppet-client
  include c2c::sysadmin-in-charge
  include c2c::skel
  include ssh-old::base
  include pam::base

  #include os
  include apt
  include c2c::sysadmin-in-charge-new
  include apt::unattended-upgrade
  include sudo::base

  group {"sigdev":
    ensure => present,
  }

  file {"/var/sig":
    ensure  => directory,
    owner   => root,
    group   => sigdev,
    mode    => 2775,
    require => Group["sigdev"],
  }

  include myos

  class myos {

    file { "/tmp":
      ensure => directory,
      mode   => 1777,
      owner  => root,
      group  => root
    }

    include mydebian-etch
    include os::debian::backports
  }

  class mydebian inherits os::debian {
    File ["/usr/share/locale/locale.alias"] {
      replace => no,   # We wanted to modify THIS
    }
  }

  class mydebian-etch inherits mydebian {
    file { "/etc/apt/sources.list":
      ensure => absent,
      before => Exec["apt-get_update"],
    }
  
    apt::sources_list {"etch":
      source => "puppet:///os/etc/apt/sources.list.d/sources.list-debian-etch",
    }
  
    apt::sources_list {"c2c":
      source => "puppet:///os/etc/apt/sources.list.d/sources.list-c2c-etch",
    }
  
    apt::key {"5C662D02":
      source  => "http://dev.camptocamp.com/packages/pub.key",
    }
  
    # general config for emacs (without temporary files ~ )
    file { "/etc/emacs/site-start.d/50c2c.el":
      ensure => present,
      mode   => 644,
      source => "puppet:///os/etc/emacs/site-start.d/50c2c.el",
    }
  
    # Umask, etc.
    file { "/etc/profile":
      ensure => present,
      mode   => 644,
      source => "puppet:///os/etc/profile-etch",
    }
  
    # Timezone
    file { "/etc/localtime":
      ensure => present,
      source => "file:///usr/share/zoneinfo/Europe/Zurich",
    }
  
    file { "/etc/timezone":
      ensure  => present,
      content => "Europe/Zurich",
    }
  
    # Kernel
    file { "/etc/modules":
      ensure => present,
    }
  }

  include nfs::base
  c2c::nfsmount {"cartoweb":
    ensure => absent,
    share => "",
    client_options => "ro,vers=3,rsize=32768,wsize=32768,hard,proto=tcp,timeo=600,retrans=2,sec=sys",
  }
}
