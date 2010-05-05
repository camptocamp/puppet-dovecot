define apt::preferences($ensure="present", $package="", $pin, $priority) {

  $pkg = $package ? {
    "" => $name,
    default => $package,
  }

  common::concatfilepart { $name:
    ensure  => $ensure,
    file    => "/etc/apt/preferences",
    content => template("apt/preferences.erb"),
    before  => Exec["apt-get_update"],
  }

}
