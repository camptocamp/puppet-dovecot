class monitoring::varnish {

  $nagios_plugin_dir = "/opt/nagios-plugins"
  include varnish::nagiosplugin

  file { "${nagios_plugin_dir}/check_vcl":
    ensure  => present,
    mode    => 0755,
    owner   => "root",
    content => '#!/bin/sh
# file managed by puppet

FILE="/etc/varnish/$(hostname).vcl"

TMPDIR=$(mktemp -d)

if [ -z "$TMPDIR" ] || [ ! -w "$TMPDIR" ]; then
  echo "temporary work dir creation failed"
  exit 3
fi

echo | varnishd -d -s malloc -n "$TMPDIR" -f "$FILE" > /dev/null 2>&1

if [ $? == 0 ]; then
  MESSAGE="$FILE has no errors"
  STATUS=0
else
  MESSAGE="$FILE has syntax errors or is missing"
  STATUS=2
fi

rm -f "$TMPDIR/_.vsl" && rmdir "$TMPDIR"
if [ $? != 0 ]; then
  MESSAGE="failed to remove temporary dir"
  STATUS=3
fi

echo "$MESSAGE"
exit $STATUS
',
  }

  # allocated/total ratio of cache usage.
  monitoring::check::varnish { "cache usage":
    stat => "usage",
    warn => 85,
    crit => 90,
  }

  monitoring::check { "Process: varnishd":
    codename => "check_varnishd_process",
    command  => "check_procs",
    options  => "-C varnishd -c 2",
  }

  monitoring::check { "Varnish: VCL":
    codename => "check_varnish_vcl_syntax",
    command  => "check_vcl",
    interval => 360,
    retry    => 60,
    base     => '$USER2$/',
    require  => File["${nagios_plugin_dir}/check_vcl"],
  }

  # See http://varnish-cache.org/wiki/StatsExplained for the reasons we
  # monitor this cryptic stuff.
  monitoring::check::varnish { "worker threads creation failed":
    stat => "n_wrk_failed",
    warn => 1,
    crit => 1,
  }

  monitoring::check::varnish { "hit max worker thread limit":
    stat => "n_wrk_max",
    warn => 1,
    crit => 1,
  }

  monitoring::check::varnish { "work requests dropped":
    stat => "n_wrk_drop",
    warn => 1,
    crit => 1,
  }

  monitoring::check::varnish { "work requests queued":
    stat => "n_wrk_queue",
    warn => 10,
    crit => 30,
  }

}

/*

== Definition: monitoring::check::varnish

A small wrapper around monitoring::check, using check_varnish to monitor values
returned by varnishstat.

We typcially want to check more than one value per varnish instance. A few
values are checked by default in varnish::nagiosplugin.

*/
define monitoring::check::varnish (
  $ensure="present",
  $stat,
  $warn,
  $crit) {

  monitoring::check { "Varnish: ${name}":
    ensure   => $ensure,
    codename => "check_varnish_${stat}",
    command  => "check_varnish",
    base     => '$USER2$/',
    options  => "-p ${stat} -w ${warn} -c ${crit}",
    require  => Class["varnish::nagiosplugin"],
  }

}

