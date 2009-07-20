define bazaar::repository(
  $ensure = present,
  $owner  = 'root',
  $group  = 'root',
  $mode   = '2775'
) {

  file {"/srv/bzr/${name}":
    ensure => $ensure ? {
      present => directory,
      default => absent
    },
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }

  exec {"init-repo ${name}":
    command => "umask 0002; bzr init-repo --rich-root-pack /srv/bzr/${name}",
    user    => $owner,
    creates => "/srv/bzr/${name}/.bzr",
    require => Package["bzr"],
  }

  file {"/srv/bzr/${name}/.bzr":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    require => Exec["init-repo ${name}"],
  }
}
