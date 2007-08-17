# Create a new subversion repository.
define svnrepo($path) {
    exec { "create-svn-$name":
        command => "/usr/bin/svnadmin create $path/$name",
        creates => "$path/$name"
    }
}

# $Id: svnrepo.pp 191 2006-08-30 06:08:09Z luke $
