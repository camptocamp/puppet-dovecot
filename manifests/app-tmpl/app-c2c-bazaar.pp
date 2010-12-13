class app-c2c-bazaar {
  include bazaar::server

  package {"tree": }

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


  c2c::bazaar{
      "aesa_tinyerp":       ro_pwd => "co3Ee7ii";
      "c2c_tinyerp":        ro_pwd => "Aevei8ae";
      "conventus_tinyerp":  ro_pwd => "Boh5OW9u";
      "debethune_tinyerp":  ro_pwd => "Pohh4itu";
      "dnag_tinyerp":       ro_pwd => "ur1ohDie";
      "duetschler_tinyerp": ;
      "ecointesys_tinyerp": ro_pwd => "ga6ahC4k";
      "esecure_tinyerp":    ro_pwd => "Eesit0ah";
      "geste_tinyerp":      ro_pwd => "hev9ooRe";
      "iem_tinyerp":        ro_pwd => "bo0ouTh2";
      "irmicrosystems_tinyerp":   ro_pwd => "Ia6Quiez";
      "locatellifritsch_tinyerp": ro_pwd => "yahNai2a";
      "meditron_openerp":   ro_pwd => "aik1ieNg";
      "meditron_tinyerp":   ro_pwd => "Em5zi2on";
      "msf_openerp":        ro_pwd => "xahJai9t";
      "oenocap_tinyerp":    ro_pwd => "Imo5ju9t";
      "peg_tinyerp":        ro_pwd => "ceegie4O";
      "pse_tinyerp": ;
      "secretatelier_openerp": ;
      "c2c_internal_tinyerp":  ro_pwd => "Ko2aijoh";
      "solstis_openerp":    ro_pwd => "Thei2tho";
      "swisscom_openerp":   ro_pwd => "iiPhi3ah";
      "accessible_openerp": ro_pwd => "taiyiuP8";
      "akatech_openerp":    ro_pwd => "Ahsie3ah";
      "merckserono_openerp": ro_pwd => "Im9bo9ah";
      "machinevision_openerpsupport": ro_pwd => "uSMpEjWti2JF";
      "vogelvins_openerp": ro_pwd => "peFee4ai"; 
      "sensimed_openerp":  ro_pwd => "HlpyVq2crQ";
      "fasteris_openerp": ;
      "scalena_cosmeticopenerp": ro_pwd => "uYe3aeta";
      "aeschlimann_openerp": ro_pwd => "Ob8xi8ga";
      "geste_openerp": ro_pwd => "hev9ooRe";
      "sitn_proto_mapfish": ensure => absent;
      "vaudsr_openerpmaquette": ro_pwd => "Thie9Nae";
      "c2c_hosted_openerp": ;
      "panoramapl_openerp":  ro_pwd => "ahga6Zae";
      "scalena_motoopenerp": ro_pwd => "eiZ7aBee";
      "subsun_openerp":  ro_pwd => "ohShie9n";
      "easy_openerp":    ro_pwd => "Uyi4Ai2u";
      "mecatis_openerp": ro_pwd => "thae5iVu";
      "aesa_openerp":    ro_pwd => "ohph4Za3";
      "esecure_openerp": ro_pwd => "aizi3Tot";
      "wingo_openerp":   ro_pwd => "tacie7Ou";
      "iem_openerp":     ro_pwd => "aeFaigh3";
      "outilmania_openerp": ro_pwd => "phiePhi1";
      "debonix_openerp": ro_pwd => "Gihau1Ie";
      "toradex_openerp": ;
      "modec_openerp": ;
  }
}
