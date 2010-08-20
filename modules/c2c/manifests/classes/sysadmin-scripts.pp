class c2c::sysadmin-scripts {
  file {"/usr/local/bin":
    source => "puppet:///c2c/usr/local/bin",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/ldap-backup.sh":
    source => "puppet:///c2c/usr/local/bin/ldap-backup.sh",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/conntrack-viewer":
    source => "puppet:///c2c/usr/local/bin/conntrack-viewer",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/check_megasas.py":
    source => "puppet:///c2c/usr/local/bin/check_megasas.py",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/c2cpasswd.py":
    source => "puppet:///c2c/usr/local/bin/c2cpasswd.py",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/chkdebsums.sh":
    source => "puppet:///c2c/usr/local/bin/chkdebsums.sh",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/check_megarc.pl":
    source => "puppet:///c2c/usr/local/bin/check_megarc.pl",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/qmHandle":
    source => "puppet:///c2c/usr/local/bin/qmHandle",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/cryptout.pl":
    source => "puppet:///c2c/usr/local/bin/cryptout.pl",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/check_ldap_integrity.sh":
    source => "puppet:///c2c/usr/local/bin/check_ldap_integrity.sh",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/check_megaraid2.pl":
    source => "puppet:///c2c/usr/local/bin/check_megaraid2.pl",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/check_smartmon":
    source => "puppet:///c2c/usr/local/bin/check_smartmon",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/queue-fix":
    source => "puppet:///c2c/usr/local/bin/queue-fix",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/clean-svn.sh":
    source => "puppet:///c2c/usr/local/bin/clean-svn.sh",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/check_afaraid.pl":
    source => "puppet:///c2c/usr/local/bin/check_afaraid.pl",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/check_linux_raid.pl":
    source => "puppet:///c2c/usr/local/bin/check_linux_raid.pl",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/check_ipmi.pl":
    source => "puppet:///c2c/usr/local/bin/check_ipmi.pl",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/check_apachectl":
    source => "puppet:///c2c/usr/local/bin/check_apachectl",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/bin/ldap-gpg-fingerprint.py":
    source => "puppet:///c2c/usr/local/bin/ldap-gpg-fingerprint.py",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/sbin/make-chroot-from-veid.sh":
    source => "puppet:///c2c/usr/local/sbin/make-chroot-from-veid.sh",
    ensure => present,
    mode => 0755,
  }
  file {"/usr/local/sbin/addc2cuser.py":
    source => "puppet:///c2c/usr/local/sbin/addc2cuser.py",
    ensure => present,
    mode => 0755,
  }
}
