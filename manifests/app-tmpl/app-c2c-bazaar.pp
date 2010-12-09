class app-c2c-bazaar {
  include bazaar::server

  group {"c2cdev":
    ensure => present,
  }

  $openteam = ["nbessi", "jgrandguillaume", "lmaurer", "vrenaville", "gbaconnier", "fclementi"]

  c2c::sshuser::sadb { $openteam:
    ensure  => present,
    groups  => ["c2cdev"],
    require => Group["c2cdev"]
  }

  apache::vhost-ssl {"bazaar":
    ensure  => present,
    group   => c2cdev,
    mode    => 2770,
    aliases => [$fqdn, "bazaar.camptocamp.com", "bazaar.camptocamp.net"],
  }

  apache::directive {"slash":
    ensure => present,
    vhost  => "bazaar",
    directive => 'Alias /bzr /srv/bzr

<Directory /bzr>
  Order Allow,Deny
  Allow from All
</Directory>

RewriteEngine On
RewriteRule ^/$ /bzr [R=302]

RewriteCond %{HTTPS} off
RewriteRule ^/(.)*$ https://%{HTTP_HOST}/$1
',
  }

  apache::directive {"no external access":
    ensure => present,
    vhost  => "bazaar",
    directive => "<Location /bzr/c2c_tinyerp>
  Order Deny,Allow
  Deny from All
  Allow from 128.178.66. # all C2C public IPs
  Allow from 10.27.10.   # wrk.lsn
  Allow from 10.26.10.   # wrk.cby
  Allow from 10.27.21.   # dmz.lsn
</Location>
",
  }


  file {
    [
      "/srv/bzr/aesa_tinyerp",
      "/srv/bzr/c2c_tinyerp",
      "/srv/bzr/conventus_tinyerp",
      "/srv/bzr/debethune_tinyerp",
      "/srv/bzr/dnag_tinyerp",
      "/srv/bzr/duetschler_tinyerp",
      "/srv/bzr/ecointesys_tinyerp",
      "/srv/bzr/esecure_tinyerp",
      "/srv/bzr/geste_tinyerp",
      "/srv/bzr/iem_tinyerp",
      "/srv/bzr/irmicrosystems_tinyerp",
      "/srv/bzr/locatellifritsch_tinyerp",
      "/srv/bzr/meditron_openerp",
      "/srv/bzr/meditron_tinyerp",
      "/srv/bzr/msf_openerp",
      "/srv/bzr/oenocap_tinyerp",
      "/srv/bzr/peg_tinyerp",
      "/srv/bzr/pse_tinyerp",
      "/srv/bzr/secretatelier_openerp",
      "/srv/bzr/c2c_internal_tinyerp",
      "/srv/bzr/solstis_openerp",
      "/srv/bzr/swisscom_openerp",
      "/srv/bzr/accessible_openerp",
      "/srv/bzr/akatech_openerp",
      "/srv/bzr/merckserono_openerp",
      "/srv/bzr/machinevision_openerpsupport",
      "/srv/bzr/vogelvins_openerp",
      "/srv/bzr/sensimed_openerp",
      "/srv/bzr/fasteris_openerp",
      "/srv/bzr/scalena_cosmeticopenerp",
      "/srv/bzr/aeschlimann_openerp",
      "/srv/bzr/geste_openerp",
      "/srv/bzr/sitn_proto_mapfish",
      "/srv/bzr/vaudsr_openerpmaquette",
      "/srv/bzr/c2c_hosted_openerp",
      "/srv/bzr/panoramapl_openerp",
      "/srv/bzr/scalena_motoopenerp",
      "/srv/bzr/subsun_openerp",
      "/srv/bzr/easy_openerp",
      "/srv/bzr/mecatis_openerp",
      "/srv/bzr/aesa_openerp",
      "/srv/bzr/esecure_openerp",
      "/srv/bzr/wingo_openerp",
      "/srv/bzr/iem_openerp",
      "/srv/bzr/outilmania_openerp",
      "/srv/bzr/debonix_openerp",
    ]:
    ensure => directory,
    group  => "c2cdev",
    owner  => "www-data",
    mode   => 2770,
    require => Group["c2cdev"],
  }
}
