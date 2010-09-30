# Requires:
#

class os-base {

  include os
  include ssh
  include augeas
  include subversion
  include c2c::sysadmin-in-charge-new
  include c2c::skel
  include sudo::base
  include puppet::client

  ssh_authorized_key {"rdiff-backup":
    ensure  => present,
    user    => root,
    options => ['command="/usr/local/sbin/sajama-command-file.py"',"no-pty","no-port-forwarding","no-X11-forwarding"],
    type    => "ssh-rsa",
    key     => "AAAB3NzaC1yc2EAAAABIwAAAQEAyygqhBCEp2kRbZgs/a1Vj72QGGiV7QgOi/yEB7Bo1Ek0eHoK35AGUtM/IwsdjRT41VjzcDx616qXlKlHCL/MKiZYqYZ1XH529BSQCXfRa+IF80u42pRgUORLUCrPqDc3VGmRZaciMNCC0Ko3IBgNj+diDPtApg/VDZYe1qkzURbajDipn+ESONWJW/S91BA0czyTMhIoxUTmIfK7+f/Al1DwaCy8AIFq63KivU+re7ruh4rIUgeWXd1C8CnTzwKjpQpNphOq0TCsK2kOddimaaj9Rhvy1lpABk0MvagXr6wG/vf9kYDsAmht8ROLMHj85IwauY6DuqCsDuTlMlw0vw==",
  }

  file {"/usr/local/sbin/sajama-command-file.py":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0750,
    source => "puppet:///modules/c2c/usr/local/sbin/sajama-command-file.py",
  }

  case $operatingsystem {
    /Ubuntu|Debian/: { include os-base-debian }
    /RedHat|CentOS/: { include os-base-centos }
    default: { fail "Nothing configured for \$operatingsystem $operatingsystem" }
  }
}

