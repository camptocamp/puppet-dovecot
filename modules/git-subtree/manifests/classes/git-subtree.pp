/*

Class: git-subtree

Installs git-subtree and adds a symlink to /usr/local/bin

*/
class git-subtree {

  # FIXME: this regex will only work until git 1.9
  if $gitversion !~ /^(?:1:)1.[789]./ {
    fail "git-subtree requires git 1.7 or later!"
  }

  vcsrepo { "/usr/src/git-subtree":
    ensure   => present,
    source   => "git://github.com/apenwarr/git-subtree.git",
    provider => 'git',
    revision => '7f74d65b12',
  }

  file { "/usr/local/bin/git-subtree":
    ensure  => file,
    source  => "file:///usr/src/git-subtree/git-subtree.sh",
    owner   => "root",
    mode    => 0755,
    require => Vcsrepo["/usr/src/git-subtree"],
  }
}
