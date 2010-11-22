define trac::site($ensure, $tracname, $vhostname) {
  case $ensure {
    present: {
      file { "trac-$name":
        path => "/var/www/$vhostname/conf/trac-$name.conf",
        owner => root,
        group => root,
        mode => 644,
        content => template("trac/tracsite.erb"),
        notify => Service[apache2] # notify apache that it should restart
      }
    }

    absent: {
      err "absent not implemented"
    }
  }
}
