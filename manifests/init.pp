class subversion {
  package {
    "subversion": ensure => installed;
    "subversion-tools": ensure => installed;
    "xmlstarlet": ensure => installed;
  }
}
