class postgres {
	package { [postgresql, ruby-postgres, postgresql-server]: ensure => installed }

    service { postgresql:
        ensure => running,
        enable => true,
        hasstatus => true,
        subscribe => [Package[postgresql-server], Package[postgresql]]
    }
}

# $Id$
