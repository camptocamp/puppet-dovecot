class app-c2c-worstations-vmware {

  case $architecture {
    "i386": { $vmware_arch = "i386" }
    "amd64","x86_64": { $vmware_arch = "x86_64" }
  }

  case $lsbdistcodename {
    "hardy": { 
      package { 
        "linux-kernel-devel" :   ensure => latest;
        "linux-headers-generic": ensure => latest;
      }
      $vmware = "VMware-Workstation-6.5.0-118166.${vmware_arch}.bundle"
    }
    "intrepid","jaunty","lucid" : {
      $vmware = "VMware-Workstation-6.5.3-185404.${vmware_arch}.bundle"
      # bugfix for keyboard
      line {
        "bugfix1 for vmware in /etc/vmware/config":
          file    => '/etc/vmware/config',
          line    => "xkeymap.nokeycodeMap = true",
          ensure  => present,
          require => File["/etc/vmware/config"];
        "bugfix2 for vmware in /etc/vmware/config":
          file    => '/etc/vmware/config',
          line    => "xkeymap.keysym.ISO_Level3_Shift = 0x138",
          ensure  => present,
          require => File["/etc/vmware/config"]
      }
      file {"/etc/vmware/config":
        ensure  => present,
        require => File["/etc/vmware"],
      }
      file {"/etc/vmware":
        ensure => directory,
      }
    }
    default: { $vmware = "VMware-Workstation-6.5.0-118166.${vmware_arch}.bundle" }
  }

  file {"/usr/local/sbin/vmware-install.sh":
    ensure => present,
    mode => 0755,
    owner => "root",
    content => template("c2c/usr/local/sbin/vmware-install.erb")
  }

}
