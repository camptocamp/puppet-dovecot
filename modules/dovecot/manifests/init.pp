# modules/dovecot/manifests/init.pp - Install and configure dovecot, the secure
# mail/IMAP/POP3 server that supports mbox and maildir mailboxes
#
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.
#

class dovecot {

	user { dovecot: 
		allowdupe => false,
		comment => "Dovecot mail server",
		ensure => present,
		gid => 201,
		home => "/usr/lib/dovecot",
		shell => "/bin/false",
		uid => 201,
	}

	group { dovecot:
		allowdupe => false,
		ensure => present,
		gid => 201
	}

	package { [ "dovecot-common", "dovecot-imapd", "dovecot-pop3d" ]:
		ensure => installed,
		require => [ User[dovecot], Group[dovecot] ],
	}

	file { 
		"/etc/dovecot/dovecot.conf":
			mode => 0644, owner => root, group => root,
			require => Package[dovecot-common],
			notify => Service[dovecot];
	}

	service { dovecot:
		ensure => running,
		pattern => dovecot,
		require => [ Package["dovecot-imapd"], Package["dovecot-pop3d"] ]
	}

}

class dovecot::ldap inherits dovecot
{
	$ldap_suffix = dn_from_domain( $domain )

	File["/etc/dovecot/dovecot.conf"] {
		source => "puppet:///modules/dovecot/dovecot.ldap.conf",
	}

	file {
		"/etc/dovecot/dovecot-ldap.conf":
			content => template("dovecot/dovecot-ldap.conf"),
			mode => 0600, owner => root, group => root,
			require => Package[dovecot-common],
			notify => Service[dovecot],
	}

}

class dovecot::pam inherits dovecot
{

	File["/etc/dovecot/dovecot.conf"] {
		source => "puppet:///modules/dovecot/dovecot.pam.conf",
	}

}
