# manifests/basics.pp

# some basics directory setups for a server
class subversion::basics {
    file{'/srv/svn':
        ensure => directory,
        owner => root, group => 0, mode => 0755;
    }
}
