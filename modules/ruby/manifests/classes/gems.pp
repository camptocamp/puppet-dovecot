# this class just installs the minimal stuff needed to run "gem install"
class ruby::gems {

  package { "rubygems":
    ensure => present
  }

  package { "ruby-dev":
    ensure => present,
    name   => $operatingsystem ? {
      RedHat => "ruby-devel",
      Debian => "ruby-dev",
    },
  }

  if $operatingsystem == "debian" {
    package { "rake":
      ensure => present
    }
  }
}
