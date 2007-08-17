# Serve subversion-based code from a local location.  The job of this
# module is to check the data out from subversion and keep it up to
# date, especially useful for providing data to your Puppet server.
#
# Example usage:
#   svnserve { dist:
#       source => "https://reductivelabs.com/svn",
#       path => "/dist",
#       user => "puppet",
#       password => "mypassword"
#   }
define svnserve($source, $path, $user = false, $password = false) {
    file { $path:
        ensure => directory,
        owner => root,
        group => root
    }
    $svncmd = $user ? {
        false => "/usr/bin/svn co --non-interactive $source/$name .",
        default => "/usr/bin/svn co --non-interactive --username $user --password '$password' $source/$name ."
    }   
    exec { "svnco-$name":
        command => $svncmd,
        cwd => $path,
        require => File[$path],
        creates => "$path/.svn"
    }
    exec { "svnupdate-$name":
        command => "/usr/bin/svn update",
        require => Exec["svnco-$name"],
        onlyif => '/usr/bin/svn status -u --non-interactive | /bin/grep "\*"',
        cwd => $path
    }
}

# $Id: svnserve.pp 202 2007-02-12 04:17:02Z luke $
