class openvpn::server {
  case $operatingsystem {
    Debian: { include openvpn::server::debian }
    default: { fail "No instruction for $operatingsystem" }
  }
}
