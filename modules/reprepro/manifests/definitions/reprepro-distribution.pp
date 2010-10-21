/*
== Definition: reprepro::distribution

Adds a "Distribution" to manage.

Parameters:
- *name*: the name of the distribution
- *ensure* present/absent, defaults to present
- *repository*: the name of the distribution
- *origin*: package origin
- *label*: package label
- *suite*: package suite
- *architectures*: available architectures
- *components*: available components
- *description*: a short description
- *sign_with*: email of the gpg key
- *deb_indices*: file name and compression
- *dsc_indices*: file name and compression
- *update*: update policy name
- *uploaders*: who is allowed to upload packages
- *not_automatic*: automatic pined to 1 by using NotAutomatic, value are "yes" or "no"

Requires:
- Class["reprepro"]

Example usage:

  reprepro::distribution {"lenny":
    ensure        => present,
    repository    => "my-repository",
    origin        => "Camptocamp",
    label         => "Camptocamp",
    suite         => "stable",
    architectures => "i386 amd64 source",
    components    => "main contrib non-free",
    description   => "A simple example of repository distribution",
    sign_with     => "packages@camptocamp.com",
  }

*/
define reprepro::distribution (
  $ensure=present,
  $codename,
  $repository,
  $origin,
  $label,
  $suite,
  $architectures,
  $components,
  $description,
  $sign_with,
  $deb_indices="Packages Release .gz .bz2",
  $dsc_indices="Sources Release .gz .bz2",
  $update="",
  $uploaders="",
  $not_automatic="yes"
) {

  include reprepro::params

  common::concatfilepart {"distibution-${name}":
    ensure  => $ensure,
    manage  => $ensure ? { present => false, default => true, },
    content => template("reprepro/distribution.erb"),
    file    => "${reprepro::params::basedir}/${repository}/conf/distributions",
    require => Reprepro::Repository[$repository],
    notify  => $present ? {
      'present' => Exec["export distribution $name"],
      default   => undef,
    },
  }
  
  # FIXME: this exec don't works with user=>reprepro ?!? 
  exec {"export distribution $name":
    command     => "su -c 'reprepro -b ${reprepro::params::basedir}/${repository} export ${codename}' reprepro",
    refreshonly => true,
    require     => [User[reprepro], Reprepro::Repository[$repository]], 
  }

}
