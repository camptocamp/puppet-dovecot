class puppet::master::mongrel inherits puppet::master {
  include apache::base

  # gem install is such a pain !
  #package {"mongrel":
  #  ensure   => latest,
  #  provider => "gem",
  #}

  exec {"install-mongrel":
    command => "echo 2 | gem install  --version 1.1.1 --include-dependencies mongrel",
    creates => "/var/lib/gems/1.8/gems/mongrel-1.1.1",
    require => Package["rubygems"],
  }

  file {"/etc/apache2-puppetmaster.conf":
    ensure  => present,
    content => template("puppet/apache2-puppetmaster.conf.erb"),
  }

  # Init scripts
  file {"/etc/default/puppetmaster":
    ensure  => present,
    content => template("puppet/puppetmaster-mongrel.default.erb"),
    notify  => Service["puppetmaster"],
  }

  file {"/etc/init.d/apache2-puppetmaster":
    ensure => present,
    source => "puppet:///puppet/apache2-puppetmaster.init",
    mode   => 755,
  }

  service {"apache2-puppetmaster":
    ensure => running,
  }
}
