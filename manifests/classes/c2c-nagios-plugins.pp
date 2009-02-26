class c2c::nagios::plugins {
  
  if ! defined(Package["nagios-plugins"]) {
    package {"nagios-plugins": ensure => present }
  }

  file {"/usr/lib/nagios/plugins/contrib/":
    ensure => directory,
  }
  file {"/usr/lib/nagios/plugins/contrib/check_raid":
    ensure => directory,
    require => [ Package["nagios-plugins"], File["/usr/lib/nagios/plugins/contrib/"] ],
  }

  file {"/usr/lib/nagios/plugins/contrib/check_raid/check_fusion_mpt":
    ensure => present,
    source => "puppet:///c2c/usr/lib/nagios/plugins/contrib/check_raid/check_fusion_mpt",
    require => File["/usr/lib/nagios/plugins/contrib/check_raid"],
    mode => 0755,
    owner => root,
  }

  file {"/usr/lib/nagios/plugins/contrib/check_raid/check_lsi_megaraid":
    ensure => present,
    source => "puppet:///c2c/usr/lib/nagios/plugins/contrib/check_raid/check_lsi_megaraid",
    require => File["/usr/lib/nagios/plugins/contrib/check_raid"],
    mode => 0755,
    owner => root,
  }

  file {"/usr/lib/nagios/plugins/contrib/check_raid/check_md_raid":
    ensure => present,
    source => "puppet:///c2c/usr/lib/nagios/plugins/contrib/check_raid/check_md_raid",
    require => File["/usr/lib/nagios/plugins/contrib/check_raid"],
    mode => 0755,
    owner => root,
  }

  file {"/usr/lib/nagios/plugins/contrib/check_raid/check_megaraid_sas":
    ensure => present,
    source => "puppet:///c2c/usr/lib/nagios/plugins/contrib/check_raid/check_megaraid_sas",
    require => File["/usr/lib/nagios/plugins/contrib/check_raid"],
    mode => 0755,
    owner => root,
  }

  file {"/usr/lib/nagios/plugins/contrib/check_raid/check_raid":
    ensure => present,
    source => "puppet:///c2c/usr/lib/nagios/plugins/contrib/check_raid/check_raid",
    require => File["/usr/lib/nagios/plugins/contrib/check_raid"],
    mode => 0755,
    owner => root,
  }

  file {"/usr/lib/nagios/plugins/contrib/check_raid/MegaCli":
    ensure => present,
    source => "puppet:///c2c/usr/lib/nagios/plugins/contrib/check_raid/MegaCli",
    require => File["/usr/lib/nagios/plugins/contrib/check_raid"],
    mode => 0755,
    owner => root,
  }

  file {"/usr/lib/nagios/plugins/contrib/check_raid/MegaCli64":
    ensure => present,
    source => "puppet:///c2c/usr/lib/nagios/plugins/contrib/check_raid/MegaCli64",
    require => File["/usr/lib/nagios/plugins/contrib/check_raid"],
    mode => 0755,
    owner => root,
  }

  file {"/usr/lib/nagios/plugins/contrib/check_raid/megarc.bin":
    ensure => present,
    source => "puppet:///c2c/usr/lib/nagios/plugins/contrib/check_raid/megarc.bin",
    require => File["/usr/lib/nagios/plugins/contrib/check_raid"],
    mode => 0755,
    owner => root,
  }

  file {"/usr/lib/nagios/plugins/contrib/check_ubc.pl":
    ensure => present,
    source => "puppet:///c2c/usr/lib/nagios/plugins/contrib/check_ubc.pl",
    mode => 0755,
    owner => root,
  }

  file {"/usr/lib/nagios/plugins/contrib/check_ubc_wrapper.sh":
    ensure => present,
    source => "puppet:///c2c/usr/lib/nagios/plugins/contrib/check_ubc_wrapper.sh",
    mode => 0755,
    owner => root,
  }
}
