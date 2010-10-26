class mw-puppet-client inherits puppet::client {

  $puppet_client_version = $operatingsystem ? {
    RedHat => "0.25.5-1.el${lsbmajdistrelease}",
    Debian => "0.25.5-1~c2c+1",
  }

  $facter_version = $operatingsystem ? {
    RedHat => "1.5.8-1.el${lsbmajdistrelease}",
    Debian => "1.5.7-1~c2c+3",
  }

  $augeas_version = $operatingsystem ? {
    RedHat => $lsbmajdistrelease ? {
      5 => "0.7.2-2.el${lsbmajdistrelease}",
      4 => "0.7.2-1.el${lsbmajdistrelease}",
    },
    Debian => $lsbdistcodename ? {
      lenny   => "0.7.2-1~bpo50+1",
      squeeze => "0.7.2-1",
    },
  }

  case $operatingsystem {
    Debian: {
      case $lsbdistcodename {
        /lenny|squeeze/ :   { 
         
          $pkgrepo = $repository ? {
            'stable'  => 'prod',
            'staging' => 'staging',
          }

          if !defined (Apt::Sources_list["pkg-camptocamp-${lsbdistcodename}-${pkgrepo}-sysadmin"]) {
            apt::sources_list {"pkg-camptocamp-${lsbdistcodename}-${pkgrepo}-sysadmin":
              ensure  => present,
              content => "deb http://pkg.camptocamp.net/${pkgrepo} ${lsbdistcodename} sysadmin\n",
            }
          }  
          
          if $lsbdistcodename == "lenny" and !defined (Apt::Sources_list["pkg-camptocamp-${lsbdistcodename}-${pkgrepo}-sysadmin"]) {
            apt::sources_list {"pkg-camptocamp-${lsbdistcodename}-backport-${pkgrepo}":
              ensure  => present,
              content => "deb http://pkg.camptocamp.net/${pkgrepo} ${lsbdistcodename}-backports main contrib non-free\n",
            }
          }

          apt::preferences {
            "facter":
              ensure   => present, 
              pin      => "version ${facter_version}", 
              priority => 1100;
            
            ["augeas-lenses","augeas-tools", "libaugeas0"]:
              ensure   => present,
              pin      => "version ${augeas_version}",
              priority => 1100;
            
            ["puppet", "puppet-common","vim-puppet", "puppet-el"]:
              ensure   => present,
              pin      => "version ${puppet_client_version}",
              priority => 1100;
          } 

          package {["puppet-common","vim-puppet", "puppet-el"]:
            ensure  => $puppet_client_version,
            require => Apt::Sources_list["pkg-camptocamp-${lsbdistcodename}-${pkgrepo}-sysadmin"],
            tag     => "install-puppet",
          }
          
          Package["puppet", "facter"] {
            require +> Apt::Sources_list["pkg-camptocamp-${lsbdistcodename}-${pkgrepo}-sysadmin"],
          }
     
        }
      }
    }
  } 
}
