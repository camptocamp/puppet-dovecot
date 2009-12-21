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
    options  => "-w 1:1 -c 1:1 -C atd",
    package  => ["foo", "bar"],
  }

*/
define monitoring::check ($ensure="present", $base='$USER1$/', $contact="admins", $codename=undef, $command=undef, $options=undef, package=false) {

  nagios::config::command { $codename:
    ensure => $ensure,
    command_line => "${base}${command} ${options}",
  }

  if $fqdn == $nagios_nsca_server {

    nagios::service::local { $codename:
      ensure              => $ensure,
      host_name           => $fqdn,
      contact_groups      => $contact,
      service_description => $name,
      package             => $package,
    }

  } else {

    nagios::service::nsca { $codename:
      ensure              => $ensure,
      host_name           => $fqdn,
      contact_groups      => $contact,
      service_description => $name,
      export_for          => $nagios_nsca_server,
      package             => $package,
    }

  }
}
