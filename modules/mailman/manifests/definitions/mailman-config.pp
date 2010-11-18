define mailman::config($ensure=present, $variable, $value, $mlist) {
  common::concatfilepart {$name:
    ensure  => $ensure,
    file    => "/var/lib/mailman/lists/${mlist}/puppet-config.conf",
    content => template("mailman/config_list.erb"),
    notify  => Exec["load configuration $variable on $mlist"],
    require => [Class["mailman"], Maillist[$mlist]],
  }
  exec {"load configuration $variable on $mlist":
    refreshonly => true,
    command     => "config_list -i /var/lib/mailman/lists/${mlist}/puppet-config.conf $mlist",
    onlyif      => "config_list -i /var/lib/mailman/lists/${mlist}/puppet-config.conf -c $mlist"
  }
}
