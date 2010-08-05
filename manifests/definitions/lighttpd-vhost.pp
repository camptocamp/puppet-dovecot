/*

== Definition: lighttpd::vhost

Arguments:
  *$ensure*: can be:
                    present (creates vhost)
                    absent  (removes all vhost datas)
                    disabled (keeps data, bu disables it)
  *$owner*:   vhost's owner (default www-data)
  *$group*:   vhost's group (default root)
  *$mode*:    vhost's mode (default 2570)
  *$aliases*: vhost's aliases

Example:
node "foo.bar" {
  include lighttpd

  # ... other configurations

  lighttpd::vhost {$fqdn:
    ensure => present,
    group  => "admin",
  }

  lighttpd::vhost {"bar.foo":
    ensure => disabled,
  }
}

*/
define lighttpd::vhost(
  $ensure=present,
  $owner=www-data,
  $group=root,
  $mode=2570,
  $aliases=[]
  ) {

  case $operatingsystem {
    /Debian|Ubuntu/: {
      $wwwroot = "/var/www"
      $lighttpd_config_dir = "/etc/lighttpd"
    }

    default: { fail "No instruction for \$operatingsystem $operatingsystem"}
  }

  file {"${lighttpd_config_dir}/site-available/vhost-${name}.conf":
    ensure  => $ensure,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template("lighttpd/lighttpd-vhost.erb"),
    require => File["/etc/lighttpd/site-available"],
    notify  => Exec["reload-lighttpd"],
  }

  File["${lighttpd_config_dir}/site-enabled/vhost-${name}.conf"] {
    notify => Exec["reload-lighttpd"],
  }

  case $ensure {
    present: {
      file {"${wwwroot}/${name}":
        ensure => directory,
        owner  => root,
        group  => root,
        mode   => 0755,
      }

      file {"${wwwroot}/${name}/htdocs":
        ensure => directory,
        require => File["${wwwroot}/${name}"],
        owner   => $owner,
        group   => $group,
        mode    => $mode,
      }

      file {"${wwwroot}/${name}/conf":
        ensure => directory,
        require => File["${wwwroot}/${name}"],
        owner   => $owner,
        group   => $group,
        mode    => $mode,
      }

      file {"${wwwroot}/${name}/private":
        ensure => directory,
        require => File["${wwwroot}/${name}"],
        owner   => $owner,
        group   => $group,
        mode    => $mode,
      }

      file {"${wwwroot}/${name}/logs":
        ensure => directory,
        require => File["${wwwroot}/${name}"],
        owner   => $owner,
        group   => root,
        mode    => 0755,
      }

      file {"${wwwroot}/${name}/cgi-bin":
        ensure  => directory,
        require => File["${wwwroot}/${name}"],
        owner   => $owner,
        group   => $group,
        mode    => $mode,
      }

      file {"${lighttpd_config_dir}/site-enabled/vhost-${name}.conf":
        ensure => "../site-available/vhost-${name}.conf",
        require => [File["${lighttpd_config_dir}/site-available/vhost-${name}.conf"], File["${lighttpd_config_dir}/site-available"]],
      }
    }

    absent: {
      file {"${lighttpd_config_dir}/site-enabled/vhost-${name}":
        ensure => absent,
        require => File["${lighttpd_config_dir}/site-available/vhost-${name}"],
      }
      exec {"remove ${wwwroot}/${name}":
        command => "rm -rf ${wwwroot}/${name}",
        onlyif  => ["test -d ${wwwroot}/${name}", "test -n ${wwwroot}", "test -n ${name}"],
        require => Common::Concatfilepart["$name"],
      }
    }

    disabled: {
      file {"${lighttpd_config_dir}/site-enabled/vhost-${name}":
        ensure => absent,
        require => File["${lighttpd_config_dir}/site-available/vhost-${name}"],
      }
    }
    default: { fail "Unknown \$ensure $ensure for $name"}
  }

}
