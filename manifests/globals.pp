# globals.pp 

# main configuration
$nagios_root_dir="/etc/nagios3"
$nagios_cfg_dir="${nagios_root_dir}/auto-puppet"
$nagios_main_config_file="${nagios_root_dir}/nagios.cfg"

# web interface
$nagios_cgi_dir="/usr/lib/cgi-bin/nagios3"
$nagios_physical_html_path="/usr/share/nagios3/htdocs"
$nagios_stylesheets_dir="$nagios_root_dir/stylesheets" 
$nagios_show_context_help="0"

$nagios_nsca_password="taib2Dai"
$nagios_nsca_encryption_method="3"
$nagios_nsca_decryption_method="3"
$nagios_nsca_server="sa.camptocamp.com"
$nagiosadmin_password="nnotWHaxY0PsA"
$nagios_service_check_timeout="80"
$nagios_host_check_timeout="80"

$ldap_uri = "ldap://ldap.lsn.camptocamp.com ldap://ldap.cby.camptocamp.com"
$ldap_base = "dc=ldap,dc=c2c"
$openvz_kernel_version = "2.6.18"
#$the_guy_in_charge = "c2c.sysadmin@camptocamp.com"

## BUG: Better off moving that in the ssh module
#$sshd_config_src      = "puppet:///ssh-old/etc/ssh/sshd_config"
#$sshd_config_dest     = "/etc/ssh/sshd_config"
#$authorized_keys_src  = "puppet://sa.camptocamp.com/files/authorized_keys-autogen-c2cdev"
#$authorized_keys_dest = "/etc/ssh/authorized_keys"

$sites = "/etc/apache2/sites"
$mods = "/etc/apache2/mods"
$sync_authorized_keys_src = false 
$pam_config_dir = "/etc/pam.d"
$sig_packages_release = "20080225"
$smart_host = "mail.camptocamp.com"
$sadb = "http://sadb.camptocamp.com"

# Puppet configuration
$puppet_server = "c2cpc9.camptocamp.com"
$puppet_reportserver = "c2cpc9.camptocamp.com"
$puppet_client_version = "0.25.4-2~bpo50+1"
$puppet_server_version = "0.25.4-2~bpo50+1"
$facter_version = "1.5.1-0.2"

Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" }

filebucket { main: server => "mremy.int.lsn.camptocamp.com" }

# global defaults
File {
  backup => main,
  ignore => '.svn',
  owner  => root,
  group  => root,
}

$osdist = "${operatingsystem}-${lsbdistcodename}"

Package {
  provider => $operatingsystem ? {
    debian => apt,
    ubuntu => apt,
    redhat => up2date,
    centos => up2date
  },

  require => Exec["apt-get_update"]
}

## openerp settings
$openerp_db_name = ""
$openerp_db_user = "openerp-demo-camptocamp"
$openerp_db_password = "openerp-demo-camptocamp"
$openerp_db_host = "localhost"
$openerp_db_port = "5432"
$openerp_verbose = "False"
$openerp_pidfile = "/var/run/openerp.pid"
$openerp_logfile = "/var/log/openerp.log"
$openerp_interface = "localhost"
$openerp_port = "8069"
$openerp_netport = "8070"
$openerp_debug_mode = "False"
$openerp_secure = "False"
$openerp_smtp_server = "localhost"
$openerp_smtp_user = "False"
$openerp_smtp_password = "False"
## special things for openerp-sources
$openerp_source_owner = "openerp"
$openerp_source_group = "openerp"
## openerp web client settings
$openerp_web_port = "8080"
$openerp_web_environment = "production"
$openerp_web_protocol = "https"
$openerp_web_passwrd = "openerp-demo-camptocamp"
$openerp_web_baseurl = "http://tinyerp.camptocamp.com/"
$openerp_web_sockhost = "0.0.0.0"
## nagios default hostgroup
$hostgroup = "ovz-host"
