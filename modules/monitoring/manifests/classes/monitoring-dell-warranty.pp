/*

== Class: monitoring::dell::warranty
Monitors Dell related stuff:
- warranty information fetched from dell's website.

See http://gitorious.org/smarmy/check_dell_warranty

*/
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

