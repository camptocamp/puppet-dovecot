class mw-git {

  package {"git-core":
    ensure => purged,
  }

  if $lsbdistcodename == 'lenny' {
    apt::preferences {["git", "git-email", "gitk", "git-svn"]:
      pin => "release a=lenny-backports",
      priority => 1001,
    }

    package {["git", "git-email", "gitk", "git-svn"]:
      ensure  => present,
      require => [Package["git-core"], Apt::Preferences["git", "git-email", "gitk", "git-svn"]],
    }
  } else {
    package {["git", "git-email", "gitk", "git-svn"]:
      ensure  => present,
      require => Package["git-core"],
    }
  }
}
