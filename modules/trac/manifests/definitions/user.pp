define trac::user($path, $permissions) {
    exec { "init-$name-trac-authenticated-permissions":
        command => "trac-admin $path permission add $name $permissions",
        refreshonly => true,
        subscribe => Exec["tracinit-$name"],
    }
}

# $Id$
