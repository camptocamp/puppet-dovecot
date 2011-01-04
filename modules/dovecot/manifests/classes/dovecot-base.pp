class dovecot::base {
  if ($dovecot_ldap and $dovecot_pam) {
    fail 'Please provide either $dovecot_ldap OR $dovecot_pam'
  }

  if !( $dovecot_ldap or $dovecot_pam) {
    fail 'Please provide either $dovecot_ldap or $dovecot_pam'
  }

  if ! ($dovecot_ldap_host or $dovecot_ldap_uri ) {
    fail 'Please provide either $dovecot_ldap_host or $dovecot_ldap_uri"'
  }

  group {"dovecot":
    allowdupe => false,
    ensure    => present,
    gid       => 201,
  }

  user {"dovecot":
    allowdupe => false,
    comment   => "Dovecot mail server",
    ensure    => present,
    gid       => 201,
    uid       => 201,
    home      => "/usr/lib/dovecot",
    shell     => "/bin/false",
    require   => Group["dovecot"],
  }

  package {"Dovecot":
    ensure => present,
    require => [ User["dovecot"], Group["dovecot"] ], 
  }

  package {"Dovecot IMAP":
    ensure => present,
    require => [ User["dovecot"], Group["dovecot"] ], 
  }

  package {"Dovecot POP3":
    ensure => present,
    require => [ User["dovecot"], Group["dovecot"] ], 
  }

  service {"dovecot":
    enable  => true,
    ensure  => running,
    require => Package["Dovecot"],
  }

  exec {"reload dovecot":
    command => "/etc/init.d/dovecot reload",
    onlyif  => "dovecot -n &>/dev/null",
    refreshonly => true,
  }


  file {"/etc/dovecot":
    ensure => directory,
    mode   => 0755,
    owner  => root,
    group  => root,
    require => Package["Dovecot"],
    purge   => true,
    recurse => true,
    force   => true,
  }

  file {"/etc/dovecot/dovecot.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    notify  => Exec["reload dovecot"],
    content => template("dovecot/dovecot-base.conf.erb"),
  }

  file {"/etc/dovecot/conf.d":
    ensure => directory,
    mode   => 0755,
    owner  => root,
    group  => root,
    require => Package["Dovecot"],
    purge   => true,
    recurse => true,
    force   => true,
  }

  file {"/etc/dovecot/conf.d/auth.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    notify  => Exec["reload dovecot"],
    require => File["/etc/dovecot/conf.d"],
    content => template("dovecot/dovecot-auth.conf.erb"),
  }

  file {"/etc/dovecot/conf.d/mbox.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    notify  => Exec["reload dovecot"],
    require => File["/etc/dovecot/conf.d"],
    content => template("dovecot/dovecot-mbox.conf.erb"),
  }

  file {"/etc/dovecot/conf.d/ssl.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    notify  => Exec["reload dovecot"],
    require => File["/etc/dovecot/conf.d"],
    content => template("dovecot/dovecot-ssl.conf.erb"),
  }

  file {"/etc/dovecot/conf.d/protocol-imap.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    notify  => Exec["reload dovecot"],
    require => File["/etc/dovecot/conf.d"],
    content => template("dovecot/dovecot-proto-imap.conf.erb"),
  }

  file {"/etc/dovecot/conf.d/protocol-pop3.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    notify  => Exec["reload dovecot"],
    require => File["/etc/dovecot/conf.d"],
    content => template("dovecot/dovecot-proto-pop3.conf.erb"),
  }

  if $dovecot_pam {
    file {"/etc/dovecot/conf.d/auth-pam.ext":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0644,
      notify  => Exec["reload dovecot"],
      require => File["/etc/dovecot/conf.d"],
      content => template("dovecot/dovecot-auth-pam.ext.erb"),
    }
  }

  if $dovecot_ldap {
    file {"/etc/dovecot/conf.d/auth-ldap.ext":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0644,
      notify  => Exec["reload dovecot"],
      require => File["/etc/dovecot/conf.d"],
      content => template("dovecot/dovecot-auth-ldap.ext.erb"),
    }
    file {"/etc/dovecot/dovecot-ldap.conf.ext":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0600,
      notify  => Exec["reload dovecot"],
      content => template("dovecot/dovecot-ldap.conf.ext.erb"),
    }
  }

}
