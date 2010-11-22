define c2c::trac-project($ensure, $description, $url, $cc, $vhostname,$slash=false) {
  subversion::svnrepo {$name:
    ensure => $ensure,
    path   => "/srv/svn/repos",
  }
  c2c::trac-instance {$name:
    ensure      => $ensure,
    description => $description,
    url         => $url,
    cc          => $cc,
    require     => Subversion::Svnrepo[$name],
    slash       => $slash
  }

  trac::site {$name:
    ensure    => $ensure,
    tracname  => $name,
    vhostname => $vhostname,
  }
}
