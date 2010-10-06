/*
== Class: monitoring::dell

Monitors Dell related stuff:
- whatever openmanage has to say
- warranty information fetched from dell's website.

See:
- http://folk.uio.no/trondham/software/check_openmanage.html
- http://gitorious.org/smarmy/check_dell_warranty

*/
class monitoring::dell {
  include monitoring::dell::omsa
  include monitoring::dell::snmp
  include monitoring::dell::warranty
}

class monitoring::dell::snmp {
  monitoring::check { "Dell OMSA-snmp bridge":
    codename => "check_dell_snmp",
    command  => "check_snmp",
    options  => "-H localhost -R 'dell' -o SNMPv2-SMI::enterprises.674.10892.1.300.10.1.8.1",
    interval => "120", # every 2h
    retry    => "60",  # every 1h
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => $operatingsystem ? {
      /RedHat|CentOS/  => "nagios-plugins-snmp",
      default => "libnet-snmp-perl",
    },
  }
}

class monitoring::dell::omsa {

  include monitoring::params

  $check_omsa_ver = "3.6.0"

  if (! $check_openmanage_opts) {
    $check_openmanage_opts = "--blacklist ctrl_fw=ALL/ctrl_driver=ALL"
  }

  # download and extract check_openmanage.tar.gz
  common::archive::tar-gz { "${monitoring::params::customplugins}/check_openmanage-${check_omsa_ver}":
    source  => "http://folk.uio.no/trondham/software/files/check_openmanage-${check_omsa_ver}.tar.gz",
    target  => "${monitoring::params::customplugins}",
    require => File["${monitoring::params::customplugins}"],
  }

  file { "${monitoring::params::customplugins}/check_openmanage-${check_omsa_ver}/check_openmanage":
    mode    => 0755,
    owner   => "root",
    group   => "root",
    require => Common::Archive::Tar-gz["${monitoring::params::customplugins}/check_openmanage-${check_omsa_ver}"],
  }

  file { "${monitoring::params::customplugins}/check_openmanage":
    ensure  => link,
    target  => "${monitoring::params::customplugins}/check_openmanage-${check_omsa_ver}/check_openmanage",
    require => File["${monitoring::params::customplugins}/check_openmanage-${check_omsa_ver}/check_openmanage"],
    before  => Monitoring::Check["Dell OMSA"],
  }

  # monitoring definition.

  monitoring::check { "Dell OMSA":
    codename => "check_omsa_status",
    command  => "check_openmanage",
    options  => $check_openmanage_opts,
    base     => "${monitoring::params::customplugins}",
    interval => "360", # every 6h
    retry    => "180", # every 3h
    type     => "passive",
    server   => $nagios_nsca_server,
  }

}

class monitoring::dell::warranty {
  include monitoring::params
  $check_warranty_ver = "9707a4b" # versions up to 2.0 seem to fail

  #TODO: use vcsrepo instead
  # download check_dell_warranty.py
  exec { "download check_dell_warranty.py version $check_warranty_ver":
    command => "curl http://gitorious.org/smarmy/check_dell_warranty/blobs/raw/${check_warranty_ver}/check_dell_warranty.py > ${monitoring::params::customplugins}/check_dell_warranty-${check_warranty_ver}",
    creates => "${monitoring::params::customplugins}/check_dell_warranty-${check_warranty_ver}",
    require => File["${monitoring::params::customplugins}"],
  }
  file { "${monitoring::params::customplugins}/check_dell_warranty-${check_warranty_ver}":
    mode    => 0755,
    owner   => "root",
    group   => "root",
    require => Exec["download check_dell_warranty.py version $check_warranty_ver"],
  }

  file { "${monitoring::params::customplugins}/check_dell_warranty.py":
    ensure  => link,
    target  => "${monitoring::params::customplugins}/check_dell_warranty-${check_warranty_ver}",
    require => File["${monitoring::params::customplugins}/check_dell_warranty-${check_warranty_ver}"],
    before  => Monitoring::Check["Dell Warranty"],
  }

  if $operatingsystem == "RedHat" and $lsbmajdistrelease == "4" {

    package { "readline.i386": ensure => present }

    package { "python2.4":
      ensure   => present,
      provider => "rpm",
      source   => "http://www.python.org/ftp/python/2.4/rpms/fedora-3/python2.4-2.4-1pydotorg.i386.rpm",
      before   => Monitoring::Check["Dell Warranty"],
      require  => Package["readline.i386"],
    }

    $python_prefix = "/usr/bin/python2.4"
  } else {
    $python_prefix = "/usr/bin/python"
  }


  monitoring::check { "Dell Warranty":
    codename => "check_dell_warranty",
    command  => "check_dell_warranty.py",
    options  => "--timeout 120",
    base     => "${python_prefix} ${monitoring::params::customplugins}",
    interval => "1440", # once a day
    retry    => "1440", # once a day
    type     => "passive",
    server   => $nagios_nsca_server,
  }
}
