class app-eks-backups {
  include python::dev
  include monitoring::rdiff-backup 
  include rdiff-backup::server

  rdiff-backup::server::install {["0.13.4", "1.1.5", "1.2.1", "1.2.5"]: }

  rdiff-backup::conf {"app":
    version => "1.1.5",
    source  => "root@app::/",
    destination => "/srv/backup2/app",
    args => "--remote-schema 'ssh -i /root/.ssh/rdiff-backup-1.1.5.id_rsa %s' --exclude '/dev/*' --exclude '/proc/*' --exclude '/sys/*'",
    retention => "60D",
  }

  rdiff-backup::conf {"ecm":
    version => "1.2.1",
    source  => "root@ecm::/",
    destination => "/srv/backup2/ecm",
    args => "--remote-schema 'ssh -i /root/.ssh/rdiff-backup-1.1.5.id_rsa %s' --exclude '/dev/*' --exclude '/proc/*' --exclude '/sys/*'",
    retention => "60D",
  }

  rdiff-backup::conf {"home":
    version => "1.2.5",
    source  => "root@home::/",
    destination => "/srv/backup2/home",
    args => "--remote-schema 'ssh -i /root/.ssh/rdiff-backup-1.1.5.id_rsa %s' --exclude '/dev/*' --exclude '/proc/*' --exclude '/sys/*'",
    retention => "60D",
  }

  rdiff-backup::conf {"jungfrau":
    version => "1.2.5",
    source  => "root@jungfrau::/",
    destination => "/srv/backup2/jungfrau",
    args => "--remote-schema 'ssh -p 2222 -i /root/.ssh/rdiff-backup-1.1.5.id_rsa %s' --exclude '/dev/*' --exclude '/proc/*' --exclude '/sys/*' --exclude '/backup/rdiff-backup/*'",
    retention => "60D",
  }

  rdiff-backup::conf {"pe2500":
    version => "1.1.5",
    source  => "root@pe2500::/",
    destination => "/srv/backup2/pe2500",
    args => "--remote-schema 'ssh -i /root/.ssh/rdiff-backup-1.1.5.id_rsa %s' --exclude '/dev/*' --exclude '/proc/*' --exclude '/sys/*' --exclude '/backup/rdiff-backup/*' --exclude '/var/lib/vz/*' --exclude '/opt/data/vz/*'",
    retention => "60D",
  }

  rdiff-backup::conf {"prod":
    version => "1.2.5",
    source  => "root@prod::/",
    destination => "/srv/backup2/prod",
    args => "--remote-schema 'ssh -i /root/.ssh/rdiff-backup-1.1.5.id_rsa %s' --exclude '/dev/*' --exclude '/proc/*' --exclude '/sys/*'",
    retention => "60D",
  }

  rdiff-backup::conf {"scheidegg":
    version => "1.1.5",
    source  => "root@scheidegg::/",
    destination => "/srv/backup2/scheidegg",
    args => "--remote-schema 'ssh -i /root/.ssh/rdiff-backup-1.1.5.id_rsa %s' --exclude '/dev/*' --exclude '/proc/*' --exclude '/sys/*' --exclude '/backup/rdiff-backup/*' --exclude '/mnt/livelink/*' --exclude '/var/lib/vz/*' --exclude '/var/data/backup/*'",
    retention => "60D",
  }

  rdiff-backup::conf {"svn":
    version => "1.1.5",
    source  => "root@svn::/",
    destination => "/srv/backup2/svn",
    args => "--remote-schema 'ssh -i /root/.ssh/rdiff-backup-1.1.5.id_rsa %s' --exclude '/dev/*' --exclude '/proc/*' --exclude '/sys/*'",
    retention => "60D",
  }

  rdiff-backup::conf {"wetterhorn":
    version => "1.2.5",
    source  => "/",
    destination => "/srv/backup2/wetterhorn",
    args => "--exclude '/dev/*' --exclude '/proc/*' --exclude '/sys/*' --exclude '/srv/*'",
    retention => "60D",
  }

