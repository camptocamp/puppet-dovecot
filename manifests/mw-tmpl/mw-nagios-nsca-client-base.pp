class mw-nagios-nsca-client-base {
  $nagios_nsca_server = 'sa.camptocamp.com'
  include nagios::base
  include nagios::nsca::client

  # create host
  nagios::host::remote {$fqdn:
    ensure         => present,
    nagios_alias   => "$hostname ($hostgroup)",
    contact_groups => $basic_contact_group,
    hostgroups     => $hostgroup,
    export_for     => "nagios-${nagios_nsca_server}",
  }

  # default checks
  include monitoring::cron
  include monitoring::diskusage
  include monitoring::ssh
  include monitoring::puppet

  nagios::config::template {"generic-service":
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

  nagios::config::template {"generic-service-active":
    conf_type => "service",
    content   => "
  use                     generic-service
  active_checks_enabled   1
  register                0
",
  }

  nagios::config::template {"generic-service-passive":
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
