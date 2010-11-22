define trac::instance (
    $ensure,
    $basedir = "/srv/trac/projects",
    $repository = false,
    $templates = "/usr/share/trac/templates",
    $cgipath = false,
    $navadd = false,
    $cc,
    $description,
    $db = "sqlite:db/trac.db",
    $owner = "www-data",
    $group = "www-data",
    $url,
    $repobase = "/srv/svn/repos",
    $replyto = "trac@$domain",
    $from = "trac@$domain",
    $logo = "/tracdocs/trac_banner.png",
    $alt = $domain,
    $smtpserver = "mail.$domain",
    $repostype = "svn",
    $slash = false,
    $mode = 0755
) {
    $repo = $repository ? {
        false => "$repobase/$name",
        default => $repository
    }
    $tracdir = "$basedir/$name"
    $config = "$tracdir/conf/trac.ini"

    $anon_permissions = "BROWSER_VIEW CHANGESET_VIEW FILE_VIEW LOG_VIEW MILESTONE_VIEW REPORT_SQL_VIEW REPORT_VIEW ROADMAP_VIEW SEARCH_VIEW TICKET_VIEW TIMELINE_VIEW WIKI_VIEW"
    $authenticated_permissions = "anonymous TICKET_APPEND TICKET_CHGPROP TICKET_CREATE TICKET_MODIFY WIKI_CREATE WIKI_MODIFY"
    $developer_permissions = "authenticated"
    $admin_permissions = "TRAC_ADMIN"

    # Create the app
    exec { "tracinit-$name":
        command => $lsbdistcodename ? { lenny => "trac-admin $tracdir initenv $name $db $repostype $repo && rm ${config}", default => "trac-admin $tracdir initenv $name $db $repostype $repo $templates && rm ${config}" },
        path => "/usr/bin:/bin:/usr/sbin",
        logoutput => false,
        creates => $tracdir,
        require => [Package["trac"], File[$basedir]],
    }

    # Chown it to www-data
    file { $tracdir:
        owner => $owner,
        group => $group,
        require => Exec["tracinit-$name"],
        mode    => $mode,
    }

    # Rewrite the config
    file { $config:
        owner => $owner,
        group => $group,
        content => template("trac/tracconfig.erb"),
        replace => false,
        require => Exec["tracinit-$name"]
    }

    # Clear default permissions
    exec { "init-$name-trac-clear-permissions":
      command     => "trac-admin $tracdir permission remove * *",
      refreshonly => true,
      before      => [Exec["init-$name-trac-authenticated-permissions"], Exec["init-$name-trac-dev-permissions"], Exec["init-$name-trac-anon-permissions"], Exec["init-$name-trac-admin-permissions"]],
      subscribe   => Exec["tracinit-$name"],
    }

    exec { "init-$name-trac-authenticated-permissions":
       command => "trac-admin $tracdir permission add authenticated $authenticated_permissions",
       refreshonly => true,
       subscribe => Exec["tracinit-$name"],
    }

    exec { "init-$name-trac-dev-permissions":
       command => "trac-admin $tracdir permission add developer $developer_permissions",
       refreshonly => true,
       subscribe => Exec["tracinit-$name"],
    }

    exec { "init-$name-trac-anon-permissions":
       command => "trac-admin $tracdir permission add anonymous $anon_permissions",
       refreshonly => true,
       subscribe => Exec["tracinit-$name"],
    }

    exec { "init-$name-trac-admin-permissions":
       command => "trac-admin $tracdir permission add admin $admin_permissions",
       refreshonly => true,
       subscribe => Exec["tracinit-$name"],
    }
}
