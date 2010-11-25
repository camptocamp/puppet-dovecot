/*
== Definition: monitoring::check

Example usage:

  # real world example:
  monitoring::check { "Process: atd":
    codename => "check_at_process",
    command  => "check_procs",
    options  => "-w 1:1 -c 1:1 -C atd",
  }

  # example with all options available:
  monitoring::check { "Nagios Demo":
    ensure    => present,
    base      => "/usr/local/sbin/",
    codename  => "check_demo",
    command   => "check_dummy.pl",
    options   => "-w 1 -c 2",
    interval  => "10",
    retry     => "5",
    host_name => "node.example.com",
    type      => "passive",
    server    => $nagios_nsca_server,
    package   => ["foo", "bar"],
    sudo      => "toto",
  }

*/
define monitoring::check (
  $ensure="present",
  $base='default',
  $contact="admins",
  $group="default",
  $codename=undef,
  $command=undef,
  $options=undef,
  $interval='5',
  $retry='3',
  $host_name=$fqdn,
  $type,
  $server,
  $package=false,
  $sudo=undef) {

  include monitoring::params

  if $base == 'default' {
    $basedir = "${monitoring::params::mainplugins}"
  } else {
    $basedir = $base
  }

  if $sudo {
    $sudocmd = "/usr/bin/sudo -u ${sudo} "
  } else {
    $sudocmd = ""
  }

  case $type {

    'passive': { # nsca

      if $fqdn == $server {
        nagios::service::local { "$codename on $fqdn":
          ensure                => $ensure,
          host_name             => $host_name,
          command_line          => "${sudocmd}${basedir}${command} ${options}",
          contact_groups        => $contact,
          service_groups        => $group,
          check_command         => $codename,
          normal_check_interval => $interval,
          retry_check_interval  => $retry,
          service_description   => $name,
          package               => $package,
        }
      } else {
        nagios::service::nsca { $codename:
          ensure                => $ensure,
          host_name             => $host_name,
          command_line          => "${sudocmd}${basedir}${command} ${options}",
          contact_groups        => $contact,
          service_groups        => $group,
          normal_check_interval => $interval,
          retry_check_interval  => $retry,
          service_description   => $name,
          export_for            => "nagios-${server}",
          package               => $package,
        }
      }

      if $sudo {
        common::concatfilepart { "sudo.${name}":
          ensure  => $ensure,
          file    => "/etc/sudoers",
          content => "nagios ALL=(${sudo}) ${basedir}${command} ${options}\n",
        }
      }
    }

    'active': { #nrpe

      if $fqdn == $server {
        nagios::service::local { "$codename on $fqdn":
          ensure                => $ensure,
          host_name             => $host_name,
          command_line          => "${sudocmd}${basedir}${command} ${options}",
          contact_groups        => $contact,
          service_groups        => $group,
          check_command         => $codename,
          normal_check_interval => $interval,
          retry_check_interval  => $retry,
          service_description   => $name,
          package               => $package,
        }
      } else {
        nagios::service::nrpe { $codename:
          ensure                => $ensure,
          host_name             => $host_name,
          command_line          => "${sudocmd}${basedir}${command} ${options}",
          contact_groups        => $contact,
          service_groups        => $group,
          normal_check_interval => $interval,
          retry_check_interval  => $retry,
          service_description   => $name,
          export_for            => "nagios-${server}",
          package               => $package,
        }
      }

      if $sudo {
        common::concatfilepart { "sudo.${name}":
          ensure  => $ensure,
          file    => "/etc/sudoers",
          content => "nagios ALL=(${sudo}) ${basedir}${command} ${options}\n",
        }
      }
    }

    'remote': { # remote

      if $sudo {
        fail("'\$sudo' parameter unimplemented in 'remote' mode. If you need sudo for a remote check, then you should rethink your security instead !")
      }

      if $fqdn == $server {
        nagios::service::local { "$codename on $fqdn":
          ensure                => $ensure,
          host_name             => $host_name,
          command_line          => "${basedir}${command} ${options}",
          contact_groups        => $contact,
          service_groups        => $group,
          check_command         => $codename,
          normal_check_interval => $interval,
          retry_check_interval  => $retry,
          service_description   => $name,
          package               => $package,
        }
      } else {
        nagios::service::remote { $codename:
          ensure                => $ensure,
          host_name             => $host_name,
          command_line          => $base ? {
            'default' => "\$USER1\$/${command} ${options}",
            default   => "${basedir}${command} ${options}",
          },
          contact_groups        => $contact,
          service_groups        => $group,
          normal_check_interval => $interval,
          retry_check_interval  => $retry,
          service_description   => $name,
          export_for            => "nagios-${server}",
        }
      }
    }
  }
}
