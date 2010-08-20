class c2c::openvz-host inherits openvz::host {

  # Filesystem
  mount { "/srv":
    ensure => absent,
  }

  mount { "/var/lib/vz":
    ensure  => mounted,
    device  => "/dev/vg0/srv",
    fstype  => "auto",
    options => "defaults",
    dump    => 0,
    pass    => 2,
    require => Package["vzctl"],
  }

  # Directories
  file { "/var/lib/vz/dump":
    ensure  => directory,
    require => Mount["/var/lib/vz"],
  }

  file { "/var/lib/vz/lock":
    ensure  => directory,
    require => Mount["/var/lib/vz"],
  }

  file { "/var/lib/vz/template":
    ensure  => directory,
    require => Mount["/var/lib/vz"],
  }

  file { "/var/lib/vz/template/cache":
    ensure  => directory,
    require => Mount["/var/lib/vz"],
  }

  $network_ip      = network_lookup("ip")
  $network_netmask = network_lookup("netmask")
  $network_gateway = network_lookup("gateway")

  # Network configuration
  file { "/etc/network/interfaces":
    ensure  => present,
    content => template("openvz/network_interfaces.erb"),
  }

  # SSH keys required by vzmigrate
  #file { "/root/.ssh":
  #  ensure => directory,
  #  owner  => root,
  #  mode   => 700,
  #}

  #file { "/root/.ssh/id_dsa":
  #  ensure => present,
  #  source => "puppet:///openvz/ssh-id_dsa",
  #  require => File["/root/.ssh"],
  #}

  # NFS client in VE's
  common::append_if_no_such_line{nfs_kernel_module:
    file => "/etc/modules",
    line => "nfs",
  }

  line{proc_kernel_ve_allow_kthreads:
    ensure => present,
    file   => "/etc/sysctl.conf",
    line   => "kernel.ve_allow_kthreads=1",
    notify => Exec["sysctl-reload"],
  }

  # Tools
  file {"/usr/local/sbin/addVE.py":
    source => "puppet:///openvz/usr/local/sbin/addVE.py",
    owner  => "root",
    group  => "root",
    mode   => 555,
  }

  file {"/root/vzcommands":
    source => "puppet:///openvz/root/vzcommands",
    owner => "root",
    group => "root",
    mode => 555,
    ensure => absent,
  }

  file {"/usr/local/sbin/toggle-ve-status.py":
    ensure => present,
    source => "puppet:///c2c/usr/local/sbin/toggle-ve-status.py",
    owner => 'root',
    group => 'root',
    mode => '755',
  }

  cron { "update ve status":
    ensure  => present,
    command => "/usr/local/sbin/toggle-ve-status.py",
    user    => 'root',
    hour    => "*",
    minute  => "*/5",
    require => File["/usr/local/sbin/toggle-ve-status.py"],
  }

}
