class os::centos {
 
  # set hostname
  host {"$srv_fqdn":
    ensure => present,
    ip => $ipaddress,
  }
  augeas {"set hostname":
    context => "/files/etc/sysconfig/network",
    changes => "set HOSTNAME $srv_fqdn",
    notify  => Exec["set hostname"],
  }
  exec {"set hostname":
    command     => "hostname $srv_fqdn",
    unless      => "hostname -f | grep -q $srv_fqdn",
  }
}
