class stunnel4 {
  case $operatingsystem {
    Debian:  { include stunnel4::debian }
    default: { fail "No instruction for $operatingsystem" }
  }
}
