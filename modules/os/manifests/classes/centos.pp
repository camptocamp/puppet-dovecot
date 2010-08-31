class os::centos {
 
  # set hostname
  host {"$fqdn":
    ensure => present,
    ip => $ipaddress,
  }
  augeas {"set hostname":
    context => "/files/etc/sysconfig/network",
    changes => "set HOSTNAME $fqdn",
    notify  => Exec["set hostname"],
  }
  exec {"set hostname":
    command     => "hostname $fqdn",
    unless      => "hostname -f | grep -q $fqdn",
  }
}
