define apt::preferences($ensure="present", $package="", $pin, $priority) {

  $pkg = $package ? {
    "" => $name,
    default => $package,
  }

  # apt support preferences.d since version >= 0.7.22
  case $lsbdistcodename {
    lucid : {   
      file {"/etc/apt/preferences.d/$name":
        ensure  => $ensure,
        owner   => root,
        group   => root,
        mode    => 644,
        content => template("apt/preferences.erb"),
        before  => Exec["apt-get_update"],
      }

    }
    default: {
      common::concatfilepart { $name:
        ensure  => $ensure,
        manage  => true,
        file    => "/etc/apt/preferences",
        content => template("apt/preferences.erb"),
        before  => Exec["apt-get_update"],
      }
    }
  }
}
