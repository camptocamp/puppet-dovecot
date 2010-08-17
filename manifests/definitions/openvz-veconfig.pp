/*

== Definition: openvz::veconfig
Create templates for ve configuration based on vzsplit command

Example:
openvz::veconfig {"10":
  ensure => present,
}

It whill create a configuration template for the case we have 10 VE on the server

*/
define openvz::veconfig($ensure=present) {

  case $ensure {
    present: {
      exec {"vzsplit -n ${name} -f split${name}":
        creates => "/etc/vz/conf/ve-split${name}.conf-sample",
        require => Package["vzctl"],
      }

      file {"${openvz_conf_dir}/ve-split${name}.conf-sample":
        ensure  => present,
        require => Exec["vzsplit -n ${name} -f split${name}"],
      }
    }
    absent: {
      file {"${openvz_conf_dir}/ve-split${name}.conf-sample":
        ensure  => absent,
        require => Exec["vzsplit -n ${name} -f split${name}"],
      }
    }
    default: { fail "Unknown \$ensure $ensure for openvz::veconfig" }
  }

}
