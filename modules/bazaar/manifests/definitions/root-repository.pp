define bazaar::rootrepository(
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

  exec {"init ${name}":
    command => "umask 0002; bzr init --rich-root-pack /srv/bzr/${name}",
    user    => $owner,
    creates => "/srv/bzr/${name}/.bzr",
    require => Package["bzr"],
  }

  file {"/srv/bzr/${name}/.bzr":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    require => Exec["init ${name}"],
  }
}
