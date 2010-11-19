class mw-easy-openerp {

  bazaar::checkout {"easy_openerp.dump":
    ensure  => present,
    local   => "/srv/openerp/DumpDB",
    remote  => "https://c2c_tinyerp:Aevei8ae@project.camptocamp.com/bzr/c2c_tinyerp/c2c/tools/DumpDB/",
    update  => false,
    require => User["openerp"],
  }

  file {"/srv/openerp/easy_openerp.dump.gz":
    ensure => "/srv/openerp/DumpDB/easy_openerp.sql",
  }

  file {"/etc/postgresql/8.3/main/pg_hba.conf":
    ensure  => present,
    owner   => "postgres",
    group   => "postgres",
    mode    => 0640,
    notify  => Service["postgresql"],
    content => "
# Database administrative login by UNIX sockets
local   all         postgres                          ident sameuser

# TYPE  DATABASE    USER        CIDR-ADDRESS          METHOD

# local is for Unix domain socket connections only
local   all         openerp_easy                       trust
local   all         all                                ident sameuser
# IPv4 local connections:
host    all         all          127.0.0.1/32          md5
# IPv6 local connections:
host    all         all          ::1/128               md5

",
  }

  file {"/etc/init.d/openerp-web":
    ensure => "/srv/openerp/instances/openerp_easy/src/web-client/scripts/openerp-web",
  }
  service {"openerp-web":
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    pattern    => "openerp-web.py",
    enable     => true,
    require    => File["/etc/init.d/openerp-web"],
  }

}
