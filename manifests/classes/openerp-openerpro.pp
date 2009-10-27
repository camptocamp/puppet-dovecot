class c2c::openerp-ro {
  user {"openerp_ro":
    ensure     => present,
    comment    => "user created for ssh tunnels only",
    shell      => "/usr/sbin/nologin",
    managehome => true,
  }

  if $openerp_ro_passwd {
    $password = $openerp_ro_passwd
  } else {
    $pasword = 'openerp_ro'
  }

  postgresql::user {"openerp_ro":
    password => $password,
    ensure   => present,
  }

  file {"/usr/local/sbin/openerp-ro-rights":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0755,
    content => '#!/bin/bash
dbvar=$1
>/tmp/tmp.sql
psql -A -t -c "select \'grant select on \'||tablename||\' to openerp_ro ;\' from pg_tables where tablename != \'res_users\';" $dbvar >>/tmp/tmp.sql
psql -A -t -c "select \'grant select on \'||viewname||\' to openerp_ro ;\' from pg_views;" $dbvar >>/tmp/tmp.sql
psql -A -t -c "select \'grant select on \'||relname||\' to openerp_ro ;\' from  pg_statio_all_sequences;" $dbvar >>/tmp/tmp.sql
cat /tmp/tmp.sql |psql $dbvar
',
  }

}
