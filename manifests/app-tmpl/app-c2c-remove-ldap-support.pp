class app-c2c-remove-ldap-support {

  package {["libpam-ldap","libnss-ldap","ldap-utils","nscd"]:
    ensure => purged,
    notify => [ 
      Exec["removed old nsswitch.conf"],
      Exec["remove old common-account"],
      Exec["remove old common-session"],
      Exec["remove old common-auth"],
      Exec["remove old common-password"],
      Exec["remove old pam ssh"],
      Exec["remove old pam sshd"]
    ] 
  }

  exec {"removed old nsswitch.conf":
    command     => "rm -f /etc/nsswitch.conf",
    onlyif      => "test -f /etc/nsswitch.conf",
    refreshonly => true,
  }

  file{"/etc/nsswitch.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 644,
    replace => false,
    source  => "/usr/share/base-files/nsswitch.conf",
    require => [ 
      Exec["removed old nsswitch.conf"], 
      Package["libpam-ldap"], 
      Package["libnss-ldap"], 
      Package["ldap-utils"],
      Package["nscd"]
    ],
  }

  exec {"remove old common-account":
    command     => "rm -f /etc/pam.d/common-account",
    onlyif      => "test -f /etc/pam.d/common-account",
    refreshonly => true,
  }

  exec {"remove old common-session":
    command     => "rm -f /etc/pam.d/common-session",
    onlyif      => "test -f /etc/pam.d/common-session",
    refreshonly => true,
  }

  exec {"remove old common-password":
    command     => "rm -f /etc/pam.d/common-password",
    onlyif      => "test -f /etc/pam.d/common-password",
    refreshonly => true,
  }

  exec {"remove old common-auth":
    command     => "rm -f /etc/pam.d/common-auth",
    onlyif      => "test -f /etc/pam.d/common-auth",
    refreshonly => true,
  }

  exec {"remove old pam ssh":
    command     => "rm -f /etc/pam.d/ssh",
    onlyif      => "test -f /etc/pam.d/ssh",
    refreshonly => true,
  }

  file {"/etc/pam.d/common-account":
    ensure  => present,
    owner   => root,
    group   => root,
    replace => false,
    source  => "/usr/share/pam/common-account",
    require => Exec["remove old common-account"],
    notify  => Exec["remove old pam ssh"],
  }

  file {"/etc/pam.d/common-session":
    ensure  => present,
    owner   => root,
    group   => root,
    replace => false,
    source  => "/usr/share/pam/common-session",
    require => Exec["remove old common-session"]
  }

  file {"/etc/pam.d/common-auth":
    ensure  => present,
    owner   => root,
    group   => root,
    replace => false,
    source  => "/usr/share/pam/common-auth",
    require => Exec["remove old common-auth"]
  }

  file {"/etc/pam.d/common-password":
    ensure  => present,
    owner   => root,
    group   => root,
    replace => false,
    source  => "/usr/share/pam/common-password",
    require => Exec["remove old common-password"]
  }

  exec {"remove old pam sshd":
    command     => "rm -f /etc/pam.d/sshd*",
    onlyif      => "test -f /etc/pam.d/sshd",
    refreshonly => true,
  }

  file {"/etc/pam.d/sshd":
    ensure  => present,
    owner   => root,
    group   => root,
    replace => false,
    content => "# PAM configuration for the Secure Shell service

# Read environment variables from /etc/environment and
# /etc/security/pam_env.conf.
auth       required     pam_env.so # [1]
# In Debian 4.0 (etch), locale-related environment variables were moved to
# /etc/default/locale, so read that as well.
auth       required     pam_env.so envfile=/etc/default/locale

# Standard Un*x authentication.
@include common-auth

# Disallow non-root logins when /etc/nologin exists.
account    required     pam_nologin.so

# Uncomment and edit /etc/security/access.conf if you need to set complex
# access limits that are hard to express in sshd_config.
# account  required     pam_access.so

# Standard Un*x authorization.
@include common-account

# Standard Un*x session setup and teardown.
@include common-session

# Print the message of the day upon successful login.
session    optional     pam_motd.so # [1]

# Print the status of the user's mailbox upon successful login.
session    optional     pam_mail.so standard noenv # [1]

# Set up user limits from /etc/security/limits.conf.
session    required     pam_limits.so

# Set up SELinux capabilities (need modified pam)
# session  required     pam_selinux.so multiple

# Standard Un*x password updating.
@include common-password
",  
  }

}
