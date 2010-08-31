define os::kernel_module($ensure=present) {
    
  line {"bootload module $name":
    line   => "$name",
    file   => "/etc/modules",
    ensure => $ensure,
  }

  exec {"load module $name":
    command => "modprobe $name",
    unless => "lsmod |grep -q $name",
  }

}