  file {"/usr/local/bin/check-rdiff":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0755,
    content => '#!/bin/bash
if [ -z $1 ]; then
  echo "Usage: $(basename $0) <version> <options>"
  exit 1
fi

rdiff_version=$(echo $@| awk \'{print $1}\')
rdiff_args=$(echo $@ | sed "s/$rdiff_version//")

if [ ! -d /opt/rdiff-backup/rdiff-backup-${rdiff_version} ]; then
  echo "Usage: $(dirname $0) <version> <options>"
  echo "Version ${rdiff_version} doesn\'t exists"
  exit 2
fi

export PYTHONPATH=/opt/rdiff-backup/rdiff-backup-${rdiff_version}/lib64/python2.5/site-packages
/opt/rdiff-backup/rdiff-backup-${rdiff_version}/bin/rdiff-backup ${rdiff_args}
',
  }

  file {"/root/.ssh/rdiff-backup-1.1.5.id_rsa":
    ensure => present,
    mode   => "0600",
    owner  => root,
    group  => root,
    content => "-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEA7TwJY0sRTMXWpxbmNZVCsjHoB4Ri6ThsdoR/H4BjkH+0Enaw
ccQ3pL0GLUh4dMi7QGAE0D/+gDedz9DVwts5KP23TyrUjxfLi7K6Gruun/q2RcHb
CYKbGRdad5ktXEuD0bTsKjnsF+08QybHUr0n/DoAZYrQTrQcgAokFnJuGnmCnhJH
/PenE8a3f7Xz9JNIvv3CtBLmvvHh9vyBsNbeKFWkTouuoiix2c5+8xRNZRMfXTAM
iH6MHmT9N1nX/8MPpq6h2Kl9V/rauXq2mB5oN3re+wSiEkW/XaflpW5wSziPIXX9
TKHks6UCQm1IiSneRs7YpwQ1OdUUf4N/FtM6OwIBIwKCAQB6AZ5tlFIKOdwbatzL
GZAD3ybfS2YRirtwJuJKtw6iFcpSo3CviXuzzu073CCxFsazZJTC3xUr/1h5gVf9
z9RA94LYQemorSbaIWcGbyabav6niETDD/f+RoZMIuQg1mEMw3IkWE2IpeR6TnUj
PLV6Zvjjw7uWML4zOGpUr+DaaWLIVvriTlO+WlLRXd0isAajn7eBQ6rMsqgRq+f1
y2sL29K4Po1JwiPA+pkFUSjd4Vl/hMJsoHmwNOnEiGNdrn9e6Bwp/dDX9449I3fE
Kpx54tGOdVH3sMD/J/pxSrJ2BfN+ogT5cqiNUq01VRiEd9V3I18eoc+JlGN+BFRL
tT97AoGBAP+drZLhFy/8UNhLOzi6DuELzJ6AVZ5DiEoCDpQAt3/E739DZzUq1BYS
3xneGsJMvBYtluL9wyTwWuH76Oz6uy8LwYAE11Zt43XhAociDR7tRWQOlCDc80NR
I6012aHn6emXGeT9LBCrSqgiCAKINi6W34sERw08yPq35Z5OdvKXAoGBAO2XSc1H
ZJteOAVIC1Ran+kDQbEqK3xfKqZ9PBxuog4+HkQzHJ+gzOR6XXRuMRD3INspbFop
SnqQTeLn9fDrUQViYrIs1mYptgkoszhcMDV5pxxXb/AMlz2qmgpaZx4MCi+iWfIx
iKi8q16qeLLGfHQr1TEgEL8cMq2n6ssYtL39AoGBAPhQB7NBDzXtyuC+HEW8DnQ3
WQ8AUywHFq5LJBq+3iRY6KeDTlDnxrZbeaQZllZZK73F4whkOelehCv8BteUe1JF
7yvnchlyEClePPhM9s2WCOTa9kvPUrZsFAdY4gr+i3UzssEwc/LvilovsAJ1sPoO
58jflXqS0d2csywRtWCvAoGAejCMWvGEMqV75XWCK2HOlReeIJlYMVWDphSFUHNp
SSdCw/0HaAmN8diH1Xp/olM1eAaswKeFY5qrtoXsMsIpqv9l9Tuhdl6YIfesoKRw
kIe1B0LpHF4/JwdH6BE8WJh6RGIfoSDJ8GEHrQc2wldzNG5QYmhDIHTm3PdFjQVk
RHMCgYEAkQzHh0JVBUMyqBor+6uUviYtg6wiKPMnw2fEkKIbrPmjyEyDbpgwDsC8
wj6lff1kIICRMwJBYieey76OQzUVYzuSOAH8Y8cszmBMvP46Ao2No01H5EAsW5Fo
qV6ppDYDmKOOzyQD7PMpwrp/8d5KkNyY0jepoLKITMO3t0FWlrQ=
-----END RSA PRIVATE KEY-----
",
  }

  file {"/usr/local/sbin/sync-to-usb":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0755,
    content => '#!/bin/bash
# Check for root
if [ `id -u` -gt 0 ]
    then echo "not root"; exit
fi
TODAY=$(date +%d-%m-%Y)
exec > /var/log/rdiff-backup/rsync_usbhd-$TODAY.log 2>&1
mount /mnt/external
if [ $? -ne 0 ]; then
  echo "FATAL: unable to mount LABEL=EXTERNAL"
  exit 1
fi

nice -n 10 rsync -a --delete --delete-excluded --stats /srv/backup2/* /mnt/external/
df -h /mnt/external
umount /mnt/external
exit 0
',
  }

  cron {"sync to usb":
    ensure  => present,
    user    => root,
    hour    => 4,
    minute  => 30,
    command => "/usr/local/sbin/sync-to-usb",
    require => File["/usr/local/sbin/sync-to-usb"],
  }
}
