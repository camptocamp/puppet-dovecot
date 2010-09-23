class os-openvz-centos {
  file {"/etc/sysconfig/network-scripts/ifcfg-eth0":
    ensure => absent,
  }

  package {"kernel":
    ensure => absent,
  }

  augeas {"set eth1 config":
    context => "/files/etc/sysconfig/network-scripts/ifcfg-eth1",
    changes => [
      "set DEVICE eth1",
      "set BOOTPROTO dhcp",
      "set HOTPLUG yes",
      "set ONBOOT no",
    ],
  }

  augeas {"set eth0.18 config":
    context => "/files/etc/sysconfig/network-scripts/ifcfg-eth0.18",
    changes => [
      "set VLAN yes",
      "set DEVICE eth0.18",
      "set BOOTPROTO static",
      "set IPADDR $ipaddress",
      "set NETMASK 255.255.255.0",
      "set GATEWAY 10.27.18.1",
    ],
  }

  augeas {"set eth0.20 config":
    context => "/files/etc/sysconfig/network-scripts/ifcfg-eth0.20",
    changes => ["
      set VLAN yes", 
      "set DEVICE eth0.20", 
      "set BOOTPROTO manual", 
      "set BRIDGE br20"
    ],
  }

  augeas {"set br20 config":
    context => "/files/etc/sysconfig/network-scripts/ifcfg-br20",
    changes => [
      "set DEVICE br20", 
      "set BOOTPROTO manual", 
      "set TYPE Bridge", 
      "set ONBOOT yes", 
      "set MAXWAIT 0", 
      "set STP off"
    ],
  }

  augeas {"set eth0.21 config":
    context => "/files/etc/sysconfig/network-scripts/ifcfg-eth0.21",
    changes => [
      "set VLAN yes", 
      "set DEVICE eth0.21", 
      "set BOOTPROTO manual", 
      "set BRIDGE br21"
    ],
  }

  augeas {"set br21 config":
    context => "/files/etc/sysconfig/network-scripts/ifcfg-br21",
    changes => [
      "set DEVICE br21", 
      "set BOOTPROTO manual", 
      "set TYPE Bridge", 
      "set ONBOOT yes", 
      "set MAXWAIT 0", 
      "set STP off"
    ],
  }

  augeas {"set eth0.22 config":
    context => "/files/etc/sysconfig/network-scripts/ifcfg-eth0.22",
    changes => [
      "set VLAN yes", 
      "set DEVICE eth0.22", 
      "set BOOTPROTO manual", 
      "set BRIDGE br22"
    ],
  }

  augeas {"set br22 config":
    context => "/files/etc/sysconfig/network-scripts/ifcfg-br22",
    changes => [
      "set DEVICE br22", 
      "set BOOTPROTO manual", 
      "set TYPE Bridge", 
      "set ONBOOT yes", 
      "set MAXWAIT 0", 
      "set STP off"
    ],
  }

  augeas {"set eth0.30 config":
    context => "/files/etc/sysconfig/network-scripts/ifcfg-eth0.30",
    changes => [
      "set VLAN yes", 
      "set DEVICE eth0.30", 
      "set BOOTPROTO manual", 
      "set BRIDGE br30"
    ],
  }

  augeas {"set br30 config":
    context => "/files/etc/sysconfig/network-scripts/ifcfg-br30",
    changes => [
      "set DEVICE br30", 
      "set BOOTPROTO manual", 
      "set TYPE Bridge", 
      "set ONBOOT yes", 
      "set MAXWAIT 0", 
      "set STP off"
    ],
  }
}