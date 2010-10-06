# Server type used on node !insert node name here!
#

class srv-eks-wetterhorn {

  ### Global attributes ##########################
  $server_group = "prod" #(one of dev, demo or prod)
  $is_external = true
  $ps1label = "eks backups"
  $rdiff_backup_max_threads = 2
  $rdiff_backup_logs_dir = "/var/log/rdiff-backups"
  $rdiff_backup_backupdir = "/srv/backup2"
  $rdiff_backup_enable_mail = 0
  $rdiff_backup_smtp_server = "localhost"

  ### OS #########################################
  include os-base
  include os-server

  ### MW #########################################


  ### APP (generic) ##############################
  include app-eks-wetterhorn
  include app-eks-backups
}
