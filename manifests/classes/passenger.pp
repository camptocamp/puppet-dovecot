
# you'll probably want to include "ruby::gems" along with this

class ruby::passenger {

  if ( ! $passenger_version ) {
    $passenger_version = "2.2.2"
  }
  $passenger_root = $operatingsystem ? {
    RedHat => "/usr/lib/ruby/gems/1.8/gems/passenger-${passenger_version}",
    # Debian => TODO
  }

  package { "passenger":
    ensure   => $passenger_version,
    provider => "gem",
    require  => Package["ruby-dev"],
  }

}

class ruby::passenger::apache inherits ruby::passenger {

  package { "apache-dev":
    ensure => present,
    name   => $operatingsystem ? {
      RedHat => "httpd-devel",
      Debian => "apache2-threaded-dev",
    },
  }

  exec { "install passenger":
    command     => "${passenger_root}/bin/passenger-install-apache2-module --auto",
    subscribe   => Package["passenger"],
    refreshonly => true,
    require     => Package[["passenger", "apache-dev"]],
  }

  file { "passenger.load":
    ensure  => present,
    mode    => 0644,
    owner   => "root",
    group   => "root",
    seltype => "httpd_config_t",
    name    => $operatingsystem ? {
      RedHat => "/etc/httpd/mods-available/passenger.load",
      Debian => "/etc/apache2/mods-available/passenger.load",
    },
    require => [Exec["install passenger"], Package["apache"]],
    content => "# file managed by puppet
LoadModule passenger_module ${passenger_root}/ext/apache2/mod_passenger.so
PassengerRoot ${passenger_root}
PassengerRuby /usr/bin/ruby
",
  }

}

class ruby::passenger::nginx inherits ruby::passenger {
    # TODO: passenger-install-nginx-module --auto
}
