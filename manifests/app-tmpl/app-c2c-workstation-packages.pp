class app-c2c-workstation-packages {

  apt::sources_list {"qgis":
    ensure => present,
    content => "deb http://ppa.launchpad.net/ubuntugis/ppa/ubuntu $lsbdistcodename main",
  }
  apt::key {"314DF160":
    source => "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x089EBE08314DF160",
  }

  package {
    # Multimedia
    "amarok":                           ensure => present;
    "audacious":                        ensure => present;
    "audacious-plugins":                ensure => present;
    "audacity":                         ensure => present;
    "ffmpeg":                           ensure => present;
    "gstreamer0.10-ffmpeg":             ensure => present;
    "gstreamer0.10-plugins-bad":        ensure => present;
    "gstreamer0.10-plugins-ugly":       ensure => present;
    "gstreamer0.10-fluendo-mp3":        ensure => present;
    "gstreamer0.10-sdl":                ensure => present;
    "mpg321":                           ensure => present;
    "k3b":                              ensure => present;
    "totem-xine":                       ensure => present;
    "xine-ui":                          ensure => present;
    "vlc":                              ensure => present;
    "feh":                              ensure => present;
    "flashplugin-nonfree":              ensure => latest;
    "mplayer":                          ensure => present;
    "twinkle":                          ensure => present;
    
    # Office tools
    "openoffice.org-common":            ensure => present;
    "openclipart-openoffice.org":       ensure => present;
    "openclipart-png":                  ensure => present;
    "openclipart-svg":                  ensure => present;
    "gnumeric":                         ensure => present;
    "korganizer":                       ensure => present;
    "thunderbird":                      ensure => present;
    "dia":                              ensure => present;
    "imagemagick":                      ensure => present;
    "inkscape":                         ensure => present;
    "openoffice.org-filter-binfilter":  ensure => present;
    "openoffice.org-gnome":             ensure => present;
    "planner":                          ensure => present;
    "unrar":                            ensure => present;
    "libpg-java":                       ensure => present;
    "acroread":                         ensure => present;

    # Communication
    "xchat-gnome":                      ensure => present;
    "mutt":                             ensure => present;
    "abook":                            ensure => present;
    "pan":                              ensure => present;
    "enigmail":                         ensure => present;
    "urlview":                          ensure => present;
    "chromium-browser":                 ensure => present;
    "chromium-codecs-ffmpeg-extra":     ensure => present;
    "gajim":                            ensure => present;
    "skype":                            ensure => present;
    "freemind":                         ensure => present;

    # Network tools
    "ekiga":                            ensure => present;
    "httptunnel":                       ensure => present;
    "ldap-utils":                       ensure => present;
    "wireshark":                        ensure => present;
    "snmp":                             ensure => present;
    "vlan":                             ensure => present;

    # Language
    "manpages-de":                      ensure => present;
    "openoffice.org-help-en-gb":        ensure => present;
    "manpages-fr":                      ensure => present;
    "language-pack-fr-base":            ensure => present;
    "language-pack-fr":                 ensure => present;
    "language-support-fr":              ensure => present;
    "language-pack-gnome-fr":           ensure => present;
    "language-pack-kde-fr-base":        ensure => present;
    "language-pack-kde-fr":             ensure => present;
    "language-pack-de-base":            ensure => present;
    "language-pack-de":                 ensure => present;
    "language-support-de":              ensure => present;
    "language-pack-gnome-de":           ensure => present;
    "language-pack-kde-de-base":        ensure => present;
    "language-pack-kde-de":             ensure => present;
    "language-pack-en-base":            ensure => present;
    "language-pack-en":                 ensure => present;
    "language-support-en":              ensure => present;
    "language-pack-gnome-en":           ensure => present;
    "language-pack-kde-en-base":        ensure => present;
    "language-pack-kde-en":             ensure => present;
    "thunderbird-gnome-support":        ensure => present;
    "thunderbird-locale-fr":            ensure => present;
    "openoffice.org-help-de":           ensure => present;
    "thunderbird-locale-de":            ensure => present;
    "openoffice.org-l10n-de":           ensure => present;
    "gimp":                             ensure => present;
    "gimp-help-de":                     ensure => present;
    "kde-l10n-de":                      ensure => present;
    "gnome-user-guide-de":              ensure => present;
    "openoffice.org-hyphenation":       ensure => present;
    "openoffice.org-hyphenation-de":    ensure => present;
    "openoffice.org-thesaurus-de":      ensure => present;
    "openoffice.org-thesaurus-de-ch":   ensure => present;
    "kde-l10n-engb":                    ensure => present;
    "gnome-user-guide-en":              ensure => present;
    "openoffice.org-hyphenation-en-us": ensure => present;
    "openoffice.org-thesaurus-en-au":   ensure => present;
    "openoffice.org-thesaurus-en-us":   ensure => present;
    "gnome-user-guide-fr":              ensure => present;
    "gimp-help-fr":                     ensure => present;
    "openoffice.org-l10n-fr":           ensure => present;
    "kde-l10n-fr":                      ensure => present;
    "openoffice.org-help-fr":           ensure => present;
    "openoffice.org-hyphenation-fr":    ensure => present;
    "openoffice.org-thesaurus-fr":      ensure => present;
  
    # Database tools
    "mysql-client":                     ensure => present;
    "postgresql-client":                ensure => present;
    "pgadmin3":                         ensure => present;

    # Development tools
    "eclipse":                          ensure => present;
    "darcs":                            ensure => present;
    "build-essential":                  ensure => present;
    "dchroot":                          ensure => present;
    "manpages-dev":                     ensure => present;
    "colordiff":                        ensure => present;
    "qemu":                             ensure => present;
    "git-core":                         ensure => present;
    "git-svn":                          ensure => present;
    "ack-grep":                         ensure => present;
    "virtualbox-ose":                   ensure => present;
    "virtualbox-ose-guest-utils":       ensure => present;
    "virtualbox-ose-guest-x11":         ensure => present;
    "virtualbox-guest-additions":       ensure => present;

    # GIS Tools
    "grass":                            ensure => present;
    "qcad":                             ensure => present;
    "gdal-bin":                         ensure => present;
    "qgis":                             ensure => present;

   # Misc
    "usermode":                         ensure => present;
    "revelation":                       ensure => present;
    "wodim":                            ensure => present;
    "genisoimage":                      ensure => present;
    "gnupg":                            ensure => present;
    "pinentry-gtk2":                    ensure => present;
    "hipo":                             ensure => present;
    "mdbtools-gmdb":                    ensure => present;
    "ttf-mscorefonts-installer":        ensure => present;
    "nautilus-actions":                 ensure => present;
    "network-manager-pptp":             ensure => present;
    "ttf-dejavu":                       ensure => present;
    "ttf-dejavu-extra":                 ensure => present;
    "wine":                             ensure => present;
    "unison":                           ensure => present;
    "unison-gtk":                       ensure => present;
    "convmv":                           ensure => present;
    "gnome-randr-applet":               ensure => present;
    "xclip":                            ensure => present;
    "seahorse":                         ensure => present;
    "a2ps":                             ensure => present;
    "dict":                             ensure => present;
    "emacs22-nox":                      ensure => present;
    "sshfs":                            ensure => present;
    "clusterssh":                       ensure => present;
    "ksnapshot":                        ensure => present;
    "gparted":                          ensure => present;
    "keepassx":                         ensure => present;
    "pybackpack":                       ensure => present;
    "ubuntu-restricted-extras":         ensure => present;
    "gstreamer0.10-plugins-bad-multiverse":  ensure => present;
    "gstreamer0.10-plugins-ugly-multiverse": ensure => present;
    "gtkpod-aac":                       ensure => present;
    "phonon-backend-xine":              ensure => present;
    "pidgin":                           ensure => present;
    "pidgin-encryption":                ensure => present;
    "pidgin-plugin-pack":               ensure => present;
    "python-setuptools":                ensure => present;
    "gnupg-agent":	                ensure => present;

    # Gestion certificats X509 (VPN SwissTopo)
    "xca":                              ensure => present;
  }

  package {["indicator-messages"]:
    ensure => absent,
  }
    
}
