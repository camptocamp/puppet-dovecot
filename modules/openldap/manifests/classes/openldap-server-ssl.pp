class openldap::server::ssl {
  case $lsbdistcodename {
    squeeze: { include openldap::server::ssl::squeeze }
    default: { fail "No information for $lsbdistcodename" }
  }
}

