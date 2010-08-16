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
    ensure   => present,
    base     => "/usr/local/sbin/",
    codename => "check_demo",
    command  => "check_dummy.pl",
    options  => "-w 1 -c 2",
    interval => "10",
    retry    => "5",
    type     => "passive",
    server   => $nagios_nsca_server,
    package  => ["foo", "bar"],
  }

*/
define monitoring::check (
  $ensure="present",
  $base='default',
  $contact="admins",
  $codename=undef,
  $command=undef,
  $options=undef,
  $interval='5',
  $retry='3',
  $type,
  $server,
  $package=false) {

  include monitoring::params

  if $base == 'default' {
    $basedir = "${monitoring::params::mainplugins}"
  } else {
    $basedir = $base
  }

  case $type {

    'passive': { # nsca

      if $fqdn == $server {
        nagios::service::local { "$codename on $fqdn":
          ensure                => $ensure,
          host_name             => $fqdn,
          command_line          => "${basedir}${command} ${options}",
          contact_groups        => $contact,
          check_command         => $codename,
          normal_check_interval => $interval,
          retry_check_interval  => $retry,
          service_description   => $name,
          package               => $package,
        }
      } else {
        nagios::service::nsca { $codename:
          ensure                => $ensure,
          host_name             => $fqdn,
          command_line          => "${basedir}${command} ${options}",
          contact_groups        => $contact,
          normal_check_interval => $interval,
          retry_check_interval  => $retry,
          service_description   => $name,
          export_for            => "nagios-${server}",
          package               => $package,
        }
      }
    }

    'active': { #nrpe

      if $fqdn == $server {
        nagios::service::local { "$codename on $fqdn":
          ensure                => $ensure,
          host_name             => $fqdn,
          command_line          => "${basedir}${command} ${options}",
          contact_groups        => $contact,
          check_command         => $codename,
          normal_check_interval => $interval,
          retry_check_interval  => $retry,
          service_description   => $name,
          package               => $package,
        }
      } else {
        nagios::service::nrpe { $codename:
          ensure                => $ensure,
          host_name             => $fqdn,
          command_line          => "${basedir}${command} ${options}",
          contact_groups        => $contact,
          normal_check_interval => $interval,
          retry_check_interval  => $retry,
          service_description   => $name,
          export_for            => "nagios-${server}",
          package               => $package,
        }
      }
    }

    'remote': { # remote

      if $fqdn == $server {
        nagios::service::local { "$codename on $fqdn":
          ensure                => $ensure,
          host_name             => $fqdn,
          command_line          => "${basedir}${command} ${options}",
          contact_groups        => $contact,
          check_command         => $codename,
          normal_check_interval => $interval,
          retry_check_interval  => $retry,
          service_description   => $name,
          package               => $package,
        }
      } else {
        nagios::service::remote { $codename:
          ensure                => $ensure,
          host_name             => $fqdn,
          command_line          => "${basedir}${command} ${options}",
          contact_groups        => $contact,
          normal_check_interval => $interval,
          retry_check_interval  => $retry,
          service_description   => $name,
          export_for            => "nagios-${server}",
        }
      }
    }
  }
}
