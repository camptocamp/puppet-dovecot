/*

Class: git-subtree

Installs git-subtree and adds a symlink to /usr/local/bin

*/
class git-subtree {

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
