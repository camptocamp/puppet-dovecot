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
    $path='absent',
    $owner='false',
    $group='false',
    $mode='false'
) {
    case $path {
        absent: {
            include subversion::basics
            $create_path = "/srv/svn/${name}"
        }
        default: { $create_path = "${path}/${name}" }
    }
    exec { "create-svn-$name":
        command => "/usr/bin/svnadmin create $create_path",
        creates => "$create_path",
        before => File["${create_path}"],
    }
    case $path {
        absent: { 
            Exec["create-svn-$name"]{
                require +> [ Package['subversion'], File['/srv/svn'] ],
            }
        }
        default: {
            Exec["create-svn-$name"]{
                require +> Package['subversion'],
            }
        }
    }
    file{"${create_path}":
        ensure => directory,
        recurse => true,
    }
    if $owner {
        File["${create_path}"]{
            owner => $owner,
        }
    } 
    if $group {
        File["${create_path}"]{
            group => $group,
        }
    } 
    if $mode {
        File["${create_path}"]{
            mode => $mode,
        }
    } 
}
