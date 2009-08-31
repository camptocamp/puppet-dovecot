class puppet::master inherits puppet::master::base {

  package {
    "libdbd-sqlite3-ruby": ensure => present;
    "python-mysqldb": ensure => present;
  }

  # Custom functions
  file { "/usr/local/lib/site_ruby":
    ensure => directory,
  }

  file { "/usr/local/lib/site_ruby/puppet":
    ensure  => directory,
    require => File["/usr/local/lib/site_ruby"],
  }

  file { "/usr/local/lib/site_ruby/puppet/parser":
    ensure  => directory,
    require => File["/usr/local/lib/site_ruby/puppet"],
  }

  file { "/usr/local/lib/site_ruby/puppet/parser/functions":
    ensure  => "/etc/puppetmaster/functions",
    require => File["/usr/local/lib/site_ruby/puppet/parser"],
  }

  # Configuration
  #file {"/etc/default/puppetmaster":
  #  ensure  => present,
  #  source  => "puppet:///puppet/puppetmaster.default",
  #  notify  => Service["puppetmaster"],
  #}

  service {"puppetmaster":
    ensure  => running,
    enable  => true,
    require => Package["puppetmaster"],
  }

}
