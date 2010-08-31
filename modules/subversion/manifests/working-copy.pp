define subversion::working-copy($repo_base, $path, $branch = "trunk", $svn_ssh = false, $owner = "root", $group = "root") {
  include subversion::xmlstarlet

  file { $path:
    ensure => directory,
    owner => $owner,
    group => $group;
  }

  $repourl = $branch ? {
    trunk   => "svn+ssh://$repo_base/$name/trunk",
    default => "svn+ssh://$repo_base/$name/branches/$branch"
  }

  $svncmd = "/usr/bin/svn co --non-interactive $repourl ."

  exec { "svnco-$name":
    command => $svncmd,
    environment => $svn_ssh ? {
      false => undef,
      default => "SVN_SSH=$svn_ssh"
    },
    cwd => $path,
    require => [ File[$path], Class["subversion"] ],
    creates => "$path/.svn",
    logoutput => on_failure;
  "svnswitch-$name":
    command => "/usr/bin/svn switch $repourl",
    environment => $svn_ssh ? {
      false => undef,
      default => "SVN_SSH=$svn_ssh"
    },
    unless => "/usr/bin/test `/usr/bin/svn info | /usr/bin/awk '/^URL/{print \$2}'` = '$repourl'",
    logoutput => true,
    cwd => $path,
    require => Class["subversion"];
  "svnupdate-$name":
    command => "/usr/bin/svn update",
    require => [ Exec["svnco-$name"], Class["subversion"] ],
    environment => $svn_ssh ? {
      false => undef,
      default => "SVN_SSH=$svn_ssh"
    },
    onlyif => '/usr/bin/test `/usr/bin/svn status -uv --non-interactive --xml | /usr/bin/xmlstarlet sel -t -v "count(/status/target/entry/repos-status)"` -gt 0',
    cwd => $path,
    logoutput => on_failure;
  }
}
