# Monitoring for production servers - System and basic services

# Nagios global configuration variables
#
# web interface
$nagios_cgi_dir="/usr/lib/cgi-bin/nagios3"
$nagios_physical_html_path="/usr/share/nagios3/htdocs"
$nagios_stylesheets_dir="$nagios_root_dir/stylesheets"
$nagios_show_context_help="0"

# NSCA
$nagios_nsca_password="taib2Dai"
$nagios_nsca_encryption_method="3"
$nagios_nsca_decryption_method="3"
$nagios_nsca_server="c2cpc27.camptocamp.com"
$nagiosadmin_password="nnotWHaxY0PsA"
$nagios_service_check_timeout="80"
$nagios_host_check_timeout="80"


class os-monitoring {
  include nagios

  if $is_external {
    $hostgroups = "${operatingsystem}${lsbmajdistrelease}, ${virtual}, ${hardwaremodel}, ${server_group}, external"
  } else {
    $hostgroups = "${operatingsystem}${lsbmajdistrelease}, ${virtual}, ${hardwaremodel}, ${server_group}, internal"
  }

  if "$fqdn" == "$nagios_nsca_server" {
    include nagios::nsca::server
    nagios::host {$fqdn:
      ensure          => present,
      nagios_alias    => "$hostname ($hostgroup)",
      contact_groups  => $basic_contact_group,
      hostgroups      => $hostgroups,
    }
    include monitoring::diode
  } else {
    include nagios::nsca::client
    if $is_external {
      nagios::host::nsca {$fqdn:
        ensure         => present,
        nagios_alias   => "$hostname ($hostgroup)",
        contact_groups => $basic_contact_group,
        hostgroups      => $hostgroups,
        export_for     => "nagios-${nagios_nsca_server}",
      }
      include monitoring::ssh::process
    } else {
      nagios::host::remote {$fqdn:
        ensure         => present,
        nagios_alias   => "$hostname ($hostgroup)",
        contact_groups => $basic_contact_group,
        hostgroups      => $hostgroups,
        export_for     => "nagios-${nagios_nsca_server}",
      }
      include monitoring::ssh
    }
  }

  file {"/opt/nagios-plugins":
    ensure => directory,
  }

  # default checks
  include monitoring::cron
  include monitoring::diskusage
  include monitoring::loadaverage
  include monitoring::puppet
  include monitoring::at

  nagios::template {"generic-service":
    conf_type => "service",
    content   => "
  active_checks_enabled           0
  passive_checks_enabled          0
  parallelize_check               1
  obsess_over_service             1
  check_freshness                 0
  notifications_enabled           1
  event_handler_enabled           1
  flap_detection_enabled          1
  failure_prediction_enabled      1
  process_perf_data               1
  retain_status_information       1
  retain_nonstatus_information    1
  notification_interval           0
  is_volatile                     0
  check_period                    24x7
  normal_check_interval           5
  retry_check_interval            1
  max_check_attempts              4
  notification_period             24x7
  notification_options            w,u,c,r
  contact_groups                  admins
  register                        0
",
  }

  nagios::template {"generic-service-active":
    conf_type => "service",
    content   => "
  use                     generic-service
  active_checks_enabled   1
  register                0
",
  }

  nagios::template {"generic-service-passive":
    conf_type => "service",
    content   => "
  use                     generic-service
  passive_checks_enabled  1
  register                0
  check_freshness         1
  check_command           service-is-stale
",
  }

}
