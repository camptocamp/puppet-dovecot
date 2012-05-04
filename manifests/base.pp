/*

== class: dovecot::base
Please do not include this class as is, it won't work!

*/
class dovecot::base {
  if ($dovecot_auth_ldap and $dovecot_auth_pam and $dovecot_auth_database) {
    fail 'Please provide either $dovecot_auth_ldap OR $dovecot_auth_pam OR $dovecot_auth_database'
  }

  if !( $dovecot_auth_ldap or $dovecot_auth_pam or $dovecot_auth_database) {
    fail 'Please provide either $dovecot_auth_ldap or $dovecot_auth_pam or $dovecot_auth_database'
  }

  if ($dovecot_auth_ldap and ! ($dovecot_ldap_host or $dovecot_ldap_uri )) {
    fail 'Please provide either $dovecot_ldap_host or $dovecot_ldap_uri'
  }

  include dovecot::params

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

  case $dovecot::params::version {
    1: {
      common::concatfilepart {"000-dovecot-init":
        file    => "/etc/dovecot/dovecot.conf",
        content => template("dovecot/dovecot-base-1.x.conf.erb"),
      }
      file {"/etc/dovecot/dovecot.conf.d":
        purge   => true,
        recurse => true,
        force   => true,
        backup  => false,
      }
    }
    2: {
      file {"/etc/dovecot/dovecot.conf":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 0644,
        notify  => Exec["reload dovecot"],
        content => template("dovecot/dovecot-base-2.x.conf.erb"),
      }
    }
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

  dovecot::configuration {"auth":
    ensure  => present,
    content => template("dovecot/dovecot-auth.conf.erb"),
  }

  dovecot::configuration {"mbox":
    ensure  => present,
    content => template("dovecot/dovecot-mbox.conf.erb"),
  }

  if $dovecot_ssl_enabled {
    dovecot::configuration {"ssl":
      ensure  => present,
      content => template("dovecot/dovecot-ssl.conf.erb"),
    }
  }

  dovecot::configuration{"protocol-imap":
    ensure  => present,
    content => template("dovecot/dovecot-proto-imap.conf.erb"),
  }

  dovecot::configuration {"protocol-pop3":
    ensure  => present,
    content => template("dovecot/dovecot-proto-pop3.conf.erb"),
  }

  if $dovecot_auth_pam {
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

  if $dovecot_auth_ldap {
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

  if $dovecot_auth_database {
    file {"/etc/dovecot/conf.d/auth-database.ext":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0644,
      notify  => Exec["reload dovecot"],
      require => File["/etc/dovecot/conf.d"],
      content => template("dovecot/dovecot-auth-database.ext.erb"),
    }

    file {"/etc/dovecot/sql.conf.ext":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0644,
      notify  => Exec["reload dovecot"],
      require => File["/etc/dovecot/conf.d"],
      content => template("dovecot/dovecot-sql.conf.ext.erb"),
    }
  }

}
