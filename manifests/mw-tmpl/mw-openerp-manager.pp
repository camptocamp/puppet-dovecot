# install openerp manager
#
# Requires: mw-openerp-hosted
# Provides: 
# Conflicts: 
#

class mw-openerp-manager {

  package {"python-pylons":
    ensure => present,
  }

  apache::directive {"openerp-manager":
    vhost => $openerp_project,
    directive => "# file managed by puppet
RewriteEngine On
RewriteCond   %{HTTPS} off
RewriteRule   ^/(.*)$ https://%{SERVER_NAME}/$1 [L]
RewriteRule ^/$ https://%{SERVER_NAME}/admin/

ProxyPass /admin http://localhost:9090/admin/
ProxyPassReverse /admin http://localhost:9090/admin/
<Proxy *>
  Order allow,deny
  Allow from All
</Proxy>
",
  }

  bazaar::checkout {"openerp-manager":                                                                                                                                                                                              
    ensure => present,                                                                                                                                                                                                              
    local  => "/var/www/${openerp_project}/private/openerp-manage",
    remote => 'https://c2c_tinyerp:Aevei8ae@project.camptocamp.com/bzr/c2c_tinyerp/c2c/tools/openerp-manager',
    update => true,
    notify => Service["openerp-manage"],
  }

  file {[
    "/var/www/${openerp_project}/private/openerp-manage/data",
    "/var/www/${openerp_project}/private/openerp-manage/data/templates",
    "/var/www/${openerp_project}/private/openerp-manage/data/sessions",
    "/var/www/${openerp_project}/private/paster-logs",
    ]:
    ensure => directory,
    mode   => 0755,
    owner  => www-data,
    group  => www-data,
    require => Bazaar::Checkout["openerp-manager"],
  }

  file {"/etc/init.d/openerp-manage":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0755,
    require => File["/var/www/${openerp_project}/private/paster-logs"],
    content => template('c2c/openerp-manage.init.erb'),
  }

  service{"openerp-manage":
    ensure  => running,
    pattern => "/usr/bin/python /usr/bin/paster serve --reload --log-file /var/www/${openerp_project}/private/paster-logs/paster.log --server-name=main production.ini",
    require => [File["/etc/init.d/openerp-manage"], Package["python-pylons"]],
  }

  common::concatfilepart{"www-data rights":
    file   => "/etc/sudoers",
    ensure  => present,
    content => "www-data ALL=(ALL) NOPASSWD: /usr/local/bin/qa-replicate,/etc/init.d/openerp-multi-instances,/usr/local/bin/integration-replicate\n",
  }

  file {"/var/www/${openerp_project}/htdocs/c2c.png":
    ensure => "/var/www/${openerp_project}/private/openerp-manage/openerpmanage/public/c2c.png",
  }

  file {"/var/www/${openerp_project}/htdocs/site.css":
    ensure => "/var/www/${openerp_project}/private/openerp-manage/openerpmanage/public/site.css",
  }

  file {"/var/www/${openerp_project}/htdocs/jquery.js":
    ensure => "/var/www/${openerp_project}/private/openerp-manage/openerpmanage/public/jquery.js",
  }

  file {"/var/www/${openerp_project}/htdocs/openerp_slogan.png":
    ensure => "/var/www/${openerp_project}/private/openerp-manage/openerpmanage/public/openerp_slogan.png",
  }

  file {"/var/www/${openerp_project}/htdocs/fondgris.png":
    ensure => "/var/www/${openerp_project}/private/openerp-manage/openerpmanage/public/fondgris.png",
  }

  exec {"link images":
    command => "ln -s /var/www/${openerp_project}/private/openerp-manage/openerpmanage/public/icons/* /var/www/${openerp_project}/htdocs/",
    creates => "/var/www/${openerp_project}/htdocs/english.png",
    require => Bazaar::Checkout["openerp-manager"],
  }


  $admin_mdp = generate("/usr/bin/pwgen", "10", "1")

  file {"/var/www/openerp-manage.conf":
    ensure => present,
    replace => false,
    owner  => www-data,
    group  => openerp,
    mode   => 0640,
    require => Bazaar::Checkout['openerp-manager'],
    content => "[config]
password = $admin_mdp
project = $openerp_project
email = $openerp_client_contact
    "
  }

  # PDF "formation"
  file {"/var/www/${openerp_project}/htdocs/Formation_fr.pdf":
    ensure => link,
    mode  => 0644,
    source => "/var/www/${openerp_project}/private/openerp-manage/docs/Formation_fr.pdf",
    require => [Apache::Vhost-ssl["$openerp_project"],Bazaar::Checkout["openerp-manager"]],
  }                   

}
