class app-avocatsch-workstation {

  include java::v6
  include apt::unattended-upgrade::automatic

  # default root account
  #user {"root":
  #  ensure   => present,
  #  password => '$1$8a.Bg78Q$VP3nFU5O41o5ATGg10Weq.',
  #  shell    => "/bin/bash"
  #}

  # OpenOffice mime type
  file {"/usr/share/desktop-directories/vnd.openxmlformats-officedocument.wordprocessingml.document.desktop":
    ensure => present,
    source => "puppet:///site-modules/avocatsch/vnd.openxmlformats-officedocument.wordprocessingml.document.desktop",
  }

  # Sudoers
  common::concatfilepart {"sqdf sudoers":
    file  => "/etc/sudoers",
    ensure  => present,
    content => "# SQDF specific rules
User_Alias  ADMIN = subilia,camptocamp,sysadmin
ADMIN   ALL=(root) NOPASSWD:ALL",
  }

  # Hostname set by DHCP
  file {"/etc/dhcp3/dhclient-exit-hooks.d/hostname":
    ensure => present,
    source => "puppet:///site-modules/avocatsch/dhclient-exit-hooks-hostname",
  }

  # NFS /home
  mount {"/home":
    ensure  => mounted,
    device  => "artemis:/home",
    fstype  => "nfs",
    options => "defaults,rw",
    require => Package["nfs-common"],
  }

  # Cups
  file {"/etc/cups/client.conf":
    ensure => present,
    content => "ServerName artemis.sqdf\n",
  }


  ## LDAP authentication

  file {"/var/cache/debconf/ldap-auth-config.preseed":
    source => "puppet:///site-modules/avocatsch/ldap-auth-config.preseed",
  }

  package {"ldap-auth-config":
    ensure       => installed,
    responsefile => "/var/cache/debconf/ldap-auth-config.preseed",
    require      => File["/var/cache/debconf/ldap-auth-config.preseed"],
  }
  package {"libpam-ldap":
    ensure  => present,
    require => Package["ldap-auth-config"],
  }

  file {"/etc/nsswitch.conf":
    ensure => present,
    source => "puppet:///site-modules/avocatsch/ldap-nsswitch.conf",
    notify => Exec["restart nscd"],
  }
  exec {"restart nscd":
    command     => "/etc/init.d/nscd restart",
    refreshonly => true,
  }


  # Additional sources.list

