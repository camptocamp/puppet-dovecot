class monit::puppet {
  include monit

  monit::config{"puppet":
    ensure => present,
    source => "puppet:///monit/puppet.conf",
  }
}
