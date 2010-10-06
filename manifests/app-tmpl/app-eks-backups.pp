class app-eks-backups {
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
    version => "1.1.5",
    source  => "root@jungfrau::/",
    destination => "/srv/backup2/jungfrau",
    args => "--remote-schema 'ssh -i /root/.ssh/rdiff-backup-1.1.5.id_rsa %s' --exclude '/dev/*' --exclude '/proc/*' --exclude '/sys/*' --exclude '/backup/rdiff-backup/*'",
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
}
