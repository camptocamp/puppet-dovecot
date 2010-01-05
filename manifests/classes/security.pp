class monitoring::security {

  package { "expect": ensure => present }

  file { "/opt/nagios-plugins/check_password.sh":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => "0755",
    source => "puppet:///monitoring/check_password.sh",
    require => Package["expect"],
  }

  monitoring::check { "Default root password":
    codename => "check_root_password",
    command  => "check_procs",
    base     => '$USER2$/',
    options  => "root c2c",
    require  => File["/opt/nagios-plugins/check_password.sh"],
  }
}
