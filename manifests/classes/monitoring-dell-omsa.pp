/*

== Class: monitoring::dell::omsa
Monitors Dell related stuff:
- whatever openmanage has to say

See http://folk.uio.no/trondham/software/check_openmanage.html

Requires:
Module Dell git://github.com/camptocamp/puppet-dell.git

*/
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
