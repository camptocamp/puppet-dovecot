/*
== Definition: reprepro::update
Adds a packages repository.

Parameters:
- *name*: the name of the update-upstream use in the Update field in conf/distributions
- *ensure*: present/absent, defaults to present
- *url*: a valid repository URL
- *verify_release*: check the GPG signature Releasefile
- *filter_action*: default action when something is not found in the list
- *filter_name*: a list of filenames in the format of dpkg --get-selections

Requires:
- Class["reprepro"]

Example usage:

  reprepro::update {"lenny-backports":
    ensure      => present,
    repository  => "dev",
    url         => 'http://backports.debian.org/debian-backports',
    filter_name => "lenny-backports",
  }

*/
define reprepro::update (
  $ensure=present,
  $repository,
  $url,
  $verify_release="blindtrust",
  $filter_action="",
  $filter_name=""
) {

  include reprepro::params
  
  if $filter_name != "" {
    if $filter_action == "" {  
      $filter_list = "deinstall ${filter_name}-filter-list"
    } else {
      $filter_list = "${filter_action} ${filter_name}-filter-list"
    }
  } else {
    $filter_list = ""
  }

  common::concatfilepart {"update-${name}":
    ensure  => $ensure,
    manage  => $ensure ? { present => false, default => true, },
    content => template("reprepro/update.erb"),
    file    => "${reprepro::params::basedir}/${repository}/conf/updates",
    require => $filter_name ? {
      ""      => Reprepro::Repository[$repository],
      default => [Reprepro::Repository[$repository],Reprepro::Filterlist[$filter_name]],
    }
  }

}
