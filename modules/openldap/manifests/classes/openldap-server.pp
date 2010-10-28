class openldap::server {
  case $lsbdistcodename {
    squeeze: { include openldap::server::squeeze }
    default: { fail "No information for $lsbdistcodename" }
  }
}
