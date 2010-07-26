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
    codename => "check_demo",
    base     => "/usr/local/sbin/",
    command  => "check_dummy.pl",
    options  => "-w 1 -c 2",
    interval => "10",
    retry    => "5",
    remote   => true,
    package  => ["foo", "bar"],
  }

*/
define monitoring::check ($ensure="present", $base='$USER1$/', $contact="admins", $codename=undef, $command=undef, $options=undef, $interval=false, $retry=false, $remote=false, $package=false) {

  if $fqdn == $nagios_nsca_server {

    nagios::service::local { "$codename on $fqdn":
      ensure                => $ensure,
      host_name             => $fqdn,
      contact_groups        => $contact,
      check_command         => $codename,
      normal_check_interval => $interval,
      retry_check_interval  => $retry,
      service_description   => $name,
      package               => $package,
    }

    nagios::command { $codename:
      ensure => $ensure,
      command_line => "${base}${command} ${options}",
    }

  } else {

    if $remote == true {

      nagios::service::remote { $codename:
        ensure                => $ensure,
        host_name             => $fqdn,
        command_line          => "${base}${command} ${options}",
        contact_groups        => $contact,
        normal_check_interval => $interval,
        retry_check_interval  => $retry,
        service_description   => $name,
        export_for            => "nagios-${nagios_nsca_server}",
      }

    } else {

      nagios::service::nsca { $codename:
        ensure                => $ensure,
        host_name             => $fqdn,
        contact_groups        => $contact,
        normal_check_interval => $interval,
        retry_check_interval  => $retry,
        service_description   => $name,
        export_for            => "nagios-${nagios_nsca_server}",
        package               => $package,
      }

      nagios::command { $codename:
        ensure => $ensure,
        command_line => "${base}${command} ${options}",
      }
    }
  }
}
