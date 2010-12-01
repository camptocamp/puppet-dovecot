class smbldap {
  case $operatingsystem {
    Debian: { include smbldap::debian }
    default: { fail "No instruction for $operatingsystem" }
  }
}
