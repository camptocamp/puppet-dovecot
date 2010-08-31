class puppet::master::passenger inherits puppet::master::base {

  if ( ! $puppetmaster_ssldir ) {
    $puppetmaster_ssldir = "/etc/puppet/ssl"
  }

  if ( ! $puppet_server ) {
    $puppet_server = $fqdn
  }

  if ( ! $wwwlogs ) {
    $wwwlogs = $operatingsystem ? {
      RedHat => "/var/log/httpd",
      Debian => "/var/log/apache2",
    }
  }

  if ( ! $wwwroot ) {
    $rack_location = "/etc/puppet/rack"
    $log_location = $operatingsystem ? {
      RedHat => "/var/log/httpd",
      Debian => "/var/log/apache2",
    }
  } else {
    $rack_location = "${wwwroot}/puppetmasterd/htdocs/rack"
    $log_location  = "${wwwroot}/puppetmasterd/logs"
  }

  if ( ! $rack_version ) {
    $rack_version = "1.0.0"
  }

  if ( ! $activerecord_version ) {
    $activerecord_version = "2.3.2"
  }

  # Increase apache's default timeout. If puppetmaster needs more time to
  # compile the catalog, it will fail with a "Broken pipe" error and inflict a
  # high load on the server.
  # workaround for puppet issue #2691
  if ( ! $puppetmaster_timeout ) {
    $puppetmaster_timeout = "600"
  }

  # Puppet 0.24.x compatibility mode
  if ( $puppetmaster_passenger_0_24 ) {
    notice "Activate Puppet 0.24.x compatibility mode"
    $rack_config_template = "puppet/config-0.24.ru.erb"
  } else {
    $rack_config_template = "puppet/config.ru.erb"
  }

  # other useful variables:
  # $puppetmaster_confdir: will be passed to "puppetmasterd --confdir "
  # $puppet_location: lookup path for puppet/lib

  include ruby::gems
  include ruby::passenger::apache
  include apache::ssl

  apache::module { ["headers", "passenger"]:
    ensure  => present,
    require => Class["ruby::passenger::apache"],
  }

  apache::vhost-ssl { "puppetmasterd":
    config_content => template("puppet/vhost-passenger.conf.erb"),
    mode           => "2755",
    user           => "root",
  }

  apache::listen { "8140": }

  file { [$rack_location, "${rack_location}/public", "${rack_location}/tmp"]:
    ensure => directory,
    mode   => 0755,
    owner  => "root",
    group  => "root",
  }

  file { "${rack_location}/config.ru":
    ensure  => present,
    content => template($rack_config_template),
    mode    => 0644,
    owner   => "puppet",
    group   => "root",
    require => [File["${rack_location}/public"], Apache::Vhost-ssl["puppetmasterd"]],
    notify  => Exec["apache-graceful"],
  }

  package { "activerecord":
    ensure   => $activerecord_version,
    provider => "gem",
    require  => Package["ruby-dev"],
  }

  package { "rack":
    ensure   => $rack_version,
    provider => "gem",
    require  => Package["ruby-dev"],
  }

  # puppetmaster is completely selinux unfriendly (in fact it's selinux which
  # is unfriendly with everyone else...)
  if $operatingsystem == "RedHat" {
    selboolean { "httpd_disable_trans":
      value      => "on",
      persistent => true,
      notify     => Service["apache"],
    }

  }

  # enable mpm-worker
  case $operatingsystem {
    RedHat: {
      augeas { "enable httpd mpm-worker":
        changes => "set /files/etc/sysconfig/httpd/HTTPD /usr/sbin/httpd.worker",
        require => Package["apache"],
        notify  => Service["apache"],
      }
    }
    Debian: {
      #TODO: install apache2-mpm-worker, deal with conflict in apache::debian
    }
  }

}
