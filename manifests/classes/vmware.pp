class monitoring::vmware {

  $vmware = $lsbdistcodename ? {
    #TODO/^(Nahant|lenny)/ => "vmware-guestd",
    Lenny         => "vmware-guestd",
    Nahantupdate5 => "vmware-guestd",
    Nahantupdate6 => "vmware-guestd",
    Nahantupdate7 => "vmware-guestd",
    Nahantupdate8 => "vmware-guestd",
    Tikanga       => "vmtoolsd",
  }

  monitoring::check { "Process: $vmware":
    codename => "check_vmware_process",
    command  => "check_procs",
    options  => "-w 1:1 -c 1:1 -C ${vmware}",
    interval => "60",
    retry    => "30",
    package  => $operatingsystem ?{
      /RedHat|CentOS/ => "nagios-plugins-procs",
      default => false
    }
  }

  file { "/opt/nagios-plugins/check_vmware_kmods.sh":
    mode    => 0755,
    owner   => "root",
    group   => "root",
    before  => Monitoring::Check["Vmware: kernel modules"],
    content => '#!/bin/sh

# file managed by puppet

mods="vmsync vmmemctl vmhgfs"

for m in $mods; do
  if ! $(lsmod | egrep -q "^$m +"); then
    echo "Module \"$m\" is not loaded in kernel."
    exit 2
  fi
done

echo "Modules \"$mods\" loaded in kernel."
exit 0
',
  }

  monitoring::check { "Vmware: kernel modules":
    codename => "check_vmware_kmods",
    command  => "check_vmware_kmods.sh",
    base     => '$USER2$/',
    interval => "60",
    retry    => "30",
  }
}
