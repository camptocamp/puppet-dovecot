class c2c::puppet-client inherits puppet::client {
  include monit

  file {"/usr/local/sbin/puppet-ssl-fix.sh":
    ensure => absent,
    source => "puppet:///c2c/puppet-ssl-fix.sh",
    mode   => "755",
  }

  monit::config{"puppet":
    ensure => absent,
  }
}
