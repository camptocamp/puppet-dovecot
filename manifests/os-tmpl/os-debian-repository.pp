#
# == Template: os-debian-repository
#
# Cette classe met en place les principaux repositories utilisés par Camptocamp
#  - officiel Debian
#  - paquets réalisés par Camptocamp (spécifique infra, component sysadmin)
#  - debian-backports consolidé par Camptocamp
# 
# Dépendances:
#  - module camptocamp/puppet-apt
#
# Attention:
#  - il y a volontairement pas de "if !defined" pour les ressources afin 
#    de s'assurer qu'elle sont uniquement déclarées dans cette classe et pas ailleurs
#  - les paquets backports consolidés sont automatiquement "pinés" à 1 grâce au champ 
#    "NotAutomatic: yes" spécifié dans la distribution à la manière des dépôts backports 
#    et experimental de Debian. Il faut donc explicitement mettre un "Pin-Priority" > 1000
#    pour les utiliser.
#  - seul les paquets "backports" nécessaires sont présents dans notre repository. L'ajout de 
#    paquets se fait via les recettes du node "pkg.camptocamp.net" (c2cpc6)
#
# Todo:
#  - eventuellement ajouter les clefs officielles Debian qui sont mises en place à l'installation
#
class os-debian-repository {

  case $lsbdistcodename {
    /lenny|squeeze/: {

      apt::sources_list { "$lsbdistcodename":
        content => "# file managed by puppet
deb http://mirror.switch.ch/ftp/mirror/debian/ ${lsbdistcodename} main contrib non-free
deb http://mirror.switch.ch/ftp/mirror/debian-security/ ${lsbdistcodename}/updates main contrib non-free
",
      } 

      apt::key {"5C662D02":
        source  => "http://pkg.camptocamp.net/packages-c2c-key.gpg",
      }

      apt::sources_list {"c2c-${lsbdistcodename}-${repository}-sysadmin":
        ensure  => present,
        content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename} sysadmin\n",
        require => Apt::Key["5C662D02"],
      }
      
      # squeeze-backports n'existera que quand squeeze passera en stable
      if $lsbdistcodename == "lenny" {
        apt::sources_list {"c2c-${lsbdistcodename}-${repository}-backports":
        ensure  => present,
        content => "deb http://pkg.camptocamp.net/${repository} ${lsbdistcodename}-backports main contrib non-free\n",
        require => Apt::Key["5C662D02"],
        }
      }
    }

    default: { fail "os-debian-repository not available for ${operatingsystem}/${lsbdistcodename}"}
  
  } 

}
