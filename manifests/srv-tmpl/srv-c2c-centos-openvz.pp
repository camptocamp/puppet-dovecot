class srv-c2c-centos-openvz {
  ### Global attributes ##########################
  $ps1label = "openvz HN"
  $server_group = "prod"
  $basic_contact_group = "admins"
  $root_mail_recipient = "c2c.sysadmin@camptocamp.com"
  $postfix_relayhost = "mail.camptocamp.com"

  ### OS #########################################
  include os-base
  include os-monitoring
  include os-openvz
  include os-openvz-centos
  
  ### MW #########################################
  include postfix::satellite

  ### APP #######################################
  include app-openvz-server-nfs

  include app-c2c-centos-openvz
}
