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
    command  => "check_password.sh",
    base     => '$USER2$/',
    options  => "root c2c",
    interval => "720", # 12h
    retry    => "120",
    type     => "passive",
    server   => $nagios_nsca_server,
    require  => File["/opt/nagios-plugins/check_password.sh"],
  }
}
