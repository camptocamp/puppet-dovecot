define bazaar::checkout($ensure=present, $local, $remote, $update=false) {

  case $ensure {
    'present': {
      exec {"checkout $name":
        command => "bzr co ${remote} ${local}",
        creates => "$local",
        require => Package["bzr"],
      }
      if $update {
        exec {"update $name":
          command => "bzr up ${local}",
          unless  => "test \$(bzr revno ${remote}) == \$(bzr revno ${local})",
          require => Exec["checkout $name"],
        }
      }
    }

    'absent': {
      file {$local:
        ensure  => absent,
        force   => true,
        recurse => true,
        purge   => true,
      }
    }

    default: {
      fail "No action available for ensure $ensure"
    }
  }

}
