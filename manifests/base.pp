# == class: dovecot::base
#
# Please do not include this class as is, it won't work!
#
class dovecot::base {

  include dovecot::params

  group {'dovecot':
    ensure    => present,
    allowdupe => false,
    gid       => 201,
  }

  user {'dovecot':
    ensure    => present,
    allowdupe => false,
    comment   => 'Dovecot mail server',
    gid       => 201,
    uid       => 201,
    home      => '/usr/lib/dovecot',
    shell     => '/bin/false',
    require   => Group['dovecot'],
  }

  package {'Dovecot':
    ensure  => present,
    require => [ User['dovecot'], Group['dovecot'] ],
  }

  package {'Dovecot IMAP':
    ensure  => present,
    require => [ User['dovecot'], Group['dovecot'] ],
  }

  package {'Dovecot POP3':
    ensure  => present,
    require => [ User['dovecot'], Group['dovecot'] ],
  }

  service {'dovecot':
    ensure  => running,
    enable  => true,
    require => Package['Dovecot'],
  }

  exec {'reload dovecot':
    command     => '/etc/init.d/dovecot reload',
    onlyif      => 'dovecot -n &>/dev/null',
    refreshonly => true,
  }


  file {'/etc/dovecot':
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => root,
    require => Package['Dovecot'],
    purge   => true,
    recurse => true,
    force   => true,
  }

  concat {'/etc/dovecot/dovecot.conf':
    owner => root,
    group => root,
    mode  => '0644',
  }

  case $dovecot::params::version {
    1: {
      concat::fragment {'000-dovecot-init':
        target  => '/etc/dovecot/dovecot.conf',
        content => template('dovecot/dovecot-base-1.x.conf.erb'),
      }
      file {'/etc/dovecot/dovecot.conf.d':
        purge   => true,
        recurse => true,
        force   => true,
        backup  => false,
      }
    }
    2: {
      file {'/etc/dovecot/dovecot.conf':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        notify  => Exec['reload dovecot'],
        content => template('dovecot/dovecot-base-2.x.conf.erb'),
      }
    }
    default: {
      fail("Version ${dovecot::params::version} is not supported")
    }
  }

  file {'/etc/dovecot/conf.d':
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => root,
    require => Package['Dovecot'],
    purge   => true,
    recurse => true,
    force   => true,
  }

  dovecot::configuration {'auth':
    ensure  => present,
    content => template('dovecot/dovecot-auth.conf.erb'),
  }

  dovecot::configuration {'mbox':
    ensure  => present,
    content => template('dovecot/dovecot-mbox.conf.erb'),
  }

  if $::dovecot::dovecot_ssl_enabled {
    dovecot::configuration {'ssl':
      ensure  => present,
      content => template('dovecot/dovecot-ssl.conf.erb'),
    }
  }

  dovecot::configuration{'protocol-imap':
    ensure  => present,
    content => template('dovecot/dovecot-proto-imap.conf.erb'),
  }

  dovecot::configuration {'protocol-pop3':
    ensure  => present,
    content => template('dovecot/dovecot-proto-pop3.conf.erb'),
  }

  if $::dovecot::dovecot_auth_ldap {
    file {'/etc/dovecot/conf.d/auth-ldap.ext':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      notify  => Exec['reload dovecot'],
      require => File['/etc/dovecot/conf.d'],
      content => template('dovecot/dovecot-auth-ldap.ext.erb'),
    }
    file {'/etc/dovecot/dovecot-ldap.conf.ext':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0600',
      notify  => Exec['reload dovecot'],
      content => template('dovecot/dovecot-ldap.conf.ext.erb'),
    }
  }

}