  apt::sources_list{"medibuntu":
    ensure  => present,
    source  => "puppet:///site-modules/avocatsch/medibuntu.lucid.sources.list",
    require => Apt::Key["0C5A2783"],
  }
  apt::key{"0C5A2783":
    content => "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.10 (GNU/Linux)

mQGiBEVmMkERBACje575/Xw5hwzqCcdaf4LgQdPLpTbZLNaVdcGd+D0nskBlQ8VA
tuJngq184aeFjD/XmlosfvidFgSc6w4/LRP/XUtyYcWIUk65tStPK0fggdDIVjC/
SsOY5V+a02+ypSZjxPOQSqG4Lxhs240S6O6tS3CKr/08s6lgD0UEa2Ay6wCgnyEF
zOBXTCwSDXtPUFYXS6pCUDED/3wED5EksgizUCLmz5MNSsKTFUZyxkA65vIs2IoP
RtiWG28TWiOU3N5hrVxQI531sTTOZE97KhHAfSfQajRlQ/1O69RNvRR4pNd3/WKD
OEMlmP6Ow0DV0CPCfOeKiIKvdCY4+278b7LcLXNIwQlG3bBzV/9i5hGTo8nZf8qj
pSxkA/0UIrBUWKhTpx3/VNq9oSFpXBbiB5/6CDGIl0pSptAuKE3I1Xii0dOXyuvS
uqtmWgDBz/12MEqzBt+V+FGvv+oCvO7M2f3nsnFrdbn66Gnsto3xs+6X+9M+vOXz
GH5l7Mbo+M4z84lAZdcKeHC1Mm7b52K5Vj15/CUXr/wFuwVSubQqVGhlIE1lZGli
dW50dSBUZWFtIDxtZWRpYnVudHVAc29zLXN0cy5jb20+iGAEExECACAFAkVmMkEC
GwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAKCRAuvCa2DFongyA5AJ4mvwewcofo
IhNac2AlnYXx1H+XkwCcDPw7UrWC3D1A9f3cTk2RjXq0cGO0NE1lZGlidW50dSBQ
YWNrYWdpbmcgVGVhbSA8YWRtaW5AbGlzdHMubWVkaWJ1bnR1Lm9yZz6IYwQTEQIA
IwIbAwYLCQgHAwIEFQIIAwQWAgMBAh4BAheABQJGatyaAhkBAAoJEC68JrYMWieD
Y9IAn0PXSm7Lgvg/++gAW5eUv0ToBdxxAKCX0pnlHR/7PwxVoh0ueIE98YHENLkC
DQRFZjJfEAgA1iWJ0rqXioomH+GllyzQFDek396dsKxQYi08X+/sYY4ZJ1KE0PEH
8JwZi+dKM0ZpA+/7sXetVYlq8rqRyu/yf4DZdWCMjsB5krXGOgCv51prb8Qo+vMG
SWQ+oHleblS5zkAuAUY487bljSvcdrtg5ITX3UGFgZnMLDO4cfmz8KHwpRlmxKy9
tcGqnuK7f9i/A4VYGRJco/XL0vqyzhJpBiT0jYIjkz2JwExnw6K7hyvyShK7vOsA
z5g8IKLibVpJFyO4gRkcjz9B+DNJxeysy7TVR5yDZIP8VcPe7hdJmdltBnC2Q9Db
sUmI8oVWooZZQPTAX+/XyrXMSj0HEzAIRwADBQf/cfDOSifYN7ZYqk5ZLnFN/AZc
72eVjJD0xA7fKrkZ6glXNqXfjr7MxfmqEymsfNr09RANtSGdBLeAFxeE1Sldsq6p
E58HxWp82RI8XgeCjzVlDOVzT63ck+U2Dh0M7SvIiOP0OUTxgxpujeRLInnFLd9m
NwfFufMlC3NI/VomN8NdIqU7LDuM9xApQ+nTnCOMy8pwqr8mIfc5UUKWAxxguvFn
qY9AiQpGNHhpUebzRehxbEOBL7NEDF94SXI+NGOxz66Uq52UOZES3bBEoLv2s2hq
36boErWbmOmTd1OtxwwjMbqBRCVdIc9QoeNZyZ465e00wx2FZb94LmBCLyxqkYhJ
BBgRAgAJBQJFZjJfAhsMAAoJEC68JrYMWieDhlsAoIFA0h9GaVOgVLQFFw1c4K1W
RGgpAJ43cEsGcAqOxNYcJmo1QWX7jG6EMQ==
=a7Z5
-----END PGP PUBLIC KEY BLOCK-----
",
  }

  exec{"Add ppa kubuntu repository":
    command => "add-apt-repository ppa:kubuntu-ppa/ppa",
    creates => "/etc/apt/sources.list.d/kubuntu-ppa-ppa-lucid.list",
  }
  file{"/etc/apt/sources.list.d/kubuntu-ppa-ppa-lucid.list":
    ensure  => present,
    require => Exec["Add ppa kubuntu repository"],
  }

  if $subilia_bluetooth_kbd != "" {
    # bluetooth configuration
    file {"/root/bluetooth.tar.gz":
      source => "puppet:///site-modules/avocatsch/bluetooth_subilia.tar.gz",
    }
    exec {"install bt config-files":
      command => "tar zxfp /root/bluetooth.tar.gz -C /",
      unless => "grep -r 'MX5000' /var/lib/bluetooth/*",
      require => File["/root/bluetooth.tar.gz"],
    }
  }

  if $diserens_burg != "" {
    # Install burg (grub like bootloader) because the console
    # ouput doesn't work with grub (request from Mr. Subilia)
    apt::sources_list{"burg":
      ensure => present,
      content => "deb http://ppa.launchpad.net/bean123ch/burg/ubuntu lucid main
deb-src http://ppa.launchpad.net/bean123ch/burg/ubuntu lucid main
",
    }
    package {"burg":
      ensure => present,
      require => Apt::Sources_list["burg"],
    }
  }

  # Custom fonts
  file {"/usr/share/fonts/sqdf":
    ensure => directory,
    source => "puppet:///site-modules/avocatsch/fonts",
    recurse => true,
    notify => Exec["refresh fontconfig"],
  }
  package {"fontconfig":
    ensure => installed
  }
  exec{"refresh fontconfig":
    command     => "fc-cache",
    refreshonly => true,
    require     => Package["fontconfig"],
  }

}
