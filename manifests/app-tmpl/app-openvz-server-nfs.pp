class app-openvz-server-nfs {

# see http://projects.puppetlabs.com/projects/puppet/wiki/Kernel_Modules_Patterns
  define kern_module ($ensure=present) {
    $modulesfile = $operatingsystem ? { 
      /Debian|Ubuntu/ => "/etc/modules",
      /RedHat|CentOS/ => "/etc/rc.modules"
    }

    common::concatfilepart {"module ${name}":
      ensure => $ensure,
      file   => $modulesfile,
      content => $operatingsystem? {
        /Debian|Ubuntu/ => "${name}",
        /RedHat|CentOS/ => "/sbin/modprobe ${name}",
        },
    }

    case $ensure {
      present: {
        exec { "/sbin/modprobe ${name}": unless => "/bin/grep -q '^${name} ' '/proc/modules'" }
      }
      absent: {
          exec { "/sbin/modprobe -r ${name}": onlyif => "/bin/grep -q '^${name} ' '/proc/modules'" }
      }
      default: { err ( "unknown ensure value ${ensure}" ) }
    }
  }

  kern_module {"nfs": }


}
