/*

== Class: reprepro::params

Global parameters

*/
class reprepro::params {

  $basedir = $reprepro_basedir ? {
    "" => "/var/packages",
    default => $reprepro_basedir,
  }

}
