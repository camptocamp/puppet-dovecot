class c2c::openteam-devel inherits openerp::server::multiinstance {

  $openteam = ["nbessi", "jgrandguillaume", "lmaurer", "vrenaville", "gbaconnier", "fclementi"]

  c2c::sshuser::sadb { $openteam:
    ensure  => present,
    groups  => ["openerp"],
    require => User["openerp"]
  }
  
  File["/srv/openerp/instances"]{
    mode => 2775,
  }

  File["/srv/openerp/openerp-admin.py"] {
    mode => 775,
  }

  file {"/srv/openerp/":
    ensure  => directory,
    mode    => 2775,
    owner   => openerp,
    group   => openerp,
    require => User["openerp"],
  }
  
  common::concatfilepart {"00-sudoers":
    ensure      => present,
    file        => "/etc/sudoers",
    content     => "
    # File managed by Puppet - c2c::openteam-devel
    root     ALL=(ALL) NOPASSWD: ALL
    %openerp ALL=(ALL) NOPASSWD: /bin/su - openerp, /bin/su - postgres, /bin/su - www-data
    %openerp ALL=(ALL) NOPASSWD: /etc/init.d/openerp-multi-instances, /etc/init.d/openerp-web, /etc/init.d/openerp-server
    %openerp ALL=(ALL) NOPASSWD: /etc/init.d/postgresql-8.2, /etc/init.d/postgresql-8.3
    %openerp ALL=(ALL) NOPASSWD: /etc/init.d/apache2
    %openerp ALL=(ALL) NOPASSWD: /bin/kill
    %openerp ALL=(postgres) NOPASSWD: ALL
    %openerp ALL=(www-data) NOPASSWD: ALL
    ",
  }

  # as deploy script uses current user, we have to add tiny-men as superuser in postgres
  postgresql::user { $openteam:
    ensure      => present,
    superuser   => true,
  }
}
