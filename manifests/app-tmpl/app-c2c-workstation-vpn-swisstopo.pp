class app-c2c-workstation-vpn-swisstopo {

  common::archive{"APPGclnt":
    ensure     => present,
    url        => "http://appgate.admin.ch/clients/Linux/agclient.i386.tar.bz2",
    target     => "/",
    extension  => 'tar.bz2',
    checksum   => false,
    root_dir   => "opt/APPGclnt",
  }

  common::archive{"agiptd-1.5":
    ensure => present,
    url    => "http://appgate.admin.ch/clients/Linux/agiptd.i386.tar.bz2",
    target     => "/opt",
    extension  => 'tar.bz2',
    checksum   => false,
  }

  file {"/etc/init.d/agiptd":
    ensure => "/opt/agiptd-1.5/ag_iptd.init",
    require => Common::Archive["agiptd-1.5"],
  }
  
  file {"/opt/agiptd-1.5/ag_iptd.init":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 755,
    content => '#! /bin/sh
# file managed by puppet
#
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/opt/agiptd-1.5/ag_iptd
OPTS=""
NAME=ag_iptd
DESC="AppGate IP Tunneling Daemon"

test -x $DAEMON || exit 0

[ "$launch" = 0 ] && exit 0

set -e

case "$1" in
  start)
        echo -n "Starting $DESC: "
        $DAEMON $OPTS
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        pkill ag_iptd
        echo "$NAME."
        ;;
  restart)
        echo -n "Restarting $DESC: "
        pkill ag_iptd
        sleep 2
        $DAEMON $OPTS
        echo "$NAME."
        ;;
  *)
        N=/etc/init.d/$NAME
        echo "Usage: $N {start|stop|restart}" >&2
        exit 1
        ;;
esac

exit 0
    ',
  }

  service {"agiptd":
    ensure => running,
    enable => true,
    require => Common::Archive["agiptd-1.5"],
  }

  file {"/usr/share/applications/appgate.desktop":
    ensure  => present,
    content => "#file managed by puppet
[Desktop Entry]
Encoding=UTF-8
Name=AppGate-Client
Comment=Swisstopo AppGate Client
Exec=/opt/APPGclnt/bin/agclient
Terminal=false
Type=Application
Icon=/usr/share/icons/hicolor/32x32/apps/vinagre.png
Categories=Application;System;
    ",
    mode   => 644,
  }

}
