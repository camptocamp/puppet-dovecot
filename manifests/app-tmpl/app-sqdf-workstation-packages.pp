# Requires: app-sqdf-workstation

class app-sqdf-workstation-packages {

  package {

    # Kubuntu
    "kubuntu-desktop": ensure => present;
    "kubuntu-restricted-extras": ensure => present; #, require => Package["sun-java6-bin"];

    # KDE
    "kontact": ensure => present;
    "kmail": ensure => present;
    "konqueror": ensure => present;
    "kdeadmin": ensure => present;
    "firefox-branding": ensure => present;
    #"kate-plugins": ensure => present;
    "konq-plugins": ensure => present;
    #"kde-extras":
    #  ensure => present,
    #  require => Package["sun-java6-bin"];
    "k3b": ensure => present;
    "kdeartwork": ensure => present;
    "digikam" : ensure => present;
    "kuser" : ensure => present;
    #"kde-guidance" : ensure => present;
    "amarok": ensure => present;
    "kde-icons-crystal": ensure => present;

    # KDE stuff to REMOVE
    "kdepim-strigi-plugins": ensure => absent;
    "strigi-daemon": ensure => absent;

    # Misc
    "kcalc": ensure => present;
    "kdf": ensure => present;
    "numlockx": ensure => present;
    #"vim-full" : ensure => present;
    "kodos": ensure => present;
    "amule": ensure => present;
    "alien": ensure => present;
    "dcraw":  ensure => present;
    "mplayer":  ensure => present;
    "wine": ensure => present;
    "whois": ensure => present;
    "krita": ensure => present;
    "quanta": ensure => present;

    # Languages and dictionaries
    "language-pack-fr": ensure => present;
    "language-pack-kde-en": ensure => present;
    "language-pack-kde-en-base": ensure => present;
    "language-pack-kde-fr": ensure => present;
    "language-pack-kde-fr-base": ensure => present;
    "myspell-en-gb": ensure => present;
    "myspell-en-us": ensure => present;
    "myspell-en-za": ensure => present;
    "myspell-fr-gut": ensure => present;

    # System
    "binutils": ensure => present;
    "nfs-common": ensure => present;
    "portmap": ensure => present;
    "ldap-utils": ensure => present;

    # Scanner
    "sane" : ensure => present;
    "sane-utils" : ensure => present;
    "xsane": ensure => present;

    # Games
    "supertux" : ensure => present;
    "frozen-bubble" : ensure => present;

    # Fonts
    "ttf-mscorefonts-installer": ensure => present;
    "ttf-arphic-bkai00mp": ensure => present;
    "ttf-arphic-bsmi00lp": ensure => present;
    "ttf-arphic-gbsn00lp": ensure => present;
    "ttf-arphic-gkai00mp": ensure => present;
    "ttf-baekmuk": ensure => present;
    "ttf-bengali-fonts": ensure => present;
    "ttf-devanagari-fonts": ensure => present;
    "ttf-gujarati-fonts": ensure => present;
    "ttf-indic-fonts": ensure => present;
    "ttf-kannada-fonts": ensure => present;
    "ttf-oriya-fonts": ensure => present;
    "ttf-punjabi-fonts": ensure => present;
    "ttf-tamil-fonts": ensure => present;
    "ttf-telugu-fonts": ensure => present;
  }

  # Openoffice
  apt::key {"247D1CFF":
    ensure => present,
    source => "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x60D11217247D1CFF",
  }
  apt::sources_list {"openoffice-ppa":
    ensure => present,
    content => "deb http://ppa.launchpad.net/openoffice-pkgs/ppa/ubuntu hardy main \n",
    require => Apt::Key["247D1CFF"],
  }
  package {[
    "openoffice.org",
    "openoffice.org-thesaurus-en-us",
    "openoffice.org-thesaurus-en-au",
    "openoffice.org-thesaurus-de-ch",
    "openoffice.org-thesaurus-de",
    "openoffice.org-l10n-fr",
    "openoffice.org-l10n-en-za",
    "openoffice.org-l10n-en-gb",
    "openoffice.org-l10n-de",
    "openoffice.org-l10n-common",
    "openoffice.org-help-fr",
    "openoffice.org-help-en-us",
    "openoffice.org-help-en-gb",
    "openoffice.org-help-de",
    "openoffice.org-hyphenation",
    "openoffice.org-hyphenation-de",
    "openoffice.org-hyphenation-en-us",
    ]:
    ensure => latest,
    require => Apt::Sources_list["openoffice-ppa"],
  }
  # rt#15028
  package {"openoffice.org-kde": 
    ensure => absent,
  }

}
