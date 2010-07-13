# Copyright (c) 2008, Luke Kanies, luke@madstop.com
# forked by Puzzle ITC
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
# 
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# Create a new subversion repository.
define subversion::svnrepo(
    $ensure=present,
    $path='',
    $owner='false',
    $group='false',
    $mode='false'
) {
    include subversion

    case $path {
        '': { $svn_path = "/srv/svn" }
        default: { $svn_path = "${path}" }
    }
    $repository_path = "${svn_path}/${name}"

    if $ensure == 'present' {
      exec { "create-svn-$name":
          command => "/usr/bin/svnadmin create $repository_path",
          creates => "$repository_path",
          before => File["$repository_path"],
          require => [ Package['subversion'], File[$svn_path] ],
      }
    }

    file{"$repository_path":
        ensure  => $ensure ? {'absent' => 'absent', default => directory},
        recurse => true,
        force   => true,
        owner   => $owner ? { '' => undef, default => $owner },
        group   => $group ? { '' => undef, default => $group },
        mode    => $mode  ? { '' => undef, default => $mode },
        require => $ensure ? {'absent' => undef, default => Exec["create-svn-$name"]},
    }
}
