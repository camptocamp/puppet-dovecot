/*

== Definition: openvz::ve
Create and manage containers on a server

Arguments:
- *$hostname*:   container hostname
- *$ip*:         container IP address
- *$ostemplate*: which OS template we want to use
- *$config*:     we can use a configuration template (created via openvz::veconfig)

Examples:

openvz::ve {1000:
  ensure     => present,
  hostnemt   => "foo.bar",
  ip         => "192.168.20.10",
  ostemplate => "os-debian-lenny",
}
*/
define openvz::ve (
      $ensure,
      $hostname,
      $ip,
      $ostemplate,
      $config     = "default") {

  # Constants from openvz::host
  $openvz_conf_dir = "/etc/vz/conf"
  $openvz_conf_file = "/etc/vz/vz.conf"

  # identification based on veid
  $veid = $name
  $configfile = "${openvz_conf_dir}/${veid}.conf"

  # ensure interpretation, presence and state
  case $ensure {
    "present": {
      $presence = "present"
      $state    = "stopped"
    }
    "absent": {
      $presence = "absent"
      $state    = "stopped"
    }
    "running": {
      $presence = "present"
      $state    = "running"
    }
    "stopped": {
      $presence = "present"
      $state    = "stopped"
    }
  }

  # Presence handling (present, absent)
  case $presence {
    "present": {
      # VE creation
      exec {"vzctl create ${veid}":
        command => "vzctl create ${veid} --ostemplate ${ostemplate}",
        unless  => "vzlist ${veid}"
      }

      # Ressource management (based on config templates)
      exec {"vzctl set ${veid} --applyconfig ${config} --save":
        unless  => "source ${configfile}; test \"\$ORIGIN_SAMPLE\" == \"${config}\"",
        require => [Exec["vzctl create ${veid}"], File["${openvz_conf_dir}/ve-${config}.conf-sample"]],
      }

      # State handling (running, stopped)
      case $state {
        "running": {
          exec {"vzctl start ${veid}":
            unless => "test \$(vzlist -a -o status -H ${veid}) == 'running'",
            require => Exec["vzctl create ${veid}"],
          }

          # Onboot
          exec {"vzctl set ${veid} --onboot yes --save":
            unless  =>  "source ${configfile}; test \"\$ONBOOT\" == \"yes\"",
            require => Exec["vzctl create ${veid}"],
          }
        }


    
        "stopped": {
          exec {"vzctl stop ${veid}":
            unless => "test \$(vzlist -a -o status -H ${veid}) == 'stopped'",
            require => Exec["vzctl create ${veid}"],
          }

          # Onboot
          exec {"vzctl set ${veid} --onboot no --save":
            unless  =>  "source ${configfile}; test \"\$ONBOOT\" == \"no\"",
            require => Exec["vzctl create ${veid}"],
          }
        }
      }

      #
      # Parameters
      #
      
      # IP addresses
      if $ip {
        exec {"vzctl set ${veid} --ipdel all --ipadd ${ip} --save":
          unless  => "test \$(vzlist -a -o ip -H ${veid}) == '${ip}'",
          require => Exec["vzctl create ${veid}"],
          notify  => Exec["puppet client installation in ${veid}"],
        }
      }

      # Hostname
      exec {"vzctl set ${veid} --hostname ${hostname} --save":
        unless  => "test \$(vzlist -o hostname -H ${veid}) == '${hostname}'",
        require => Exec["vzctl create ${veid}"],
        notify  => [ Exec["hostname fix ${veid}"], Exec["resolvconf fix ${veid}"] ],
      }
      
      # Hostname fix
      exec {"hostname fix ${veid}":
        command => "source ${openvz_conf_file}; echo -e \"127.0.0.1 localhost\\n127.0.0.1 ${hostname}.\$(facter domain) ${hostname}\" > \$VE_PRIVATE/${veid}/etc/hosts",
        refreshonly => true,
      }
     
      # resolv.conf fix
      exec {"resolvconf fix ${veid}":
        command => "source ${openvz_conf_file}; cp -f /etc/resolv.conf \$VE_PRIVATE/${veid}/etc/resolv.conf",
        refreshonly => true,
      }
     
      # Puppet client
      exec {"puppet client installation in ${veid}":
        command => "(wget -O - http://sa.camptocamp.com/d-i/install-puppet.sh; echo '/usr/sbin/puppetd --ssldir /var/lib/puppet/ssl -t --server sa.camptocamp.com') | vzctl exec ${veid} sh",
        refreshonly => true,
        timeout => "-1",
        require => [ Exec["hostname fix ${veid}"], Exec["resolvconf fix ${veid}"] ],
      }
        
    }

    "absent": {
      # VE destruction
      exec {"vzctl stop ${veid} && vzctl destroy ${veid}":
        onlyif => "vzlist ${veid}"
      }


    }
  }

}
